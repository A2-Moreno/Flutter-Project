import 'package:app/features/general_results/domain/repositories/i_global_avereges_repository.dart';

import '../../domain/models/global_average_model.dart';
import '../datasources/i_general_results_source_service_roble.dart';
import '../../domain/models/groups_global_average_model.dart';

class GeneralResultsRepositoryImpl implements IGeneralResultsRepository {
  final IGeneralRemoteDataSource remote;

  GeneralResultsRepositoryImpl(this.remote);

  @override
  Future<List<StudentGlobalAverage>> getCourseGlobalAverages(
    String courseId,
  ) async {
    // =============================
    // 1. TRAER ACTIVIDADES
    // =============================
    final activities = await remote.getActivitiesByCourse(courseId);

    if (activities.isEmpty) return [];

    final activityIds = activities.map((a) => a["_id"].toString()).toList();

    // =============================
    // 2. TRAER TODAS LAS EVALUACIONES
    // =============================
    final evaluationsResponses = await Future.wait(
      activityIds.map((id) => remote.getEvaluationsByActivity(id)),
    );

    final allEvaluations = evaluationsResponses.expand((e) => e).toList();

    if (allEvaluations.isEmpty) return [];

    // =============================
    // 3. TRAER TODOS LOS SCORES (PARALELO)
    // =============================
    final scoresResponses = await Future.wait(
      allEvaluations.map((eval) {
        return remote.getScoresByEvaluation(eval["_id"]);
      }),
    );

    // =============================
    // 4. AGRUPAR POR ESTUDIANTE
    // =============================
    final Map<String, List<double>> studentScores = {};

    for (int i = 0; i < allEvaluations.length; i++) {
      final eval = allEvaluations[i];
      final scores = scoresResponses[i];

      final evaluatedId = eval["evaluated_id"];

      if (scores.isEmpty) continue;

      for (final s in scores) {
        final score = (s["score"] as num).toDouble();

        studentScores.putIfAbsent(evaluatedId, () => []);
        studentScores[evaluatedId]!.add(score);
      }
    }

    if (studentScores.isEmpty) return [];

    // =============================
    // 5. TRAER USUARIOS (PARALELO)
    // =============================
    final userIds = studentScores.keys.toList();

    final userResponses = await Future.wait(
      userIds.map((id) => remote.getUserById(id)),
    );

    final Map<String, String> userNames = {};

    for (int i = 0; i < userIds.length; i++) {
      final user = userResponses[i];

      if (user != null) {
        userNames[userIds[i]] = user["name"] ?? "Sin nombre";
      }
    }

    // =============================
    // 6. CALCULAR PROMEDIOS
    // =============================
    final List<StudentGlobalAverage> result = [];

    studentScores.forEach((userId, scores) {
      if (scores.isEmpty) return;

      final avg = scores.reduce((a, b) => a + b) / scores.length;

      result.add(
        StudentGlobalAverage(
          studentId: userId,
          studentName: userNames[userId] ?? "Desconocido",
          average: avg,
        ),
      );
    });

    // =============================
    // 7. ORDENAR (TOP → BOTTOM)
    // =============================
    result.sort((a, b) => b.average.compareTo(a.average));

    return result;
  }

  @override
  Future<List<GroupActivityAverage>> getGroupsGlobalAverage(
    String courseId,
  ) async {
    final activities = await remote.getActivitiesByCourse(courseId);

    List<GroupActivityAverage> result = [];

    for (final activity in activities) {
      final activityId = activity["_id"];
      final activityName = activity["name"];

      final evaluations = await remote.getEvaluationsByActivity(activityId);

      // 🔹 Agrupar evaluaciones por grupo
      final Map<String, List<Map<String, dynamic>>> groupedByGroup = {};

      for (final eval in evaluations) {
        final groupId = eval["group_id"];

        groupedByGroup.putIfAbsent(groupId, () => []);
        groupedByGroup[groupId]!.add(eval);
      }

      List<GroupAverage> groupAverages = [];

      for (final entry in groupedByGroup.entries) {
        final groupId = entry.key;
        final evals = entry.value;

        final groupData = await remote.read(
          table: "groups",
          filters: {"_id": groupId},
        );

        final groupName = groupData.isNotEmpty
            ? groupData.first["name"]
            : "Grupo";

        final List<double> allScores = [];

        for (final eval in evals) {
          final scores = await remote.getScoresByEvaluation(eval["_id"]);

          for (final s in scores) {
            final score = (s["score"] as num).toDouble();
            allScores.add(score);
          }
        }

        if (allScores.isEmpty) continue;

        final avg = allScores.reduce((a, b) => a + b) / allScores.length;

        groupAverages.add(
          GroupAverage(groupId: groupId, groupName: groupName, average: avg),
        );
      }

      result.add(
        GroupActivityAverage(activityName: activityName, groups: groupAverages),
      );
    }

    return result;
  }
}
