import '../../domain/models/activity_model.dart';
import '../../domain/repositories/i_activity_repository.dart';
import '../datasources/i_activity_remote_datasource.dart';
import '../datasources/activity_cache_data_source.dart';
import 'package:loggy/loggy.dart';

class ActivityRepositoryImpl implements IActivityRepository {
  final IActivityRemoteDataSource remote;
  final LocalActivityCacheSource cache;

  ActivityRepositoryImpl(this.remote, this.cache);

  @override
  Future<void> createActivity(Activity activity) async {
    await remote.createActivity(activity);

    await cache.clearCache(activity.courseId);
  }

  @override
  Future<List<Activity>> getActivitiesByCourse(String courseId) async {
    try {
      if (await cache.isCacheValid(courseId)) {
        logInfo("Acrividades desde cache");
        return await cache.getCachedActivities(courseId);
      }
    } catch (_) {}

    logInfo("Actividades desde API");

    final data = await remote.getActivitiesByCourse(courseId);

    await cache.cacheActivities(courseId, data);

    return data;
  }

  @override
  Future<List<Activity>> getActivitiesByCategory(String categoryId) {
    return remote.getActivitiesByCategory(categoryId);
  }

  @override
  Future<void> clearCacheByCourse(String courseId) async {
    await cache.clearCache(courseId);
  }
}
