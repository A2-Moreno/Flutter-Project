import '../../domain/models/category_model.dart';

abstract class ICourseViewRemoteDataSource {
  Future<List<Category>> getCategoriesWithGroups(String courseId);
}