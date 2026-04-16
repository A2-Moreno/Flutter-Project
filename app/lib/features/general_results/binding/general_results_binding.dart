import 'package:get/get.dart';
import '../ui/viewmodels/general_controller.dart';
import '../domain/use_cases/get_global_average_usecase.dart';
import '../domain/repositories/i_global_avereges_repository.dart';
import '../data/datasources/i_general_results_source_service_roble.dart';
import '../data/datasources/general_results_source_service_roble.dart';
import '../data/repositories/global_avereges_repository_impl.dart';
import '../domain/use_cases/get_groups_global_average.dart';

class GeneralResultsBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<IGeneralRemoteDataSource>(
      () => GeneralRemoteDataSource(),
      fenix: true,
    );

    Get.lazyPut<IGeneralResultsRepository>(
      () => GeneralResultsRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut<GetCourseGlobalAverages>(
      () => GetCourseGlobalAverages(Get.find()),
      fenix: true,
    );

    Get.lazyPut<GetGroupsGlobalAverage>(
      () => GetGroupsGlobalAverage(Get.find()),
      fenix: true,
    );

    // Controlador
    Get.lazyPut<CourseResultsController>(
      () => CourseResultsController(Get.find(), Get.find()),
      fenix: true,
    );
  }
}
