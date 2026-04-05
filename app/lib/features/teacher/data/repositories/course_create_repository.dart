import '../../../teacher/domain/models/course_model.dart';
import '../../domain/repositories/i_course_create_repository.dart';
import '../datasources/i_course_create_source.dart';

class CourseCreateRepository implements ICourseCreateRepository {
  final ICourseCreateRemoteDataSource remoteDataSource;

  CourseCreateRepository(this.remoteDataSource);

  @override
  Future<void> createCourse(Course course) async {
    await remoteDataSource.createCourse(course);
  }
}