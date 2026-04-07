import '../repositories/i_evaluation_repository.dart';

class SubmitEvaluation {
  final IEvaluationRepository repository;

  SubmitEvaluation(this.repository);

  Future<void> execute(
    String activityId,
    String groupId,
    String evaluatorId,
    Map<String, Map<String, double>> data,
  ) {
    return repository.submitEvaluation(
      activityId,
      groupId,
      evaluatorId,
      data,
    );
  }
}