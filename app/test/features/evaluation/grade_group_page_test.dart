import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/core/i_local_preferences.dart';
import 'package:app/features/activity/domain/models/activity_model.dart';
import 'package:app/features/evaluation/ui/pages/grade_group_page.dart';
import 'package:app/features/evaluation/ui/viewmodels/evaluation_controller.dart';
import 'package:app/features/groups/domain/models/all_groups_model.dart';
import 'package:app/features/groups/domain/models/group_member_model.dart';
import 'package:app/features/groups/domain/models/group_model.dart';
import 'package:app/features/groups/ui/viewmodels/group_controller.dart';

class MockLocalPreferences extends GetxService implements ILocalPreferences {
  final Map<String, dynamic> _data = {
    'rol': 'estudiante',
    'userId': 'student_1',
  };

  @override
  Future<String?> getString(String key) async => _data[key] as String?;

  @override
  Future<void> setString(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<int?> getInt(String key) async => _data[key] as int?;

  @override
  Future<void> setInt(String key, int value) async {
    _data[key] = value;
  }

  @override
  Future<double?> getDouble(String key) async => _data[key] as double?;

  @override
  Future<void> setDouble(String key, double value) async {
    _data[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async => _data[key] as bool?;

  @override
  Future<void> setBool(String key, bool value) async {
    _data[key] = value;
  }

  @override
  Future<List<String>?> getStringList(String key) async =>
      _data[key] as List<String>?;

  @override
  Future<void> setStringList(String key, List<String> value) async {
    _data[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
  }

  @override
  Future<void> clear() async {
    _data.clear();
  }

  void setValue(String key, dynamic value) {
    _data[key] = value;
  }
}

class MockGroupController extends GetxController implements GroupController {
  @override
  final isLoading = false.obs;

  @override
  final isLoading2 = false.obs;

  @override
  final groups = <Group>[].obs;

  @override
  final myGroup = Rxn<Group>();

  @override
  final isTeacher = false.obs;

  @override
  final error = ''.obs;

  @override
  final allMyGroups = <AllMyGroups>[].obs;

  @override
  final globalAverage = 0.0.obs;

  String? loadedActivityId;

  @override
  Future<void> loadGroups(String activityId) async {
    loadedActivityId = activityId;
  }

  @override
  Future<void> loadAllMyGroups(String courseId) async {}

  @override
  Future<void> refreshGroups(String categoryId) async {}

  @override
  Future<void> loadGlobalAverage(String activityId) async {}

  @override
  void openGroup(Activity activity, Group group) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockEvaluationController extends GetxController
    implements EvaluationController {
  @override
  final isLoading = false.obs;

  @override
  final error = ''.obs;

  @override
  final isEvaluationMode = false.obs;

  @override
  final isResultMode = false.obs;

  @override
  final grades = <String, Map<String, double>>{}.obs;

  @override
  final mySubmittedGrades = <String, Map<String, double>>{}.obs;

  Activity? initializedActivity;
  String? submittedActivityId;
  Activity? openedResultsActivity;

  final List<Map<String, dynamic>> setGradeCalls = [];

  @override
  Future<void> init(Activity activity) async {
    initializedActivity = activity;
  }

  @override
  void setGrade(String evaluatedUserId, String criterion, double value) {
    setGradeCalls.add({
      'evaluatedUserId': evaluatedUserId,
      'criterion': criterion,
      'value': value,
    });

    grades.putIfAbsent(evaluatedUserId, () => {});
    grades[evaluatedUserId]![criterion] = value;
  }

  @override
  Future<void> submit(String activityId) async {
    submittedActivityId = activityId;
  }

  @override
  Future<void> loadMyGrades(String activityId) async {}

  @override
  void openResults(Activity activity) {
    openedResultsActivity = activity;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLocalPreferences mockPrefs;
  late MockGroupController mockGroupController;
  late MockEvaluationController mockEvalController;

  final testActivity = Activity(
    id: 'activity_1',
    name: 'Evaluación de Proyecto',
    courseId: 'course_1',
    categoryId: 'category_1',
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 1)),
    isPublic: true,
  );

  final testGroup = Group(
    id: 'group_1',
    name: 'Grupo Alpha',
    code: 'A1',
    members: [
      GroupMember(
        userId: 'user_1',
        name: 'Camila',
        email: 'camila@test.com',
      ),
      GroupMember(
        userId: 'user_2',
        name: 'Juan',
        email: 'juan@test.com',
      ),
    ],
  );

  Widget buildTestableWidget() {
    return GetMaterialApp(
      home: GradeGroupPage(activity: testActivity),
    );
  }

  setUp(() {
    Get.testMode = true;
    Get.reset();

    mockPrefs = MockLocalPreferences();
    mockGroupController = MockGroupController();
    mockEvalController = MockEvaluationController();

    Get.put<ILocalPreferences>(mockPrefs);
    Get.put<GroupController>(mockGroupController);
    Get.put<EvaluationController>(mockEvalController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('debe ejecutar loadGroups e init al abrir la pantalla',
      (WidgetTester tester) async {
    mockGroupController.myGroup.value = testGroup;
    mockEvalController.isEvaluationMode.value = true;

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(mockGroupController.loadedActivityId, testActivity.id);
    expect(mockEvalController.initializedActivity, testActivity);
  });

  testWidgets('debe mostrar indicador de carga si algun controller esta cargando',
      (WidgetTester tester) async {
    mockGroupController.isLoading.value = true;

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'debe mostrar mensaje de error cuando groupController.error tiene contenido',
      (WidgetTester tester) async {
    mockGroupController.error.value = 'Ocurrió un error al cargar grupos';

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('Ocurrió un error al cargar grupos'), findsOneWidget);
  });

  testWidgets('debe mostrar mensaje cuando el estudiante no pertenece a ningun grupo',
      (WidgetTester tester) async {
    mockGroupController.myGroup.value = null;

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(
      find.text('No perteneces a ningún grupo en esta categoría'),
      findsOneWidget,
    );
  });

  testWidgets('debe mostrar miembros, inputs y botones en modo evaluacion',
      (WidgetTester tester) async {
    mockGroupController.myGroup.value = testGroup;
    mockEvalController.isEvaluationMode.value = true;
    mockEvalController.isResultMode.value = false;

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('Evaluación de Proyecto'), findsOneWidget);
    expect(find.text('Camila'), findsOneWidget);
    expect(find.text('Juan'), findsOneWidget);

    expect(find.text('Puntualidad'), findsNWidgets(2));
    expect(find.text('Aportes'), findsNWidgets(2));
    expect(find.text('Compromiso'), findsNWidgets(2));
    expect(find.text('Actitud'), findsNWidgets(2));

    expect(find.byType(TextFormField), findsNWidgets(8));
    expect(find.text('Enviar evaluacion'), findsOneWidget);
    expect(find.text('Ver resultado'), findsOneWidget);
  });

  testWidgets('debe llamar setGrade cuando se ingresa una nota valida',
      (WidgetTester tester) async {
    mockGroupController.myGroup.value = testGroup;
    mockEvalController.isEvaluationMode.value = true;
    mockEvalController.isResultMode.value = false;

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    final firstInput = find.byType(TextFormField).first;
    await tester.enterText(firstInput, '4.5');
    await tester.pump();

    expect(mockEvalController.setGradeCalls.length, 1);
    expect(mockEvalController.setGradeCalls.first['evaluatedUserId'], 'user_1');
    expect(mockEvalController.setGradeCalls.first['criterion'], 'Puntualidad');
    expect(mockEvalController.setGradeCalls.first['value'], 4.5);
  });

  testWidgets('debe mostrar notas en texto y ocultar enviar en modo resultado',
      (WidgetTester tester) async {
    mockGroupController.myGroup.value = testGroup;
    mockEvalController.isEvaluationMode.value = false;
    mockEvalController.isResultMode.value = true;

    mockEvalController.mySubmittedGrades.assignAll({
      'user_1': {
        'Puntualidad': 4.5,
        'Aportes': 4.0,
        'Compromiso': 5.0,
        'Actitud': 4.2,
      },
      'user_2': {
        'Puntualidad': 3.8,
        'Aportes': 4.1,
        'Compromiso': 4.7,
        'Actitud': 5.0,
      },
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.byType(TextFormField), findsNothing);
    expect(find.text('Enviar evaluacion'), findsNothing);
    expect(find.text('Ver resultado'), findsOneWidget);

    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('4.0'), findsOneWidget);
    expect(find.text('5.0'), findsNWidgets(2));
    expect(find.text('4.2'), findsOneWidget);
    expect(find.text('3.8'), findsOneWidget);
    expect(find.text('4.1'), findsOneWidget);
    expect(find.text('4.7'), findsOneWidget);
  });

  testWidgets('debe llamar submit y openResults al tocar los botones',
      (WidgetTester tester) async {
    mockGroupController.myGroup.value = testGroup;
    mockEvalController.isEvaluationMode.value = true;
    mockEvalController.isResultMode.value = false;

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    await tester.tap(find.text('Enviar evaluacion'));
    await tester.pump();

    expect(mockEvalController.submittedActivityId, testActivity.id);

    await tester.tap(find.text('Ver resultado'));
    await tester.pump();

    expect(mockEvalController.openedResultsActivity, testActivity);
  });
}