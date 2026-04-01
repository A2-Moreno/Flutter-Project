import 'package:get/get.dart';

// DATA
import '../../features/save_to_db/data/datasources/savedb_remote_data_source.dart';
import '../../features/save_to_db/data/datasources/i_savedb_remote_data_source.dart';
import '../../features/save_to_db/data/repositories/savedb_repository.dart';

import '../../features/import_csv/data/repositories/group_repository_impl.dart';

// DOMAIN
import '../../features/save_to_db/domain/repositories/group_repository.dart';
import '../../features/import_csv/domain/repositories/group_repository.dart';
import '../../features/import_csv/domain/use_cases/import_groups.dart';
import '../../features/save_to_db/domain/use_cases/import_groupsdb.dart';

// CSV parser
import '../../features/import_csv/data/services/csv_group_parser.dart';

// CONTROLLER
import '../../features/save_to_db/ui/viewmodels/savedb_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // DATA SOURCES
    Get.lazyPut<IGroupRemoteDataSource>(
      () => GroupRemoteDataSourceRoble(),
      fenix: true,
    );

    Get.lazyPut<CsvGroupParser>(() => CsvGroupParser(), fenix: true);

    // REPOSITORIES
    Get.lazyPut<IGroupCsvRepository>(
      () => GroupCsvRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut<IGroupDbRepository>(
      () => GroupDbRepositoryImpl(Get.find()),
      fenix: true,
    );

    // USE CASES
    Get.lazyPut(() => ImportGroups(Get.find()), fenix: true);
    Get.lazyPut(() => ImportGroupsToDb(Get.find()), fenix: true);

    // CONTROLLER
    Get.lazyPut(
      () => ImportGroupsController(Get.find(), Get.find()),
      fenix: true,
    );
  }
}
