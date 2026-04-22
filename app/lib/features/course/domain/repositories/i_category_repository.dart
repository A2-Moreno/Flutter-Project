import '../models/category_model.dart';

abstract class ICourseViewRepository {
  Future<List<Category>> getCategories(String courseId);
  
}