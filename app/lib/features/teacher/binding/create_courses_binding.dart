import '../ui/viewmodels/create_courses_controller.dart';
import '../data/datasources/course_create_source_service_roble.dart';
import '../data/datasources/i_course_create_source.dart';
import '../domain/repositories/i_course_create_repository.dart';
import '../data/repositories/course_create_repository.dart';
import '../../home/domain/repositories/i_course_repository.dart';
import '../../home/data/repositories/course_repository.dart';
import '../../home/data/datasource/i_course_source.dart';
import '../../home/data/datasource/course_remote_data_source.dart';
import '../../home/data/datasource/course_cache_data_source.dart';

import 'package:get/get.dart';

class CreateCourseBinding extends Bindings {
  @override
  void dependencies() {
    /*Get.lazyPut<ICourseRemoteDataSource>(
      () => CourseRemoteDataSource(),
      fenix: true,
    );
    Get.lazyPut<LocalCourseCacheSource>(
      () => LocalCourseCacheSource(Get.find()),
      fenix: true,
    );
    Get.lazyPut<ICourseRepository>(
      () => CourseRepository(Get.find(), Get.find()),
    );*/
    Get.lazyPut<ICourseCreateRemoteDataSource>(() => CreateCourseRemoteDataSource());
    Get.lazyPut<ICourseCreateRepository>(
      () => CourseCreateRepository(Get.find()),
    );
    Get.lazyPut<CreateController>(() => CreateController(Get.find()));
  }
}
