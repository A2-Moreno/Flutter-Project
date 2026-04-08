import '../models/evaluation_result_model.dart';

abstract class IEvaluationRepository {
  /// Crear evaluación completa (evaluation + scores)
  Future<void> submitEvaluation(
    String activityId,
    String groupId,
    String evaluatorId,
    Map<String, Map<String, double>> data,
  );

  /// Saber si el usuario ya evaluó
  Future<bool> hasUserEvaluated(String activityId, String evaluatorId);

  /// Obtener resultados de una actividad para un usuario
  Future<List<EvaluationResult>> getEvaluationResults(
    String activityId,
    String userId,
  );

  Future<List<Map<String, dynamic>>> getMyEvaluations(
    String activityId,
    String userId,
  );

  Future<List<Map<String, dynamic>>> getScoresByEvaluation(String evaluationId);
}
