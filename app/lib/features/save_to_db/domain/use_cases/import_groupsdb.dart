import '../../domain/repositories/group_repository.dart';
import '../../../import_csv/domain/models/group_model.dart';

class ImportGroupsToDb {
  final IGroupDbRepository repository;

  ImportGroupsToDb(this.repository);

  Future<void> execute(String courseId, List<Group> groups) {
    return repository.saveGroupsToDb(courseId, groups);
  }
}