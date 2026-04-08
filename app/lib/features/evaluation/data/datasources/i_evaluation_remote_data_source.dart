abstract class IEvaluationRemoteDataSource {

  Future<bool> hasUserEvaluated(
    String activityId,
    String evaluatorId,
  );

  Future<void> submitEvaluation(
    String activityId,
    String groupId,
    String evaluatorId,
    Map<String, Map<String, double>> data,
  );

  Future<List<Map<String, dynamic>>> getEvaluationsByUser(
    String activityId,
    String userId,
  );

  Future<List<Map<String, dynamic>>> getScoresByEvaluation(
    String evaluationId,
  );

  Future<Map<String, dynamic>?> getUserById(String userId);
}