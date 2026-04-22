class GroupMember {
  final String userId;
  final String name;
  final String email;

  GroupMember({required this.userId, required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {"userId": userId, "name": name, "email": email};
  }

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      userId: json["userId"],
      name: json["name"],
      email: json["email"],
    );
  }
}
