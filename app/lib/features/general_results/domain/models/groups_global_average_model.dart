class GroupActivityAverage {
  final String activityName;
  final List<GroupAverage> groups;

  GroupActivityAverage({
    required this.activityName,
    required this.groups,
  });
}

class GroupAverage {
  final String groupId;
  final String groupName;
  final double average;

  GroupAverage({
    required this.groupId,
    required this.groupName,
    required this.average,
  });
}