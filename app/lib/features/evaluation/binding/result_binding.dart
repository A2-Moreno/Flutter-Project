import 'package:get/get.dart';

import '../data/datasources/i_evaluation_remote_data_source.dart';
import '../data/datasources/evaluation_remote_data_source_roble.dart';
import '../domain/repositories/i_evaluation_repository.dart';
import '../data/repositories/evaluation_repository_impl.dart';
import '../domain/usecases/get_evaluation_results_usecase.dart';
import '../ui/viewmodels/results_controller.dart';

class ResultsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IEvaluationRemoteDataSource>(
      () => EvaluationRemoteDataSourceRoble(),
      fenix: true,
    );

    Get.lazyPut<IEvaluationRepository>(
      () => EvaluationRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut(() => GetEvaluationResults(Get.find()), fenix: true);

    Get.lazyPut(
      () => ResultsController(
        Get.find(),
      ),
      fenix: true,
    );
  }
}
