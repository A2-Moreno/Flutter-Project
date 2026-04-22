import 'package:get/get.dart';
import '../../../teacher/domain/models/course_model.dart';
import '../../domain/repositories/i_course_create_repository.dart';
import 'dart:math';
import '../../../home/domain/repositories/i_course_repository.dart';
import '../../../../core/i_local_preferences.dart';

String generateId() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random();

  return List.generate(12, (index) => chars[rand.nextInt(chars.length)]).join();
}

class CreateController extends GetxController {
  final ICourseCreateRepository repository;
  final homeRepository = Get.find<ICourseRepository>();
  final prefs = Get.find<ILocalPreferences>();

  CreateController(this.repository);

  final isLoading = false.obs;

  Future<void> createCourse(String name, String nrc) async {
    try {
      isLoading.value = true;
      final userId = await prefs.getString("userId");
      final course = Course(
        id: generateId(),
        name: name,
        nrc: nrc,
        profesorId: userId!, 
      );

      await repository.createCourse(course);
      Get.find<ICourseRepository>().clearCache();

      Get.snackbar("Success", "Course created successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
