import 'package:get/get.dart';

import '../domain/usecases/get_evaluation_results_usecase.dart';
import '../ui/viewmodels/teacher_results_controller.dart';

class TeacherResultsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetEvaluationResults(Get.find()), fenix: true);

    Get.lazyPut(() => TeacherResultsController(Get.find()), fenix: true);
  }
}
