import 'package:app/features/groups/domain/models/group_member_model.dart';

class Group {
  final String id;
  final String name;
  final String code;
  final List<GroupMember> members;

  Group({
    required this.id,
    required this.name,
    required this.code,
    required this.members,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "code": code,
      "members": members.map((m) => m.toJson()).toList(),
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json["id"],
      name: json["name"],
      code: json["code"],
      members: (json["members"] as List)
          .map((m) => GroupMember.fromJson(m))
          .toList(),
    );
  }
}
