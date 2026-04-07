class EvaluationDetail {
  final String evaluatorId;
  final String evaluatorName;

  final Map<String, double> scores;

  EvaluationDetail({
    required this.evaluatorId,
    required this.evaluatorName,
    required this.scores,
  });
}