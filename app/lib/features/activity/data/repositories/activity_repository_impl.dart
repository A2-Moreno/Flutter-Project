import '../../domain/models/activity_model.dart';
import '../../domain/repositories/i_activity_repository.dart';
import '../datasources/i_activity_remote_datasource.dart';

class ActivityRepositoryImpl implements IActivityRepository {

  final IActivityRemoteDataSource remote;

  ActivityRepositoryImpl(this.remote);

  @override
  Future<void> createActivity(Activity activity) {
    return remote.createActivity(activity);
  }

  @override
  Future<List<Activity>> getActivitiesByCategory(String categoryId) {
    return remote.getActivitiesByCategory(categoryId);
  }

  @override
  Future<List<Activity>> getActivitiesByCourse(String courseId) {
    return remote.getActivitiesByCourse(courseId);
  }
}