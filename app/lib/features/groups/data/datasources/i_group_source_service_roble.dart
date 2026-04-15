abstract class IGroupDetailRemoteDataSource {
  Future<List<dynamic>> read({
    required String table,
    Map<String, String>? filters,
  });
  Future<List<Map<String, dynamic>>> getEvaluationsByActivity(
    String activityId,
  );
  Future<List<Map<String, dynamic>>> getScoresByEvaluation(String evaluationId);
}