abstract class ICourseRepository {
  Future<List<Map<String, dynamic>>> getCoursesByUserEmail();
}

