import 'package:get/get.dart';
import '../data/datasources/i_category_source_service_roble.dart';
import '../data/datasources/category_source_service_roble.dart';
import '../domain/repositories/i_category_repository.dart';
import '../data/repositories/category_repository_impl.dart';
import '../domain/use_cases/get_categories_usecase.dart';
import '../ui/viewmodels/course_controller.dart';

class CourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ICourseViewRemoteDataSource>(
      () => CourseViewRemoteDataSourceRoble(),
      fenix: true,
    );

    Get.lazyPut<ICourseViewRepository>(
      () => CourseViewRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut(() => GetCategories(Get.find()), fenix: true);

    Get.lazyPut(() => CourseController(Get.find()), fenix: true);
  }
}
