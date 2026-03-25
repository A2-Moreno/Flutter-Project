import '../datasource/i_course_source.dart';
import '../../domain/repositories/i_course_repository.dart';

class CourseRepository implements ICourseRepository {
  final ICourseRemoteDataSource remote;

  CourseRepository(this.remote);

  @override
  Future<List<Map<String, dynamic>>> getCoursesByUserEmail() {
    return remote.getCoursesByUserEmail();
  }
}