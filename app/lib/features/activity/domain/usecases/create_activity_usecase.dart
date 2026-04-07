import '../repositories/i_activity_repository.dart';
import '../models/activity_model.dart';

class CreateActivity {

  final IActivityRepository repository;

  CreateActivity(this.repository);

  Future<void> execute(Activity activity) async {
  
    if (activity.name.isEmpty) {
      throw Exception("El nombre no puede estar vacío");
    }

    if (activity.startDate.isAfter(activity.endDate)) {
      throw Exception("La fecha de inicio no puede ser mayor a la final");
    }

    return repository.createActivity(activity);
  }
}