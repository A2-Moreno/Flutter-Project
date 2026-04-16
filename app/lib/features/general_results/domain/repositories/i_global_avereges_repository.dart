import '../models/global_average_model.dart';
import '../models/groups_global_average_model.dart';

abstract class IGeneralResultsRepository {
  Future<List<StudentGlobalAverage>> getCourseGlobalAverages(
    String courseId,
  );

Future<List<GroupActivityAverage>> getGroupsGlobalAverage(
    String courseId,
  );

}