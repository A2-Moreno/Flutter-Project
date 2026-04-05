import '../models/group_model.dart';
import '../models/all_groups_model.dart';

abstract class IGroupDetailRepository {

  /// Profesor puede ver todos los grupos
  Future<List<Group>> getGroupsByCategory(String categoryId);

  /// Estudiante solo obtiene su grupo en la categoria
  Future<Group?> getMyGroup(
    String categoryId,
    String userId,
  );

  Future<List<AllMyGroups>> getAllMyGroups(String courseId,String userId);

}