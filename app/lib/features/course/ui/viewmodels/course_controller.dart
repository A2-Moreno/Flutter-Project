import 'package:get/get.dart';
import '../../domain/models/category_model.dart';
import '../../domain/use_cases/get_categories_usecase.dart';
import '../../../groups/ui/pages/group_page.dart';

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
}
