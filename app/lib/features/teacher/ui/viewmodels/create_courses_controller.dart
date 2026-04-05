import 'package:get/get.dart';
import '../../../teacher/domain/models/course_model.dart';
import '../../domain/repositories/i_course_create_repository.dart';
import 'dart:math';

String generateId() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random();

  return List.generate(12, (index) => chars[rand.nextInt(chars.length)]).join();
}

class CreateController extends GetxController {
  final ICourseCreateRepository repository;

  CreateController(this.repository);

  final isLoading = false.obs;

  Future<void> createCourse(String name, String nrc) async {
    try {
      isLoading.value = true;

      final course = Course(
        id: generateId(),
        name: name,
        nrc: nrc,
        profesorId: "", // no se usa aquí, se toma del token
      );

      await repository.createCourse(course);

      Get.snackbar("Success", "Course created successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
