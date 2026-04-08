import '../repositories/i_evaluation_repository.dart';

class HasUserEvaluated {
  final IEvaluationRepository repository;

  HasUserEvaluated(this.repository);

  Future<bool> execute(
    String activityId,
    String evaluatorId,
  ) {
    return repository.hasUserEvaluated(
      activityId,
      evaluatorId,
    );
  }
}