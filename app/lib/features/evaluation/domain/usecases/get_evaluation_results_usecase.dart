import '../models/evaluation_result_model.dart';
import '../repositories/i_evaluation_repository.dart';

class GetEvaluationResults {
  final IEvaluationRepository repository;

  GetEvaluationResults(this.repository);

  Future<List<EvaluationResult>> execute(
    String activityId,
    String userId,
  ) {
    return repository.getEvaluationResults(
      activityId,
      userId,
    );
  }
}