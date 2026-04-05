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
      print("INICIANDO CARGA DE GRUPOS");
      print("CategoryId: $categoryId");

      isLoading.value = true;
      error.value = "";

      final prefs = Get.find<ILocalPreferences>();
      final role = await prefs.getString("role");
      final userId = await prefs.getString("userId");

      print("Role: $role");
      print("UserId: $userId");

      logInfo("Role: $role");
      logInfo("UserId: $userId");

      if (role == "profesor") {
        print("MODO PROFESOR");

        isTeacher.value = true;
        final result = await getGroupsByCategory.execute(categoryId);

        print(" TOTAL GRUPOS: ${result.length}");

        for (var group in result) {
          print("\n📦 Grupo: ${group.name} (ID: ${group.id})");

          for (var member in group.members) {
            print(" - 👤 ${member.name} | ${member.email}");
          }
        }

        groups.assignAll(result);
      } else {
        print("MODO ESTUDIANTE");

        isTeacher.value = false;

        if (userId == null) {
          throw Exception("UserId no encontrado");
        }

        final result = await getMyGroup.execute(categoryId, userId);

        if (result != null) {
          print("\n MI GRUPO:");
          print("Grupo: ${result.name} (ID: ${result.id})");

          for (var member in result.members) {
            print(" - ${member.name} | ${member.email}");
          }

          myGroup.value = result;
        } else {
          print("El estudiante no pertenece a ningún grupo en esta categoría");
        }
      }

      print("CARGA COMPLETADA");
    } catch (e) {
      print("ERROR EN LOAD GROUPS: $e");
      logError("Error loading groups: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshGroups(String categoryId) async {
    print("🔄 REFRESH DE GRUPOS");
    await loadGroups(categoryId);
  }
}