import 'package:app/features/evaluation/ui/pages/results_page.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../domain/usecases/submit_evaluation_usecase.dart';
import '../../domain/usecases/has_user_evaluated_usecase.dart';
import '../../domain/usecases/get_my_evaluations_usecase.dart';
import '../../domain/usecases/get_scores_evaluation_usecase.dart';
import '../../../../core/i_local_preferences.dart';
import '../../../groups/ui/viewmodels/group_controller.dart';
import '../../../activity/domain/models/activity_model.dart';


class EvaluationController extends GetxController {
  final SubmitEvaluation submitEvaluationUsecase;
  final HasUserEvaluated hasUserEvaluatedUsecase;
  
  final GetMyEvaluations getMyEvaluationsUsecase;
  final GetScoresByEvaluation getScoresByEvaluationUsecase;

  EvaluationController(
    this.submitEvaluationUsecase,
    this.hasUserEvaluatedUsecase,
    this.getMyEvaluationsUsecase,
    this.getScoresByEvaluationUsecase,
  );

  final isLoading = false.obs;
  final error = "".obs;
  late Activity activity;

  final isEvaluationMode = false.obs;
  final isResultMode = false.obs;

  final grades = <String, Map<String, double>>{}.obs;
  final mySubmittedGrades = <String, Map<String, double>>{}.obs;

  final prefs = Get.find<ILocalPreferences>();
  final groupController = Get.find<GroupController>();

  Future<void> init(Activity activity) async {
    this.activity = activity;

    try {
      isLoading.value = true;

      final userId = await prefs.getString("userId");

      if (userId == null) throw Exception("UserId no encontrado");

      final alreadyEvaluated = await hasUserEvaluatedUsecase.execute(
        activity.id,
        userId,
      );

      final now = DateTime.now();
      final isActive =
          now.isAfter(activity.startDate) && now.isBefore(activity.endDate);

      if (!alreadyEvaluated && isActive) {
        isEvaluationMode.value = true;
      } else {
        isResultMode.value = true;
        await loadMyGrades(activity.id);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // =============================
  // SET GRADE
  // =============================
  void setGrade(String evaluatedUserId, String criterion, double value) {
    grades.putIfAbsent(evaluatedUserId, () => {});
    grades[evaluatedUserId]![criterion] = value;
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

      await submitEvaluationUsecase.execute(
        activityId,
        group.id,
        userId,
        grades,
      );

      mySubmittedGrades.assignAll(grades);

      isEvaluationMode.value = false;
      isResultMode.value = true;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =============================
  // MIS CALIFICACIONES HECHAS
  // =============================
  Future<void> loadMyGrades(String activityId) async {
    try {
      final userId = await prefs.getString("userId");

      if (userId == null) throw Exception("UserId no encontrado");

      final evaluations = await getMyEvaluationsUsecase.execute(
        activityId,
        userId,
      );

      final Map<String, Map<String, double>> result = {};

      for (final eval in evaluations) {
        final evaluatedId = eval["evaluated_id"];
        final evaluationId = eval["_id"];

        final scores = await getScoresByEvaluationUsecase.execute(evaluationId);

        result[evaluatedId] = {};

        for (final s in scores) {
          result[evaluatedId]![s["criterion"]] = (s["score"] as num).toDouble();
        }
      }

      mySubmittedGrades.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    }
  }

  void openResults(Activity activity) {
    Get.to(() => ResultsPage(activity: activity));
  }
}
