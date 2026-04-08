import '../repositories/i_evaluation_repository.dart';

class GetScoresByEvaluation {
  final IEvaluationRepository repository;

  GetScoresByEvaluation(this.repository);

  Future<List<Map<String, dynamic>>> execute(String evaluationId) {
    return repository.getScoresByEvaluation(evaluationId);
  }
}