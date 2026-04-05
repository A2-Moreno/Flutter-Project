import '../../../teacher/domain/models/course_model.dart';

abstract class ICourseCreateRemoteDataSource {
  Future<void> createCourse(Course course);
}