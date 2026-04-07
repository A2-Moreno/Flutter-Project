import '../repositories/i_activity_repository.dart';
import '../models/activity_model.dart';

class GetActivitiesByCategory {
  final IActivityRepository repository;
  GetActivitiesByCategory(this.repository);

  Future<List<Activity>> execute(String categoryId) {
    return repository.getActivitiesByCategory(categoryId);
  }
}
