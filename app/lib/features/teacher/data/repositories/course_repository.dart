import '../../../teacher/domain/models/course_model.dart';
import '../../../teacher/domain/repositories/i_course_repository.dart';
import '../datasources/i_course_source.dart';

class CourseRepository implements ICourseRepository {
  final ICourseRemoteDataSource remoteDataSource;

  CourseRepository(this.remoteDataSource);

  @override
  Future<void> createCourse(Course course) async {
    await remoteDataSource.createCourse(course);
  }
}