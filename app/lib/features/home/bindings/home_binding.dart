import 'package:get/get.dart';
import '../domain/repositories/i_course_repository.dart';
import '../data/datasource/i_course_source.dart';
import '../data/datasource/course_remote_data_source.dart';
import '../data/repositories/course_repository.dart';
import '../ui/viewmodels/home_controller.dart';
import '../data/datasource/course_cache_data_source.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<ICourseRemoteDataSource>(
      () => CourseRemoteDataSource(),
      fenix: true,
    );

    Get.lazyPut<LocalCourseCacheSource>(
      () => LocalCourseCacheSource(Get.find()),
      fenix: true,
    );

    Get.lazyPut<ICourseRepository>(
      () => CourseRepository(Get.find<ICourseRemoteDataSource>(), Get.find<LocalCourseCacheSource>()),
      fenix: true,
    );

    Get.lazyPut<HomeController>(
      () => HomeController(
        Get.find<ICourseRepository>(),
      ),
      fenix: true,
    );
  }
}