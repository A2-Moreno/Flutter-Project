import '../../domain/models/group_member_model.dart';
import '../../domain/models/group_model.dart';
import '../../domain/models/all_groups_model.dart';
import '../../domain/repositories/i_group_repository.dart';
import '../datasources/i_group_source_service_roble.dart';
import '../datasources/group_cache_data_source.dart';
import 'package:loggy/loggy.dart';
import '../datasources/all_my_groups_cache_data_source.dart';

class GroupDetailRepositoryImpl implements IGroupDetailRepository {
  final IGroupDetailRemoteDataSource remote;
  final LocalGroupCacheSource cache;
  final LocalAllMyGroupsCache allMyGroupsCache;

  GroupDetailRepositoryImpl(this.remote, this.cache, this.allMyGroupsCache);

  Future<String> _getCategoryIdFromActivity(String activityId) async {
    final activityData = await remote.read(
      table: "activity",
      filters: {"_id": activityId},
    );

    if (activityData.isEmpty) {
      throw Exception("Activity no encontrada");
    }

    return activityData.first["category_id"];
  }

  // =============================
  // PROFESOR
  // =============================
  @override
  Future<List<Group>> getGroupsByCategory(String activityId) async {
    final categoryId = await _getCategoryIdFromActivity(activityId);

    try {
      if (await cache.isCacheValid(categoryId)) {
        logInfo("Grupos desde cache");
        return await cache.getCachedGroups(categoryId);
      }
    } catch (_) {}

    logInfo("Grupos desde API");

    final groups = await remote.read(
      table: "groups",
      filters: {"category_id": categoryId},
    );

    final membersResponses = await Future.wait(
      groups.map((g) {
        return remote.read(
          table: "group_members",
          filters: {"group_id": g["_id"]},
        );
      }),
    );

    // Cache
    final Map<String, Map<String, dynamic>> usersCache = {};

    final Set<String> userIds = {};

    for (final members in membersResponses) {
      for (final m in members) {
        userIds.add(m["estudiante_id"]);
      }
    }

    // Traer usuarios una soloa vez (con cache)
    await Future.wait(
      userIds.map((id) async {
        final userData = await remote.read(
          table: "Users",
          filters: {"userId": id},
        );

        if (userData.isNotEmpty) {
          usersCache[id] = userData.first;
        }
      }),
    );

    List<Group> result = [];

    for (int i = 0; i < groups.length; i++) {
      final group = groups[i];
      final membersData = membersResponses[i];

      List<GroupMember> members = [];

      for (final member in membersData) {
        final userId = member["estudiante_id"];
        final user = usersCache[userId];

        if (user != null) {
          members.add(
            GroupMember(
              userId: user["userId"],
              name: user["name"],
              email: user["email"],
            ),
          );
        }
      }

      result.add(
        Group(
          id: group["_id"],
          name: group["name"],
          code: group["code"],
          members: members,
        ),
      );
    }

    await cache.cacheGroups(categoryId, result);
    return result;
  }

  // =============================
  // ESTUDIANTE (1 grupo por actividad)
  // =============================
  @override
  Future<Group?> getMyGroup(String activityId, String userId) async {
    final categoryId = await _getCategoryIdFromActivity(activityId);

    final memberships = await remote.read(
      table: "group_members",
      filters: {"estudiante_id": userId},
    );

    for (final membership in memberships) {
      final groupId = membership["group_id"];

      final groupData = await remote.read(
        table: "groups",
        filters: {"_id": groupId},
      );

      if (groupData.isEmpty) continue;

      final group = groupData.first;

      if (group["category_id"].toString() != categoryId.toString()) {
        continue;
      }

      final membersData = await remote.read(
        table: "group_members",
        filters: {"group_id": groupId},
      );

      List<GroupMember> members = [];

      for (final member in membersData) {
        final userData = await remote.read(
          table: "Users",
          filters: {"userId": member["estudiante_id"]},
        );

        if (userData.isNotEmpty) {
          final user = userData.first;
          if (userId != user["userId"]) {
            members.add(
              GroupMember(
                userId: user["userId"],
                name: user["name"],
                email: user["email"],
              ),
            );
          }
        }
      }

      return Group(
        id: groupId,
        name: group["name"],
        code: group["code"],
        members: members,
      );
    }

    return null;
  }

  // =============================
  // ESTUDIANTE (TODOS SUS GRUPOS EN UN CURSO)
  // =============================
  @override
  Future<List<AllMyGroups>> getAllMyGroups(
    String courseId,
    String userId,
  ) async {
    try {
      if (await allMyGroupsCache.isValid(courseId, userId)) {
        print("📦 AllMyGroups desde cache");
        return await allMyGroupsCache.get(courseId, userId);
      }
    } catch (_) {}

    print("AllMyGroups desde API");

    final memberships = await remote.read(
      table: "group_members",
      filters: {"estudiante_id": userId},
    );

    List<AllMyGroups> result = [];

    for (final membership in memberships) {
      final groupId = membership["group_id"];

      final groupData = await remote.read(
        table: "groups",
        filters: {"_id": groupId},
      );

      if (groupData.isEmpty) continue;

      final group = groupData.first;
      final categoryId = group["category_id"];

      final categoryData = await remote.read(
        table: "category",
        filters: {"_id": categoryId},
      );

      if (categoryData.isEmpty) continue;

      final category = categoryData.first;

      if (category["course_id"].toString() != courseId.toString()) {
        continue;
      }

      final members = await remote.read(
        table: "group_members",
        filters: {"group_id": groupId},
      );

      result.add(
        AllMyGroups(
          categoryName: category["name"],
          groupName: group["name"],
          membersCount: members.length,
        ),
      );
    }
    await allMyGroupsCache.save(courseId, userId, result);
    return result;
  }

  @override
  Future<double> getGlobalAverage(String activityId) async {
    final evaluations = await remote.getEvaluationsByActivity(activityId);

    if (evaluations.isEmpty) return 0.0;

    List<double> allScores = [];

    for (final eval in evaluations) {
      final evaluationId = eval["_id"];

      final scores = await remote.getScoresByEvaluation(evaluationId);

      for (final s in scores) {
        allScores.add((s["score"] as num).toDouble());
      }
    }

    if (allScores.isEmpty) return 0.0;
    return allScores.reduce((a, b) => a + b) / allScores.length;
  }

  @override
  Future<void> clearAllMyGroupsCache(String courseId, String userId) async {
    await allMyGroupsCache.clear(courseId, userId);
  }
}
