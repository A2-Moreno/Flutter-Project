import '../datasource/i_course_source.dart';
import '../../domain/repositories/i_course_repository.dart';

class CourseRepository implements ICourseRepository {
  final ICourseRemoteDataSource remote;

  CourseRepository(this.remote);

  @override
  Future<List<Map<String, dynamic>>> getCoursesByUserEmail() async {
    final courses = await remote.getCoursesByUserEmail();

    List<Map<String, dynamic>> result = [];

    for (final course in courses) {
      final courseId = course["_id"];

      final count = await remote.getActivitiesCountByCourse(courseId);

      final enriched = {...course, "activities": count};

      result.add(enriched);
    }

    return result;
  }
}
