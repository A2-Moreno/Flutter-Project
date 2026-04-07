import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../domain/usecases/submit_evaluation_usecase.dart';
import '../../domain/usecases/has_user_evaluated_usecase.dart';
import '../../domain/usecases/get_evaluation_results_usecase.dart';
import '../../domain/models/evaluation_result_model.dart';

import '../../../../core/i_local_preferences.dart';
import '../../../groups/ui/viewmodels/group_controller.dart';
import '../../../activity/domain/models/activity_model.dart';

class EvaluationController extends GetxController {
  final SubmitEvaluation submitEvaluationUsecase;
  final HasUserEvaluated hasUserEvaluatedUsecase;
  final GetEvaluationResults getResultsUsecase;

  EvaluationController(
    this.submitEvaluationUsecase,
    this.hasUserEvaluatedUsecase,
    this.getResultsUsecase,
  );

  // =============================
  // STATE
  // =============================

  final isLoading = false.obs;
  final error = "".obs;
  late Activity activity;

  final isEvaluationMode = false.obs;
  final isResultMode = false.obs;

  final results = <EvaluationResult>[].obs;

  /// evaluatedUserId -> (criterion -> score)
  final grades = <String, Map<String, double>>{}.obs;

  // =============================
  // DEPENDENCIAS
  // =============================

  final prefs = Get.find<ILocalPreferences>();
  final groupController = Get.find<GroupController>();

  // =============================
  // INIT FLOW
  // =============================

  Future<void> init(Activity activity) async {
    this.activity = activity;
    try {
      isLoading.value = true;
      error.value = "";

      final userId = await prefs.getString("userId");

      if (userId == null) {
        throw Exception("UserId no encontrado");
      }

      // 1. verificar si ya evaluó
      final alreadyEvaluated = await hasUserEvaluatedUsecase.execute(
        activity.id,
        userId,
      );

      // 2. validar ventana de tiempo
      final now = DateTime.now();
      final isActive =
          now.isAfter(activity.startDate) && now.isBefore(activity.endDate);

      if (!alreadyEvaluated && isActive) {
        logInfo("Modo evaluación");
        isEvaluationMode.value = true;
        isResultMode.value = false;
      } else {
        logInfo("Modo resultados");
        isEvaluationMode.value = false;
        isResultMode.value = true;

        await loadResults(activity);
      }
    } catch (e) {
      logError("Error init evaluation: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // =============================
  // SET GRADE
  // =============================

  void setGrade(String evaluatedUserId, String criterion, double value) {
    if (!grades.containsKey(evaluatedUserId)) {
      grades[evaluatedUserId] = {};
    }

    grades[evaluatedUserId]![criterion] = value;

    logInfo("Grade set → $evaluatedUserId | $criterion = $value");
  }

  // =============================
  // SUBMIT
  // =============================

  Future<void> submit(String activityId) async {
    try {
      isLoading.value = true;

      final userId = await prefs.getString("userId");

      final group = groupController.myGroup.value;

      if (userId == null || group == null) {
        throw Exception("Datos incompletos");
      }

      if (grades.isEmpty) {
        throw Exception("No hay calificaciones");
      }

      await submitEvaluationUsecase.execute(
        activityId,
        group.id,
        userId,
        grades,
      );

      Get.snackbar("Éxito", "Evaluación enviada");

      // cambiar a modo resultados automáticamente
      isEvaluationMode.value = false;
      isResultMode.value = true;
      await loadResults(
        Activity(
          id: activityId,
          name: "",
          courseId: "",
          categoryId: "",
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          isPublic: true,
        ),
      );
    } catch (e) {
      logError("Error submit: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =============================
  // LOAD RESULTS
  // =============================

  Future<void> loadResults(Activity activity) async {
    try {
      isLoading.value = true;

      final userId = await prefs.getString("userId");

      if (userId == null) {
        throw Exception("UserId no encontrado");
      }

      final data = await getResultsUsecase.execute(activity.id, userId);

      results.assignAll(data);
    } catch (e) {
      logError("Error loading results: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // =============================
  // HELPERS
  // =============================

  double getAverage(String criterion) {
    if (results.isEmpty) return 0;

    final allScores = <double>[];

    for (final r in results) {
      if (r.scoresByCriterion.containsKey(criterion)) {
        allScores.addAll(r.scoresByCriterion[criterion]!);
      }
    }

    if (allScores.isEmpty) return 0;

    return allScores.reduce((a, b) => a + b) / allScores.length;
  }
}
