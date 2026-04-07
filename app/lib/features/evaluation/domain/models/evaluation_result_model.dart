class EvaluationResult {
  final String evaluatedUserId;
  final String evaluatedUserName;

  // criterio -> lista de notas
  final Map<String, List<double>> scoresByCriterion;

  EvaluationResult({
    required this.evaluatedUserId,
    required this.evaluatedUserName,
    required this.scoresByCriterion,
  });

  // helper para promedio
  Map<String, double> get averages {
    final Map<String, double> result = {};

    scoresByCriterion.forEach((criterion, scores) {
      final avg =
          scores.reduce((a, b) => a + b) / scores.length;
      result[criterion] = avg;
    });

    return result;
  }
}