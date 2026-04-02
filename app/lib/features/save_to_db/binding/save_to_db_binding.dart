import 'package:get/get.dart';

// DATA
import '../data/datasources/savedb_remote_data_source.dart';
import '../data/datasources/i_savedb_remote_data_source.dart';
import '../data/repositories/savedb_repository.dart';

// DOMAIN
import '../domain/repositories/group_repository.dart';
import '../domain/use_cases/import_groupsdb.dart';

// CONTROLLER
import '../../save_to_db/ui/viewmodels/savedb_controller.dart';

class SaveDbBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IGroupRemoteDataSource>(
      () => GroupRemoteDataSourceRoble(),
      fenix: true,
    );

    Get.lazyPut<IGroupDbRepository>(
      () => GroupDbRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut(() => ImportGroupsToDb(Get.find()), fenix: true);

    Get.lazyPut(
      () => ImportGroupsController(Get.find(), Get.find()),
      fenix: true,
    );
  }
}
