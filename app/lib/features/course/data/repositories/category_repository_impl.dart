import '../../domain/models/category_model.dart';
import '../../domain/repositories/i_category_repository.dart';
import '../datasources/i_category_source_service_roble.dart';

class CourseViewRepositoryImpl implements ICourseViewRepository {

  final ICourseViewRemoteDataSource remote;

  CourseViewRepositoryImpl(this.remote);

  @override
  Future<List<Category>> getCategories(
    String courseId,
  ) {
    return remote.getCategoriesWithGroups(courseId);
  }
}