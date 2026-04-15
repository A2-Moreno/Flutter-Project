import 'package:app/features/activity/domain/models/activity_model.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../domain/models/group_model.dart';
import '../../domain/models/all_groups_model.dart';
import '../../domain/use_cases/get_groups_by_category_usecase.dart';
import '../../domain/use_cases/get_my_group_usecase.dart';
import '../../domain/use_cases/get_all_my_groups.dart';
import '../../domain/use_cases/get_evaluations_by_activity_usecase.dart';
import '../../../../core/i_local_preferences.dart';
import '../../../evaluation/ui/pages/teacher_results_page.dart';

class GroupController extends GetxController {
  final GetGroupsByCategory getGroupsByCategory;
  final GetMyGroup getMyGroup;
  final GetAllMyGroups getAllMyGroups;
  final GetGlobalAverage getGlobalAverage;

  GroupController(
    this.getGroupsByCategory,
    this.getMyGroup,
    this.getAllMyGroups,
    this.getGlobalAverage,
  );

  final isLoading = false.obs;
  final isLoading2 = false.obs;
  final groups = <Group>[].obs;
  final myGroup = Rxn<Group>();
  final isTeacher = false.obs;
  final error = "".obs;
  final allMyGroups = <AllMyGroups>[].obs;
  final globalAverage = 0.0.obs;

  Future<void> loadGroups(String activityId) async {
    try {
      isLoading.value = true;
      error.value = "";

      final prefs = Get.find<ILocalPreferences>();
      final role = await prefs.getString("rol");
      final userId = await prefs.getString("userId");

      if (role == "profesor") {
        logInfo("MODO PROFESOR");

        isTeacher.value = true;
        final result = await getGroupsByCategory.execute(activityId);

        logInfo(" TOTAL GRUPOS: ${result.length}");

        groups.assignAll(result);
      } else {
        logInfo("MODO ESTUDIANTE");

        isTeacher.value = false;

        if (userId == null) {
          throw Exception("UserId no encontrado");
        }
        final result = await getMyGroup.execute(activityId, userId);

        if (result != null) {
          myGroup.value = result;
        }
      }
    } catch (e) {
      print("ERROR EN LOAD GROUPS: $e");
      logError("Error loading groups: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAllMyGroups(String courseId) async {
    try {
      print("INICIANDO CARGA DE TODOS LOS GRUPOS");
      print("CourseId: $courseId");

      isLoading.value = true;
      error.value = "";

      allMyGroups.clear();

      final prefs = Get.find<ILocalPreferences>();
      final userId = await prefs.getString("userId");

      if (userId == null) {
        throw Exception("UserId no encontrado");
      }
      print('El courseId recibid es:  $courseId');
      print('El userId recibid es:  $userId');
      final result = await getAllMyGroups.execute(courseId, userId);

      allMyGroups.assignAll(result);
    } catch (e) {
      print("ERROR EN loadAllMyGroups: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshGroups(String categoryId) async {
    print("🔄 REFRESH DE GRUPOS");
    await loadGroups(categoryId);
  }

Future<void> loadGlobalAverage(String activityId) async {
  isLoading2.value = true;
  print('estamos en el loadGlobalAverage con activityId: $activityId');
  try {
    final avg = await getGlobalAverage.execute(activityId);
    globalAverage.value = avg;
    print('Global average cargado: $avg');
  } catch (e) {
    print("ERROR EN loadGlobalAverage: $e");
    globalAverage.value = 0.0;
  } finally {
    isLoading2.value = false;
  }
}

  void openGroup(Activity activity, Group group) {
    Get.to(() => TeacherResultsPage(activity: activity, group: group));
  }
}
