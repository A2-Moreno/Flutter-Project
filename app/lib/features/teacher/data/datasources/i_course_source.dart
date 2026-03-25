import '../../../teacher/domain/models/course_model.dart';

abstract class ICourseRemoteDataSource {
  Future<void> createCourse(Course course);
}