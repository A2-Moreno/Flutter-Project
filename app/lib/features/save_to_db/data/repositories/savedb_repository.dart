import '../../../import_csv/domain/models/group_model.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/i_savedb_remote_data_source.dart';

class GroupDbRepositoryImpl implements IGroupDbRepository {

  final IGroupRemoteDataSource remote;
  final Map<String, String> userCache = {};
  final Map<String, String> categoryCache = {};
  final Map<String, String> groupCache = {};
  GroupDbRepositoryImpl(this.remote);

  @override
  Future<List<Group>> importGroups() {
    throw UnimplementedError();
  }

  @override
  Future<void> saveGroupsToDb(String courseId, List<Group> groups) async {

    for (final group in groups) {

      String categoryId;
      if (categoryCache.containsKey(group.categoryName)) {
        categoryId = categoryCache[group.categoryName]!;
      } else {
        categoryId = await remote.createCategory(courseId, group.categoryName);
        categoryCache[group.categoryName] = categoryId;
      }

      String groupId;
      if (groupCache.containsKey(group.groupCode)) {
        groupId = groupCache[group.groupCode]!;
      } else {
        groupId = await remote.createGroup(
          categoryId,
          group.groupNumber,
          group.groupCode,
        );
        groupCache[group.groupCode] = groupId;
      }

      await Future.wait(
        group.students.map((student) async {
          String userId;

          if (userCache.containsKey(student.email)) {
            userId = userCache[student.email]!;
          } else {
            userId = await remote.getOrCreateUser(student.email, student.name);
            userCache[student.email] = userId;
          }

          await Future.wait([
            remote.addUserToCourse(userId, courseId),
            remote.addUserToGroup(userId, groupId),
          ]);
        }),
      );
    }
  }
}
