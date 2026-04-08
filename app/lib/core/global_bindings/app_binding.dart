import 'package:get/get.dart';

import '../../features/import_csv/binding/import_csv_binding.dart';
import '../../features/save_to_db/binding/save_to_db_binding.dart';
import '../../features/course/binding/course.binding.dart';
import '../../features/groups/binding/groups_binding.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/activity/binding/activity_binding.dart';
import '../../features/evaluation/binding/evaluation_binding.dart';
import '../../features/evaluation/binding/result_binding.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {

    HomeBinding().dependencies();
    ImportCsvBinding().dependencies();
    SaveDbBinding().dependencies();
    CourseBinding().dependencies();
    GroupDetailBinding().dependencies();
    ActivityBinding().dependencies();
    EvaluationBinding().dependencies();
    ResultsBinding().dependencies();
    
  }
}