import '../repositories/i_category_repository.dart';
import '../models/category_model.dart';

class GetCategories {
  final ICourseViewRepository repository;

  GetCategories(this.repository);

  Future<List<Category>> execute(String courseId) {
    return repository.getCategories(courseId);
  }
}