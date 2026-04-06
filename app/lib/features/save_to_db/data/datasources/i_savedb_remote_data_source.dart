abstract class IGroupRemoteDataSource {
  Future<String> createCategory(String courseId, String name);

  Future<String> createGroup(String categoryId, String name, String code);

  Future<String> getOrCreateUser(String email, String name);

  Future<void> addUserToCourse(String userId, String courseId);

  Future<void> addUserToGroup(String userId, String groupId);
}
