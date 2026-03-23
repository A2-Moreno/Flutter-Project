import 'package:get/get.dart';
import '../../../teacher/ui/pages/create_course.dart';

class HomeController extends GetxController {
  var courses = [
    {'name': 'Programación Móvil', 'activities': 3},
    {'name': 'Compiladores', 'activities': 0},
    {'name': 'Proyecto Final', 'activities': 2},
  ].obs;

  void abrirCrearCurso() {
    Get.to(() => const CreateCourseScreen());
  }
}
