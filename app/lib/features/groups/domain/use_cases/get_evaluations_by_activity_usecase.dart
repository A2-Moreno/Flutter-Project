import '../repositories/i_group_repository.dart';

class GetGlobalAverage {
  final IGroupDetailRepository repository;

  GetGlobalAverage(this.repository);

  Future<double> execute(String activityId) {
    return repository.getGlobalAverage(activityId);
  }
}