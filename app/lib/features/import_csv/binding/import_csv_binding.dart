import 'package:get/get.dart';

// DATA
import '../data/repositories/group_repository_impl.dart';

// DOMAIN
import '../domain/repositories/group_repository.dart';
import '../domain/use_cases/import_groups.dart';

// CSV parser
import '../data/services/csv_group_parser.dart';
// CONTROLLER

class ImportCsvBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CsvGroupParser>(() => CsvGroupParser(), fenix: true);

    Get.lazyPut<IGroupCsvRepository>(
      () => GroupCsvRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut(() => ImportGroups(Get.find()), fenix: true);
  }
}
