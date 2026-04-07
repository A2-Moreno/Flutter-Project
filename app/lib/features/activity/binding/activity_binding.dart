import 'package:get/get.dart';
import '../data/datasources/i_activity_remote_datasource.dart';
import '../data/datasources/activity_remote_datasource.dart';
import '../domain/repositories/i_activity_repository.dart';
import '../data/repositories/activity_repository_impl.dart';
import '../domain/usecases/create_activity_usecase.dart';
import '../domain/usecases/get_activities_by_course_usecase.dart';
import '../ui/viewmodels/activity_controller.dart';

class ActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IActivityRemoteDataSource>(
      () => ActivityRemoteDataSourceRoble(),
      fenix: true,
    );

    Get.lazyPut<IActivityRepository>(
      () => ActivityRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut(() => CreateActivity(Get.find()), fenix: true);

    Get.lazyPut(() => GetActivitiesByCourse(Get.find()), fenix: true);

    Get.lazyPut(() => ActivityController(Get.find(), Get.find()), fenix: true);
  }
}
