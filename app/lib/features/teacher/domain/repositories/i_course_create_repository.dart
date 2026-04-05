import '../models/course_model.dart';

abstract class ICourseCreateRepository {
  Future<void> createCourse(Course course);
}