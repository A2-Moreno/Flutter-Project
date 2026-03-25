import '../models/group_model.dart';
import '../../domain/repositories/group_repository.dart';

class ImportGroups {
  
  final IGroupCsvRepository repository;

  ImportGroups(this.repository);

  Future<List<Group>> execute() {
    print('estamos en el usecase');
    return repository.importGroups();
  }
} 