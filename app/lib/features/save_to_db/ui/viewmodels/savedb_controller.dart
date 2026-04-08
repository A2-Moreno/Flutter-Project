import 'package:get/get.dart';
import '../../../import_csv/domain/use_cases/import_groups.dart';
import '../../domain/use_cases/import_groupsdb.dart';

class ImportGroupsController extends GetxController {
  final ImportGroups importGroups;
  final ImportGroupsToDb importGroupsToDb;

  ImportGroupsController(this.importGroups, this.importGroupsToDb);

  Future<void> importCsv(String courseId) async {
    try {
      final groups = await importGroups.execute();

      await importGroupsToDb.execute(courseId, groups);
    } catch (e) {
      print("ERROR: $e");
    }
  }
}
