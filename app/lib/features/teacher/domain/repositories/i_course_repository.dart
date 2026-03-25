import '../models/course_model.dart';

abstract class ICourseRepository {
  Future<void> createCourse(Course course);
}