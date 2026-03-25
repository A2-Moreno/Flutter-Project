abstract class ICourseRemoteDataSource {
  Future<List<Map<String, dynamic>>> getCoursesByUserEmail();
}