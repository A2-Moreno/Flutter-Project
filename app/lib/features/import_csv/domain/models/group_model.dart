import './student_model.dart';

class Group {
  final String categoryName;
  final String groupNumber;
  final String groupCode;
  final List<Student> students;
  Group({
    required this.categoryName,
    required this.groupNumber,
    required this.groupCode,
    required this.students
  });
}
