class Activity {
  final String id;
  final String name;
  final String courseId;
  final String categoryId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isPublic;

  Activity({
    required this.id,
    required this.name,
    required this.courseId,
    required this.categoryId,
    required this.startDate,
    required this.endDate,
    required this.isPublic,
  });
}