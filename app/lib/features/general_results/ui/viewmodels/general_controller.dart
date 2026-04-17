import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../domain/use_cases/get_global_average_usecase.dart';
//import '../../domain/models/global_average_model.dart';
import '../../domain/use_cases/get_groups_global_average.dart';

class CourseResultsController extends GetxController {
  final GetCourseGlobalAverages getCourseAveragesUsecase;
  final GetGroupsGlobalAverage getGroupsGlobalAverageUsecase;

  CourseResultsController(
    this.getCourseAveragesUsecase,
    this.getGroupsGlobalAverageUsecase,
  );

  final isLoading = false.obs;
  final error = "".obs;
  final students = <Map<String, dynamic>>[].obs;
  final groupResults = <Map<String, dynamic>>[].obs;

  Future<void> loadCourseResults(String courseId) async {
    try {
      logInfo("Iniciando carga de resultados del curso");

      isLoading.value = true;
      error.value = "";

      final results = await getCourseAveragesUsecase.execute(courseId);

      if (results.isEmpty) {
        students.clear();
        return;
      }

      final mapped = results.map((e) {
        return {"id": e.studentId, "name": e.studentName, "average": e.average};
      }).toList();

      mapped.sort((a, b) {
        final aAvg = a["average"] as double;
        final bAvg = b["average"] as double;
        return bAvg.compareTo(aAvg);
      });

      final formatted = mapped.map((e) {
        return {
          "id": e["id"],
          "name": e["name"],
          "average": (e["average"] as double).toStringAsFixed(1),
        };
      }).toList();

      students.assignAll(formatted);

      print(students);
    } catch (e) {
      logError("🔴 Error cargando resultados del curso: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadGroupsGlobalAverage(String courseId) async {
    try {
      isLoading.value = true;
      error.value = "";

      final data = await getGroupsGlobalAverageUsecase.execute(courseId);

      if (data.isEmpty) {
        groupResults.clear();
        return;
      }

      final mapped = data.map((activity) {
        final groups = activity.groups.map((g) {
          return {
            "id": g.groupId,
            "name": g.groupName,
            "average": g.average != null ? g.average!.toStringAsFixed(1) : "--",
          };
        }).toList();

        return {"activity": activity.activityName, "groups": groups};
      }).toList();

      groupResults.assignAll(mapped);

    } catch (e) {
      logError("🔴 Error cargando promedios de grupos: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasData => students.isNotEmpty;
  bool get isEmpty => students.isEmpty && !isLoading.value;
  String get emptyMessage => "No hay resultados disponibles";

  List<Map<String, dynamic>> get top3 {
    if (students.length <= 3) return students;
    return students.sublist(0, 3);
  }
}
