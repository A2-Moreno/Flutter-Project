import 'package:get/get.dart';
import '../../domain/models/activity_model.dart';
import '../../domain/usecases/create_activity_usecase.dart';
import '../../domain/usecases/get_activities_by_course_usecase.dart';
import 'dart:math';


String generateId() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random();

  return List.generate(12, (index) => chars[rand.nextInt(chars.length)]).join();
}

class ActivityController extends GetxController {

  final CreateActivity createActivity;
  final GetActivitiesByCourse getActivitiesByCourse;

  ActivityController(
    this.createActivity,
    this.getActivitiesByCourse,
  );

  final activities = <Activity>[].obs;
  final isLoading = false.obs;

  final name = ''.obs;
  final categoryId = ''.obs;
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final isPublic = false.obs;

  Future<void> loadActivities(String courseId) async {
    try {
      isLoading.value = true;

      final data = await getActivitiesByCourse.execute(courseId);
      activities.assignAll(data);

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createNewActivity(String courseId) async {
    try {
      isLoading.value = true;

      if (name.value.isEmpty ||
          categoryId.value.isEmpty ||
          startDate.value == null ||
          endDate.value == null) {
        throw Exception("Todos los campos son obligatorios");
      }

      final activity = Activity(
        id: generateId(),
        name: name.value,
        courseId: courseId,
        categoryId: categoryId.value,
        startDate: startDate.value!,
        endDate: endDate.value!,
        isPublic: isPublic.value,
      );

      await createActivity.execute(activity);

      await loadActivities(courseId);

      clearForm();

      Get.snackbar("Éxito", "Actividad creada correctamente");

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    name.value = '';
    categoryId.value = '';
    startDate.value = null;
    endDate.value = null;
    isPublic.value = false;
  }
}