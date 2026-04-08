import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../domain/usecases/get_evaluation_results_usecase.dart';
import '../../../groups/domain/models/group_model.dart';
import '../../../activity/domain/models/activity_model.dart';

class TeacherResultsController extends GetxController {
  final GetEvaluationResults getResultsUsecase;

  TeacherResultsController(this.getResultsUsecase);

  final isLoading = false.obs;
  final error = "".obs;

  final studentsResults = <Map<String, dynamic>>[].obs;

  // =============================
  // MAIN
  // =============================
  Future<void> loadGroupResults(
    Activity activity,
    Group group,
  ) async {
    try {
      isLoading.value = true;
      error.value = "";

      final members = group.members;

      if (members.isEmpty) {
        studentsResults.clear();
        return;
      }

      // 🔥 1. LLAMADAS EN PARALELO (CLAVE)
      final futures = members.map((member) async {
        return await _buildStudentResult(
          activity.id,
          member.userId,
          member.name,
        );
      }).toList();

      final results = await Future.wait(futures);

      // 🔥 2. FILTRAR NULOS (usuarios sin evaluaciones)
      studentsResults.assignAll(
        results.whereType<Map<String, dynamic>>().toList(),
      );
    } catch (e) {
      logError("Error loading group results: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // =============================
  // BUILD RESULT PER STUDENT
  // =============================
  Future<Map<String, dynamic>?> _buildStudentResult(
    String activityId,
    String userId,
    String name,
  ) async {
    try {
      final evaluations =
          await getResultsUsecase.execute(activityId, userId);

      if (evaluations.isEmpty) {
        return null; // 🔥 ignorar estudiantes sin data
      }

      final Map<String, List<double>> grouped = {};

      // 🔹 agrupar scores
      for (final eval in evaluations) {
        eval.scoresByCriterion.forEach((criterion, scores) {
          grouped.putIfAbsent(criterion, () => []);
          grouped[criterion]!.addAll(scores);
        });
      }

      // 🔹 construir lista por criterio
      final criteriaList = grouped.entries.map((e) {
        final avg = e.value.reduce((a, b) => a + b) / e.value.length;

        return {
          "label": e.key,
          "score": avg.toStringAsFixed(1),
        };
      }).toList();

      // 🔹 promedio general
      final allScores = grouped.values.expand((e) => e).toList();

      final totalAvg =
          allScores.reduce((a, b) => a + b) / allScores.length;

      return {
        "name": name,
        "average": totalAvg.toStringAsFixed(1),
        "criteria": criteriaList,
      };
    } catch (e) {
      logError("Error building student result ($userId): $e");
      return null;
    }
  }
}