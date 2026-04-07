import '../repositories/i_group_repository.dart';
import '../models/group_model.dart';

class GetMyGroup {
  final IGroupDetailRepository repository;

  GetMyGroup(this.repository);

  Future<Group?> execute(
    String activityId,
    String userId,
  ) {
    return repository.getMyGroup(activityId, userId);
  }
}