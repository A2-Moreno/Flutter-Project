abstract class IGeneralRemoteDataSource {
  Future<List<Map<String, dynamic>>> read({
    required String table,
    Map<String, String>? filters,
  });

  Future<List<Map<String, dynamic>>> getActivitiesByCourse(String courseId);

  Future<List<Map<String, dynamic>>> getEvaluationsByActivity(
    String activityId,
  );

  Future<List<Map<String, dynamic>>> getScoresByEvaluation(
    String evaluationId,
  );

  Future<Map<String, dynamic>?> getUserById(String userId);
}