abstract class IGroupDetailRemoteDataSource {
  Future<List<dynamic>> read({
    required String table,
    Map<String, String>? filters,
  });
}