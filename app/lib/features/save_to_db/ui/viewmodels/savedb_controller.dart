import 'package:get/get.dart';
import '../../../import_csv/domain/use_cases/import_groups.dart';
import '../../domain/use_cases/import_groupsdb.dart';

class ImportGroupsController extends GetxController {
  final ImportGroups importGroups;
  final ImportGroupsToDb importGroupsToDb;

  ImportGroupsController(this.importGroups, this.importGroupsToDb);

  Future<void> importCsv(String courseId) async {
    try {
      print("Leyendo CSV...");

      final groups = await importGroups.execute();

      print("CSV leído");

      for (var group in groups) {
        print("\nCategoria: ${group.categoryName}");
        print("Grupo: ${group.groupNumber}");
        print("Codigo: ${group.groupCode}");

        for (var student in group.students) {
          print(" - ${student.name} | ${student.email}");
        }
      }

      print("Guardando en DB...");
      await importGroupsToDb.execute(courseId, groups);

      print("TODO GUARDADO EN DB");
    } catch (e) {
      print("ERROR: $e");
    }
  }
}