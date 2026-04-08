import '../repositories/i_evaluation_repository.dart';

class GetMyEvaluations {
  final IEvaluationRepository repository;

  GetMyEvaluations(this.repository);

  Future<List<Map<String, dynamic>>> execute(
    String activityId,
    String userId,
  ) {
    return repository.getMyEvaluations(activityId, userId);
  }
}