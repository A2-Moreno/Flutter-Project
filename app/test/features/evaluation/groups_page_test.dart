import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/features/groups/domain/models/all_groups_model.dart';
import 'package:app/features/groups/domain/models/group_model.dart';
import 'package:app/features/evaluation/ui/pages/groups_page.dart';
import 'package:app/features/groups/ui/viewmodels/group_controller.dart';
import 'package:app/features/activity/domain/models/activity_model.dart';

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

  String? loadedCourseId;

  @override
  Future<void> loadAllMyGroups(String courseId) async {
    loadedCourseId = courseId;
  }

  @override
  Future<void> loadGroups(String activityId) async {}

  @override
  Future<void> refreshGroups(String categoryId) async {}

  @override
  Future<void> loadGlobalAverage(String activityId) async {}

  @override
  void openGroup(Activity activity, Group group) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGroupController mockGroupController;

  const testCourseId = 'course_123';

  final testGroups = [
    AllMyGroups(
      groupName: 'Grupo Alpha',
      categoryName: 'Matemáticas',
      membersCount: 3,
    ),
    AllMyGroups(
      groupName: 'Grupo Beta',
      categoryName: 'Física',
      membersCount: 4,
    ),
  ];

  Widget buildTestableWidget({String courseId = testCourseId}) {
    return GetMaterialApp(
      home: GroupsPage(courseId: courseId),
    );
  }

  setUp(() {
    Get.testMode = true;
    Get.reset();

    mockGroupController = MockGroupController();
    Get.put<GroupController>(mockGroupController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('debe ejecutar loadAllMyGroups al abrir la pantalla si courseId no está vacío',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(mockGroupController.loadedCourseId, testCourseId);
  });

  testWidgets('no debe ejecutar loadAllMyGroups si courseId está vacío',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(courseId: ''));
    await tester.pump();

    expect(mockGroupController.loadedCourseId, isNull);
  });

  testWidgets('debe mostrar indicador de carga cuando isLoading es true',
      (WidgetTester tester) async {
    mockGroupController.isLoading.value = true;

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('debe mostrar mensaje de error cuando error tiene contenido',
      (WidgetTester tester) async {
    mockGroupController.error.value = 'Error al cargar grupos';

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('Error al cargar grupos'), findsOneWidget);
  });

  testWidgets('debe mostrar mensaje cuando no hay grupos asignados',
      (WidgetTester tester) async {
    mockGroupController.allMyGroups.clear();

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('No tienes grupos asignados'), findsOneWidget);
  });

  testWidgets('debe renderizar correctamente la lista de grupos',
      (WidgetTester tester) async {
    mockGroupController.allMyGroups.assignAll(testGroups);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('Grupos'), findsOneWidget);

    expect(find.text('Matemáticas'), findsOneWidget);
    expect(find.text('Grupo Alpha'), findsOneWidget);
    expect(find.text('3/3 (Completo)'), findsOneWidget);

    expect(find.text('Física'), findsOneWidget);
    expect(find.text('Grupo Beta'), findsOneWidget);
    expect(find.text('4/4 (Completo)'), findsOneWidget);
  });

  testWidgets('debe mostrar una card por cada grupo cargado',
      (WidgetTester tester) async {
    mockGroupController.allMyGroups.assignAll(testGroups);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.byType(GroupDeliveryCard), findsNWidgets(2));
  });
}