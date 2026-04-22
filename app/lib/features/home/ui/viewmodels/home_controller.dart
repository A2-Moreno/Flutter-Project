import 'package:get/get.dart';
import '../../../teacher/ui/pages/create_course.dart';
import '../../../course/ui/pages/course_page.dart';
import '../../domain/repositories/i_course_repository.dart';
import '../../../auth/ui/viewmodels/authentication_controller.dart';
import '../../../teacher/binding/create_courses_binding.dart';

class HomeController extends GetxController {
  final ICourseRepository repository;

  HomeController(this.repository);

  var courses = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    final auth = Get.find<AuthenticationController>();

    ever(auth.logged, (isLogged) {
      if (isLogged) {
        loadCourses();
      } else {
        courses.clear();
      }
    });
  }

  void loadCourses() async {
    try {
      final data = await repository.getCoursesByUserEmail();
      courses.value = data;
    } catch (e) {
      print("Error: $e");
      courses.value = [];
    }
  }

  void abrirCrearCurso() {
    Get.to(
      () => const CreateCourseScreen(),
      binding: CreateCourseBinding(),
    )?.then((_) {
      print("Regresando de crear curso, recargando cursos...");
      loadCourses();
    });
  }

  void abrirCurso(Map<String, dynamic> course) async {
    await Get.to(() => CourseScreen(course: course));
    loadCourses();
  }

  void reload() {
    loadCourses();
  }
}
