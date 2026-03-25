
class Course {
  final String id;
  final String name;
  final String nrc;
  final String profesorId;

  Course({
    required this.id,
    required this.name,
    required this.nrc,
    required this.profesorId,
  });

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "nrc": nrc,
      "profesor_id": profesorId,
    };
  }
}