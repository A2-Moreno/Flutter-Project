import 'package:get/get.dart';
import '../../domain/models/category_model.dart';
import '../../domain/use_cases/get_categories_usecase.dart';
import '../../../groups/ui/pages/group_page.dart';
import '../../../student/ui/pages/grade_group_page.dart';
import '../../../student/ui/pages/groups_page.dart';
import '../../../teacher/ui/pages/create_evaluation_page.dart';

class CourseController extends GetxController {
  final GetCategories getCategories;

  CourseController(this.getCategories);

  final activities = <Category>[].obs;

  final isLoading = false.obs;

  Future<void> loadCategories(String courseId) async {
    try {
      isLoading.value = true;

      final data = await getCategories.execute(courseId);

      activities.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void openCategory(Category category) {
    Get.to(() => GroupScreen(category: category));
  }

  void openCategoryStudent(Category category) {
    Get.to(() => GradeGroupPage(category: category));
  }

  void openGroupsStudent(String courseId) {
    Get.to(() => GroupsPage(courseId: courseId));
  }
  void createActivityPage (String courseId) {
  Get.to(() =>  CreateEvaluationPage(courseId: courseId, categories: activities,));
  }
  /*
final result = await Get.to(() => CreateEvaluationPage(courseId: courseId));

  if (result == true) {
    await loadCategories(courseId);
  }
  */
}
