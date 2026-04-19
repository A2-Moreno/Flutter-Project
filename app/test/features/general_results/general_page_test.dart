import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:app/features/general_results/ui/pages/general_page.dart';
import 'package:app/features/general_results/ui/viewmodels/general_controller.dart';

class MockCourseResultsController extends GetxController
    implements CourseResultsController {
  @override
  final isLoading = false.obs;

  @override
  final error = ''.obs;

  @override
  final students = <Map<String, dynamic>>[].obs;

  @override
  final groupResults = <Map<String, dynamic>>[].obs;

  String? loadedCourseId;
  String? loadedGroupsCourseId;

  @override
  Future<void> loadCourseResults(String courseId) async {
    loadedCourseId = courseId;
  }

  @override
  Future<void> loadGroupsGlobalAverage(String courseId) async {
    loadedGroupsCourseId = courseId;
  }

  @override
  bool get hasData => students.isNotEmpty;

  @override
  bool get isEmpty => students.isEmpty && !isLoading.value;

  @override
  String get emptyMessage => "No hay resultados disponibles";

  @override
  List<Map<String, dynamic>> get top3 {
    if (students.length <= 3) return students;
    return students.sublist(0, 3);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthenticationController extends GetxController
    implements AuthenticationController {
  @override
  final logged = false.obs;

  @override
  final signingUp = false.obs;

  @override
  final validating = false.obs;

  @override
  final isLoading = false.obs;

  @override
  final userName = ''.obs;

  @override
  final userEmail = ''.obs;

  @override
  final userPassword = ''.obs;

  @override
  final isTeacher = false.obs;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockCourseResultsController mockController;
  late MockAuthenticationController mockAuthController;

  const testCourseId = 'course_123';

  Widget buildTestableWidget() {
    return GetMaterialApp(
      home: GeneralPage(courseId: testCourseId),
    );
  }

  setUp(() {
    Get.testMode = true;
    Get.reset();

    mockController = MockCourseResultsController();
    mockAuthController = MockAuthenticationController();

    Get.put<CourseResultsController>(mockController);
    Get.put<AuthenticationController>(mockAuthController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
      'debe ejecutar loadCourseResults y loadGroupsGlobalAverage al abrir la pantalla',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(mockController.loadedCourseId, testCourseId);
    expect(mockController.loadedGroupsCourseId, testCourseId);
  });

  testWidgets('debe iniciar mostrando la pestaña Estudiantes',
      (WidgetTester tester) async {
    mockController.students.assignAll([
      {'id': '1', 'name': 'juan perez', 'average': '4.5'},
    ]);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('Estudiantes'), findsOneWidget);
    expect(find.text('Grupos'), findsOneWidget);
    expect(find.text('Juan Perez'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
  });

  testWidgets('debe mostrar loading en vista estudiantes',
      (WidgetTester tester) async {
    mockController.isLoading.value = true;

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('debe mostrar mensaje cuando no hay estudiantes',
      (WidgetTester tester) async {
    mockController.students.clear();

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('No hay estudiantes'), findsOneWidget);
  });

  testWidgets('debe renderizar correctamente la lista de estudiantes',
      (WidgetTester tester) async {
    mockController.students.assignAll([
      {'id': '1', 'name': 'juan perez', 'average': '4.5'},
      {'id': '2', 'name': 'maria lopez', 'average': '3.8'},
    ]);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('Juan Perez'), findsOneWidget);
    expect(find.text('Maria Lopez'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('3.8'), findsOneWidget);
  });

  testWidgets('debe cambiar a la pestaña Grupos al tocar Grupos',
      (WidgetTester tester) async {
    mockController.groupResults.assignAll([
      {
        'activity': 'Actividad 1',
        'groups': [
          {'id': 'g1', 'name': 'Grupo Alpha', 'average': '4.2'},
          {'id': 'g2', 'name': 'Grupo Beta', 'average': '3.9'},
        ],
      },
    ]);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    await tester.tap(find.text('Grupos'));
    await tester.pump();

    expect(find.text('Actividad 1'), findsOneWidget);

    await tester.tap(find.text('Actividad 1'));
    await tester.pumpAndSettle();

    expect(find.text('Grupo Alpha'), findsOneWidget);
    expect(find.text('Grupo Beta'), findsOneWidget);
    expect(find.text('4.2'), findsOneWidget);
    expect(find.text('3.9'), findsOneWidget);
  });

  testWidgets('debe mostrar loading en vista grupos',
      (WidgetTester tester) async {
    mockController.isLoading.value = true;

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    await tester.tap(find.text('Grupos'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('debe mostrar mensaje cuando no hay datos en grupos',
      (WidgetTester tester) async {
    mockController.groupResults.clear();

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    await tester.tap(find.text('Grupos'));
    await tester.pumpAndSettle();

    expect(find.text('No hay datos'), findsOneWidget);
  });

  testWidgets('debe renderizar actividades y grupos dentro del ExpansionTile',
      (WidgetTester tester) async {
    mockController.groupResults.assignAll([
      {
        'activity': 'Proyecto Final',
        'groups': [
          {'id': 'g1', 'name': 'Grupo Alpha', 'average': '4.7'},
          {'id': 'g2', 'name': 'Grupo Beta', 'average': '4.1'},
        ],
      },
      {
        'activity': 'Exposición',
        'groups': [
          {'id': 'g3', 'name': 'Grupo Gamma', 'average': '3.9'},
        ],
      },
    ]);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    await tester.tap(find.text('Grupos'));
    await tester.pump();

    expect(find.text('Proyecto Final'), findsOneWidget);
    expect(find.text('Exposición'), findsOneWidget);

    await tester.tap(find.text('Proyecto Final'));
    await tester.pumpAndSettle();

    expect(find.text('Grupo Alpha'), findsOneWidget);
    expect(find.text('Grupo Beta'), findsOneWidget);
    expect(find.text('4.7'), findsOneWidget);
    expect(find.text('4.1'), findsOneWidget);
  });

  testWidgets('capitalizeWords debe capitalizar correctamente',
      (WidgetTester tester) async {
    expect(capitalizeWords('juan perez'), 'Juan Perez');
    expect(capitalizeWords('   maria   lopez   '), 'Maria Lopez');
    expect(capitalizeWords('cAmIlA'), 'Camila');
  });
}