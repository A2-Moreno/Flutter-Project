import 'package:get/get.dart';
import '../../../../core/i_local_preferences.dart';
import '../../domain/usecases/get_evaluation_results_usecase.dart';
import '../../../activity/domain/models/activity_model.dart';


class ResultsController extends GetxController {
  final GetEvaluationResults getResultsUsecase;

  ResultsController(this.getResultsUsecase);


  final prefs = Get.find<ILocalPreferences>();
  final isLoading = false.obs;
  final error = "".obs;

  final mySummary = Rxn<Map<String, dynamic>>();
  final publicResults = <Map<String, dynamic>>[].obs;

  Future<void> buildResults(Activity activity) async {
    try {
      isLoading.value = true;

      final userId = await prefs.getString("userId");
      if (userId == null) throw Exception("UserId no encontrado");

      final raw = await getResultsUsecase.execute(activity.id, userId);

      final Map<String, List<double>> global = {};

      for (final r in raw) {
        r.scoresByCriterion.forEach((criterion, scores) {
          global.putIfAbsent(criterion, () => []);
          global[criterion]!.addAll(scores);
        });
      }

      final criteriaList = global.entries.map((e) {
        final avg = e.value.reduce((a, b) => a + b) / e.value.length;

        return {
          "label": e.key,
          "score": avg.toStringAsFixed(1),
        };
      }).toList();

      final totalAvg =
          global.values.expand((e) => e).reduce((a, b) => a + b) /
          global.values.expand((e) => e).length;

      mySummary.value = {
        "name": "Tu resultado",
        "average": totalAvg.toStringAsFixed(1),
        "criteria": criteriaList,
      };

      final List<Map<String, dynamic>> others = [];

      for (final r in raw) {
        final list = r.scoresByCriterion.entries.map((e) {
          final avg =
              e.value.reduce((a, b) => a + b) / e.value.length;

          return {
            "label": e.key,
            "score": avg.toStringAsFixed(1),
          };
        }).toList();

        final total =
            list.map((e) => double.parse(e["score"]!)).reduce((a, b) => a + b) /
            list.length;

        others.add({
          "name": r.evaluatorName,
          "average": total.toStringAsFixed(1),
          "criteria": list,
        });
      }

      publicResults.assignAll(others);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}