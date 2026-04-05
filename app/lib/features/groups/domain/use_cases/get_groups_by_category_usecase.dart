import '../repositories/i_group_repository.dart';
import '../models/group_model.dart';

class GetGroupsByCategory {
  final IGroupDetailRepository repository;

  GetGroupsByCategory(this.repository);

  Future<List<Group>> execute(String categoryId) {
    return repository.getGroupsByCategory(categoryId);
  }
}