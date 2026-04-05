import '../models/all_groups_model.dart';
import '../repositories/i_group_repository.dart';


class GetAllMyGroups {
  final IGroupDetailRepository repository;

  GetAllMyGroups(this.repository);

  Future<List<AllMyGroups>> execute(String courseId, String userId) {
    return repository.getAllMyGroups(courseId ,userId);
  }

}
