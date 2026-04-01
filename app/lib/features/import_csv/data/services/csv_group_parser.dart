import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';

import '../../domain/models/group_model.dart';
import '../../domain/models/student_model.dart';

class CsvGroupParser {
  Future<List<Group>> parseCsv() async {
    final XTypeGroup typeGroup = XTypeGroup(
      label: 'CSV files',
      extensions: ['csv'],
    );

    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file == null) {
      return [];
    }
    final csvString = await file.readAsString();

    List<List<dynamic>> rows = const CsvToListConverter(
      eol: '\n',
    ).convert(csvString);

    if (rows.isEmpty) return [];

    rows.removeAt(0);

    Map<String, List<Student>> groupMap = {};
    Map<String, String> groupCodes = {};
    Map<String, String> categories = {};

    for (var row in rows) {
      if (row.length < 9) continue;

      final categoryName = row[0].toString().trim();
      final groupName = row[1].toString().trim();
      final groupCode = row[2].toString().trim();
      final firstName = row[5].toString().trim();
      final lastName = row[6].toString().trim();
      final email = row[7].toString().trim();

      final key = "$categoryName-$groupName";

      final student = Student(email: email, name: "$firstName $lastName");

      if (!groupMap.containsKey(key)) {
        groupMap[key] = [];
        groupCodes[key] = groupCode;
        categories[key] = categoryName;
      }

      groupMap[key]!.add(student);
    }

    List<Group> groups = [];

    groupMap.forEach((key, students) {
      final parts = key.split('-');

      groups.add(
        Group(
          categoryName: categories[key]!,
          groupNumber: parts.sublist(1).join('-'),
          groupCode: groupCodes[key]!,
          students: students,
        ),
      );
    });

    return groups;
  }
}
