import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../domain/models/group_model.dart';
import '../../domain/use_cases/get_groups_by_category_usecase.dart';
import '../../domain/use_cases/get_my_group_usecase.dart';
import '../../../../core/i_local_preferences.dart';

class GroupController extends GetxController {
  final GetGroupsByCategory getGroupsByCategory;
  final GetMyGroup getMyGroup;

  GroupController(this.getGroupsByCategory, this.getMyGroup);

  final isLoading = false.obs;
  final groups = <Group>[].obs;
  final myGroup = Rxn<Group>();
  final isTeacher = false.obs;
  final error = "".obs;

  Future<void> loadGroups(String categoryId) async {
    try {
      isLoading.value = true;
      error.value = "";

      final prefs = Get.find<ILocalPreferences>();
      final role = await prefs.getString("role");
      final userId = await prefs.getString("userId");
      logInfo("Role: $role");
      logInfo("UserId: $userId");

      if (role == "profesor") {
        isTeacher.value = true;
        final result = await getGroupsByCategory.execute(categoryId);
        groups.assignAll(result);
      }
      else {
        isTeacher.value = false;

        if (userId == null) {
          throw Exception("UserId no encontrado");
        }
        final result = await getMyGroup.execute(categoryId, userId);
        if (result != null) {
          myGroup.value = result;
        }
      }
    } catch (e) {
      logError("Error loading groups: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshGroups(String categoryId) async {
    await loadGroups(categoryId);
  }
}
