import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/features/activity/domain/models/activity_model.dart';
import 'package:app/features/evaluation/ui/pages/results_page.dart';
import 'package:app/features/evaluation/ui/pages/teacher_results_page.dart';
import 'package:app/features/evaluation/ui/viewmodels/teacher_results_controller.dart';
import 'package:app/features/groups/domain/models/group_member_model.dart';
import 'package:app/features/groups/domain/models/group_model.dart';

class MockTeacherResultsController extends GetxController
    implements TeacherResultsController {
  @override
  final isLoading = false.obs;

  @override
  final error = ''.obs;

  @override
  final studentsResults = <Map<String, dynamic>>[].obs;

  Activity? loadedActivity;
  Group? loadedGroup;

  @override
  Future<void> loadGroupResults(Activity activity, Group group) async {
    loadedActivity = activity;
    loadedGroup = group;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockTeacherResultsController mockController;

  final testActivity = Activity(
    id: 'activity_1',
    name: 'Evaluación Final',
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
      GroupMember(
        userId: 'user_3',
        name: 'Laura',
        email: 'laura@test.com',
      ),
    ],
  );

  Widget buildTestableWidget() {
    return GetMaterialApp(
      home: TeacherResultsPage(
        activity: testActivity,
        group: testGroup,
      ),
    );
  }

  setUp(() {
    Get.testMode = true;
    Get.reset();

    mockController = MockTeacherResultsController();
    Get.put<TeacherResultsController>(mockController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('debe ejecutar loadGroupResults al abrir la pantalla',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(mockController.loadedActivity, testActivity);
    expect(mockController.loadedGroup, testGroup);
  });

  testWidgets('debe mostrar indicador de carga cuando isLoading es true',
      (WidgetTester tester) async {
    mockController.isLoading.value = true;

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('debe mostrar mensaje de error cuando error tiene contenido',
      (WidgetTester tester) async {
    mockController.error.value = 'Error al cargar resultados del grupo';

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('Error al cargar resultados del grupo'), findsOneWidget);
  });

  testWidgets('debe mostrar mensaje cuando no hay resultados disponibles',
      (WidgetTester tester) async {
    mockController.studentsResults.clear();

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('No hay resultados disponibles'), findsOneWidget);
  });

  testWidgets('debe renderizar resultados de estudiantes',
      (WidgetTester tester) async {
    mockController.studentsResults.assignAll([
      {
        'name': 'Camila',
        'average': '4.7',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '5.0'},
          {'label': 'Aportes', 'score': '4.4'},
        ],
      },
      {
        'name': 'Juan',
        'average': '3.9',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '4.0'},
          {'label': 'Aportes', 'score': '3.8'},
        ],
      },
    ]);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('Resultados del grupo'), findsOneWidget);

    expect(find.text('Camila'), findsOneWidget);
    expect(find.text('4.7'), findsOneWidget);
    expect(find.text('5.0'), findsOneWidget);
    expect(find.text('4.4'), findsOneWidget);

    expect(find.text('Juan'), findsOneWidget);
    expect(find.text('3.9'), findsOneWidget);
    expect(find.text('4.0'), findsOneWidget);
    expect(find.text('3.8'), findsOneWidget);
  });

  testWidgets('debe ordenar los resultados de mayor a menor promedio',
      (WidgetTester tester) async {
    mockController.studentsResults.assignAll([
      {
        'name': 'Juan',
        'average': '3.9',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '4.0'},
        ],
      },
      {
        'name': 'Laura',
        'average': '4.2',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '4.2'},
        ],
      },
      {
        'name': 'Camila',
        'average': '4.7',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '5.0'},
        ],
      },
    ]);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    final firstCamila = tester.getTopLeft(find.text('Camila')).dy;
    final firstLaura = tester.getTopLeft(find.text('Laura')).dy;
    final firstJuan = tester.getTopLeft(find.text('Juan')).dy;

    expect(firstCamila, lessThan(firstLaura));
    expect(firstLaura, lessThan(firstJuan));
  });

  testWidgets('debe mostrar una tabla por cada estudiante con resultado',
      (WidgetTester tester) async {
    mockController.studentsResults.assignAll([
      {
        'name': 'Juan',
        'average': '3.9',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '4.0'},
        ],
      },
      {
        'name': 'Laura',
        'average': '4.2',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '4.2'},
        ],
      },
      {
        'name': 'Camila',
        'average': '4.7',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '5.0'},
        ],
      },
    ]);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.byType(ResultTableCard), findsNWidgets(3));
  });
}