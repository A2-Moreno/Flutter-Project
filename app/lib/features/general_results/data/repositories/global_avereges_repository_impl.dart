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
    final activities = await remote.getActivitiesByCourse(courseId);

    if (activities.isEmpty) return [];

    final activityIds = activities.map((a) => a["_id"].toString()).toList();

    final evaluationsResponses = await Future.wait(
      activityIds.map((id) => remote.getEvaluationsByActivity(id)),
    );

    final allEvaluations = evaluationsResponses.expand((e) => e).toList();

    if (allEvaluations.isEmpty) return [];

    final scoresResponses = await Future.wait(
      allEvaluations.map((eval) {
        return remote.getScoresByEvaluation(eval["_id"]);
      }),
    );

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
      final categoryId = activity["category_id"];

      final groups = await remote.read(
        table: "groups",
        filters: {"category_id": categoryId},
      );

      final evaluations = await remote.getEvaluationsByActivity(activityId);
      final Map<String, List<Map<String, dynamic>>> groupedByGroup = {};

      for (final eval in evaluations) {
        final groupId = eval["group_id"];

        groupedByGroup.putIfAbsent(groupId, () => []);
        groupedByGroup[groupId]!.add(eval);
      }

      List<GroupAverage> groupAverages = [];

      for (final group in groups) {
        final groupId = group["_id"];
        final groupName = group["name"];

        final evals = groupedByGroup[groupId] ?? [];

        final List<double> allScores = [];

        for (final eval in evals) {
          final scores = await remote.getScoresByEvaluation(eval["_id"]);

          for (final s in scores) {
            final score = (s["score"] as num).toDouble();
            allScores.add(score);
          }
        }

        double? avg;

        if (allScores.isNotEmpty) {
          avg = allScores.reduce((a, b) => a + b) / allScores.length;
        }

        groupAverages.add(
          GroupAverage(
            groupId: groupId,
            groupName: groupName,
            average: avg,
          ),
        );
      }

      result.add(
        GroupActivityAverage(activityName: activityName, groups: groupAverages),
      );
    }

    return result;
  }
}
