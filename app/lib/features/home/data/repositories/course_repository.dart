import '../datasource/i_course_source.dart';
import '../../domain/repositories/i_course_repository.dart';
import '../datasource/course_cache_data_source.dart';
import 'package:loggy/loggy.dart';

class CourseRepository implements ICourseRepository {
  final ICourseRemoteDataSource remote;
  final LocalCourseCacheSource cache;

  CourseRepository(this.remote, this.cache);

  @override
  Future<List<Map<String, dynamic>>> getCoursesByUserEmail() async {
    try {
      if (await cache.isCacheValid()) {
        logInfo("🔍 Fetching courses from CACHE");
        return await cache.getCachedCourses();
      }
    } catch (_) {}

    final courses = await remote.getCoursesByUserEmail();

    List<Map<String, dynamic>> enriched = [];

    for (final course in courses) {
      final courseId = course["_id"];
      final count = await remote.getActivitiesCountByCourse(courseId);
      enriched.add({...course, "activities": count});
    }

    await cache.cacheCourses(enriched);

    return enriched;
  }

  @override
  Future<void> clearCache() async {
    try {
      await cache.clearCache();
    } catch (e) {
      logError("Error clearing course cache: $e");
    }
  }

}
