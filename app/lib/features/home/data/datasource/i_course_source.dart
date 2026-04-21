abstract class ICourseRemoteDataSource {
  Future<List<Map<String, dynamic>>> getCoursesByUserEmail();

  Future<int> getActivitiesCountByCourse(String courseId);
}