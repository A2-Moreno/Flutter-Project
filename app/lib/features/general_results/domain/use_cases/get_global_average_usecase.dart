import '../repositories/i_global_avereges_repository.dart';
import '../models/global_average_model.dart';

class GetCourseGlobalAverages {
  final IGeneralResultsRepository repository;

  GetCourseGlobalAverages(this.repository);

  Future<List<StudentGlobalAverage>> execute(String courseId) {
    return repository.getCourseGlobalAverages(courseId);
  }
}