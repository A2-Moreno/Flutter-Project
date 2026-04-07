import '../../domain/models/activity_model.dart';

abstract class IActivityRemoteDataSource {

  Future<void> createActivity(Activity activity);

  Future<List<Activity>> getActivitiesByCategory(String categoryId);

  Future<List<Activity>> getActivitiesByCourse(String courseId);
}