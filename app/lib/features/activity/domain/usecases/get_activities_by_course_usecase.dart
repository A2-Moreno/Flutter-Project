import '../repositories/i_activity_repository.dart';
import '../models/activity_model.dart';

class GetActivitiesByCourse {
  final IActivityRepository repository;

  GetActivitiesByCourse(this.repository);

  Future<List<Activity>> execute(String courseId) {
    return repository.getActivitiesByCourse(courseId);
  }
}
