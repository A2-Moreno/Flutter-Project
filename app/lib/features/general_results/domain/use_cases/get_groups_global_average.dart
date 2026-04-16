import '../repositories/i_global_avereges_repository.dart';
import '../models/groups_global_average_model.dart';

class GetGroupsGlobalAverage {
  final IGeneralResultsRepository repository;

  GetGroupsGlobalAverage(this.repository);

  Future<List<GroupActivityAverage>> execute(String courseId) {
    return repository.getGroupsGlobalAverage(courseId);
  }
}