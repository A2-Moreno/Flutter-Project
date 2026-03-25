import '../../domain/models/group_model.dart';

abstract class IGroupCsvRepository {
  Future<List<Group>> importGroups();
}