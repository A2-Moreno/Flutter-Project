class AllMyGroups {
  final String groupName;
  final String categoryName;
  final int membersCount;

  AllMyGroups({
    required this.groupName,
    required this.categoryName,
    required this.membersCount,
  });

  Map<String, dynamic> toJson() {
    return {
      "categoryName": categoryName,
      "groupName": groupName,
      "membersCount": membersCount,
    };
  }

  factory AllMyGroups.fromJson(Map<String, dynamic> json) {
    return AllMyGroups(
      categoryName: json["categoryName"],
      groupName: json["groupName"],
      membersCount: json["membersCount"],
    );
  }
}
