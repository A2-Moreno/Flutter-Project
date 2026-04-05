import '../../domain/models/group_member_model.dart';
import '../../domain/models/group_model.dart';
import '../../domain/repositories/i_group_repository.dart';
import '../datasources/i_group_source_service_roble.dart';

class GroupDetailRepositoryImpl implements IGroupDetailRepository {
  final IGroupDetailRemoteDataSource remote;

  GroupDetailRepositoryImpl(this.remote);

  // =============================
  // PROFESOR
  // =============================
  @override
  Future<List<Group>> getGroupsByCategory(String categoryId) async {
    final groups = await remote.read(
      table: "groups",
      filters: {"category_id": categoryId},
    );

    List<Group> result = [];

    for (final group in groups) {
      final groupId = group["_id"];

      final membersData = await remote.read(
        table: "group_members",
        filters: {"group_id": groupId},
      );

      List<GroupMember> members = [];

      for (final member in membersData) {
        final userId = member["estudiante_id"];

        final userData = await remote.read(
          table: "Users",
          filters: {"userId": userId},
        );

        if (userData.isNotEmpty) {
          final user = userData.first;

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
          id: groupId,
          name: group["name"],
          code: group["code"],
          members: members,
        ),
      );
    }

    return result;
  }

  // =============================
  // ESTUDIANTE
  // =============================
  @override
  Future<Group?> getMyGroup(String categoryId, String userId) async {
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

      if (group["category_id"] != categoryId) continue;

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

          members.add(
            GroupMember(
              userId: user["userId"],
              name: user["name"],
              email: user["email"],
            ),
          );
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
}
