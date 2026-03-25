import '../../../import_csv/domain/models/group_model.dart';

abstract class IGroupDbRepository {
  Future<List<Group>> importGroups();

  Future<void> saveGroupsToDb(String courseId, List<Group> groups);
}