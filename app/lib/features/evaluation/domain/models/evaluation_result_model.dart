import './evaluation_details_model.dart';

class EvaluationResult {
  final String evaluatorId;
  final String evaluatorName;

  final Map<String, List<double>> scoresByCriterion;

  /*final List<EvaluationDetail> details;*/

  EvaluationResult({
    required this.evaluatorId,
    required this.evaluatorName,
    required this.scoresByCriterion,
    /*required this.details,*/
  });

  // helper para promedio
  Map<String, double> get averages {
    final Map<String, double> result = {};

    scoresByCriterion.forEach((criterion, scores) {
      final avg = scores.reduce((a, b) => a + b) / scores.length;
      result[criterion] = avg;
    });

    return result;
  }
}
