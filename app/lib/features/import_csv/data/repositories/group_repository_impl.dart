import '../../domain/repositories/group_repository.dart';
import '../services/csv_group_parser.dart';
import '../../domain/models/group_model.dart';

class GroupCsvRepositoryImpl implements IGroupCsvRepository {

  final CsvGroupParser parser;

  GroupCsvRepositoryImpl(this.parser);

  @override
  Future<List<Group>> importGroups() {
    print('estamos en el data repository');
    return parser.parseCsv();
  }
}