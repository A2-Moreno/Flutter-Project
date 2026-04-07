import 'package:get/get.dart';
import '../../domain/models/category_model.dart';
import '../../domain/use_cases/get_categories_usecase.dart';
import '../../../groups/ui/pages/group_page.dart';
import '../../../evaluation/ui/pages/grade_group_page.dart';
import '../../../evaluation/ui/pages/groups_page.dart';
import '../../../teacher/ui/pages/create_evaluation_page.dart';
import '../../../activity/domain/models/activity_model.dart';
import '../../../activity/domain/usecases/get_activities_by_course_usecase.dart';

class CourseController extends GetxController {
  final GetCategories getCategories;
  final GetActivitiesByCourse getActivities;

  CourseController(this.getCategories, this.getActivities);

  final categories = <Category>[].obs;
  final activities = <Activity>[].obs;

  final isLoading = false.obs;

  Future<void> loadCategories(String courseId) async {
    try {
      final data = await getCategories.execute(courseId);
      categories.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> loadActivities(String courseId) async {
    try {
      isLoading.value = true;

      final data = await getActivities.execute(courseId);
      activities.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void openCategory(Activity activity) {
    Get.to(() => GroupScreen(activity: activity));
  }

  void openCategoryStudent(Activity activity) {
    Get.to(() => GradeGroupPage(activity: activity));
  }

  void openGroupsStudent(String courseId) {
    Get.to(() => GroupsPage(courseId: courseId));
  }

  void createActivityPage(String courseId) async {

    final result = await Get.to(
      () => CreateEvaluationPage(courseId: courseId, categories: categories),
    );
    if (result == true) {
      await loadActivities(courseId);
    }
  }

}
