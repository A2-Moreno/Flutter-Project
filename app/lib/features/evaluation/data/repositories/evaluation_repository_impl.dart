import '../../domain/models/evaluation_result_model.dart';
import '../../domain/repositories/i_evaluation_repository.dart';
import '../datasources/i_evaluation_remote_data_source.dart';

class EvaluationRepositoryImpl implements IEvaluationRepository {
  final IEvaluationRemoteDataSource remote;

  EvaluationRepositoryImpl(this.remote);

  @override
  Future<bool> hasUserEvaluated(String activityId, String evaluatorId) {
    return remote.hasUserEvaluated(activityId, evaluatorId);
  }

  @override
  Future<void> submitEvaluation(
    String activityId,
    String groupId,
    String evaluatorId,
    Map<String, Map<String, double>> data,
  ) {
    return remote.submitEvaluation(activityId, groupId, evaluatorId, data);
  }

  @override
  Future<List<EvaluationResult>> getEvaluationResults(
    String activityId,
    String userId,
  ) async {
    final evaluations = await remote.getEvaluations(activityId, userId);

    List<EvaluationResult> results = [];

    for (final eval in evaluations) {
      final evaluationId = eval["_id"];
      final evaluatorId = eval["evaluator_id"];

      final scores = await remote.getScoresByEvaluation(evaluationId);

      final evaluator = await remote.getUserById(evaluatorId);

      final Map<String, List<double>> grouped = {};

      for (final s in scores) {
        final criterion = s["criterion"];
        final score = (s["score"] as num).toDouble();

        grouped.putIfAbsent(criterion, () => []);
        grouped[criterion]!.add(score);
      }

      results.add(
        EvaluationResult(
          evaluatorId: evaluatorId,
          evaluatorName: evaluator?["name"] ?? "Desconocido",
          scoresByCriterion: grouped,
        ),
      );
    }

    return results;
  }

  @override
  Future<List<Map<String, dynamic>>> getMyEvaluations(
    String activityId,
    String userId,
  ) {
    return remote.getEvaluationsByUser(activityId, userId);
  }

  @override
  Future<List<Map<String, dynamic>>> getScoresByEvaluation(
    String evaluationId,
  ) {
    return remote.getScoresByEvaluation(evaluationId);
  }
}
