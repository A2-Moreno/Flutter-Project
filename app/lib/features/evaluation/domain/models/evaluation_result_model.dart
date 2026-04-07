import './evaluation_details_model.dart';

class EvaluationResult {
  final String evaluatedUserId;
  final String evaluatedUserName;

  final Map<String, List<double>> scoresByCriterion;

  /*final List<EvaluationDetail> details;*/

  EvaluationResult({
    required this.evaluatedUserId,
    required this.evaluatedUserName,
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
