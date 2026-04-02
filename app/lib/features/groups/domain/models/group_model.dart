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
}