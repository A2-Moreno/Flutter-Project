import '../../../import_csv/domain/models/group_model.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/i_savedb_remote_data_source.dart';

class GroupDbRepositoryImpl implements IGroupDbRepository {

  final IGroupRemoteDataSource remote;

  GroupDbRepositoryImpl(this.remote);

  @override
  Future<List<Group>> importGroups() {
    throw UnimplementedError();
  }

  @override
  Future<void> saveGroupsToDb(String courseId, List<Group> groups) async {

    for (final group in groups) {

      final categoryId = await remote.createCategory(
        courseId,
        group.categoryName,
      );

      final groupId = await remote.createGroup(
        categoryId,
        group.groupNumber,
        group.groupCode,
      );

      for (final student in group.students) {

        final userId = await remote.getOrCreateUser(
          student.email,
          student.name,
        );

        await remote.addUserToCourse(userId, courseId);

        await remote.addUserToGroup(userId, groupId);
      }
    }
  }
}