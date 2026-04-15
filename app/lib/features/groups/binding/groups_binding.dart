import 'package:get/get.dart';

// DATA
import '../data/datasources/group_source_service_roble.dart';
import '../data/datasources/i_group_source_service_roble.dart';
import '../data/repositories/group_repository_impl.dart';

// DOMAIN
import '../domain/repositories/i_group_repository.dart';
import '../domain/use_cases/get_groups_by_category_usecase.dart';
import '../domain/use_cases/get_my_group_usecase.dart';
import '../domain/use_cases/get_all_my_groups.dart';

import '../domain/use_cases/get_evaluations_by_activity_usecase.dart';

// CONTROLLER
import '../ui/viewmodels/group_controller.dart';

class GroupDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IGroupDetailRemoteDataSource>(
      () => GroupDetailRemoteDataSource(),
      fenix: true,
    );

    Get.lazyPut<IGroupDetailRepository>(
      () => GroupDetailRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut<GetGroupsByCategory>(
      () => GetGroupsByCategory(Get.find()),
      fenix: true,
    );

    Get.lazyPut<GetMyGroup>(() => GetMyGroup(Get.find()), fenix: true);

    Get.lazyPut<GetAllMyGroups>(() => GetAllMyGroups(Get.find()), fenix: true);

    Get.lazyPut<GroupController>(
      () => GroupController(
        Get.find(), // GetGroupsByCategory
        Get.find(), // GetMyGroup
        Get.find(),
        Get.find(), // GetGlobalAverage
      ),
      fenix: true,
    );

    Get.lazyPut<GetGlobalAverage>(
      () => GetGlobalAverage(Get.find()),
      fenix: true,
    );
  }
}
