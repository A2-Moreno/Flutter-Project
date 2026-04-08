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
    error.value = "";

    final userId = await prefs.getString("userId");
    if (userId == null) throw Exception("UserId no encontrado");

    final raw = await getResultsUsecase.execute(activity.id, userId);

    if (raw.isEmpty) {
      mySummary.value = {
        "name": "Tu resultado",
        "average": "0.0",
        "criteria": [],
      };
      publicResults.clear();
      return;
    }

    final Map<String, List<double>> global = {};

    for (final r in raw) {
      r.scoresByCriterion.forEach((criterion, scores) {
        global.putIfAbsent(criterion, () => []);
        global[criterion]!.addAll(scores);
      });
    }

    final criteriaList = global.entries.map((e) {
      if (e.value.isEmpty) {
        return {
          "label": e.key,
          "score": "0.0",
        };
      }

      final avg =
          e.value.reduce((a, b) => a + b) / e.value.length;

      return {
        "label": e.key,
        "score": avg.toStringAsFixed(1),
      };
    }).toList();

    final allScores = global.values.expand((e) => e).toList();

    final totalAvg = allScores.isEmpty
        ? 0.0
        : allScores.reduce((a, b) => a + b) / allScores.length;

    mySummary.value = {
      "name": "Tu resultado",
      "average": totalAvg.toStringAsFixed(1),
      "criteria": criteriaList,
    };

    final List<Map<String, dynamic>> others = [];

    for (final r in raw) {
      if (r.scoresByCriterion.isEmpty) continue;

      final list = r.scoresByCriterion.entries.map((e) {
        if (e.value.isEmpty) {
          return {
            "label": e.key,
            "score": "0.0",
          };
        }

        final avg =
            e.value.reduce((a, b) => a + b) / e.value.length;

        return {
          "label": e.key,
          "score": avg.toStringAsFixed(1),
        };
      }).toList();

      if (list.isEmpty) continue;

      final total = list.isEmpty
          ? 0.0
          : list
                  .map((e) => double.tryParse(e["score"] ?? "0") ?? 0.0)
                  .reduce((a, b) => a + b) /
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