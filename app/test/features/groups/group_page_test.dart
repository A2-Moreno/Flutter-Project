import 'package:app/features/activity/domain/models/activity_model.dart';
import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:app/features/groups/ui/pages/group_page.dart';
import 'package:app/features/groups/ui/viewmodels/group_controller.dart';
import 'package:app/features/groups/domain/models/group_model.dart';
import 'package:app/features/groups/domain/models/group_member_model.dart';
import 'package:app/features/save_to_db/ui/viewmodels/savedb_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class MockGroupController extends GetxController implements GroupController {
  @override
  var isLoading = false.obs;
  @override
  var isLoading2 = false.obs;
  @override
  var groups = <Group>[].obs;
  @override
  var globalAverage = 0.0.obs;
  @override
  var isTeacher = false.obs;
  @override
  var error = "".obs;

  @override
  Future<void> loadGroups(String activityId) async {}

  @override
  Future<void> loadGlobalAverage(String activityId) async {}

  @override
  void openGroup(Activity activity, Group group) {}

  // Otros métodos requeridos por la interfaz pero no usados en este test
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthenticationController extends GetxController
    implements AuthenticationController {
  @override
  var isTeacher = false.obs;
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockImportGroupsController extends GetxController
    implements ImportGroupsController {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockGroupController mockGroupController;

  final dummyActivity = Activity(
    id: '1',
    name: 'Actividad de Prueba 1',
    courseId: '123',
    categoryId: 'cat1',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 7)),
    isPublic: true,
  );

  final dummyGroups = [
    Group(
      id: 'g1',
      name: 'Grupo A',
      code: 'CODE123',
      members: [
        GroupMember(
          userId: '1',
          name: 'JUAN PEREZ',
          email: 'juan.perez@example.com',
        ),
        GroupMember(
          userId: '2',
          name: 'MARIA LOPEZ',
          email: 'maria.lopez@example.com',
        ),
      ],
    ),
  ];

  setUp(() {
    mockGroupController =
        Get.put<GroupController>(MockGroupController()) as MockGroupController;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'Debe mostrar el título de la actividad y lista vacía inicialmente',
    (WidgetTester tester) async {
      mockGroupController.isLoading.value = false;
      mockGroupController.groups.value = [];

      await tester.pumpWidget(
        GetMaterialApp(home: GroupScreen(activity: dummyActivity)),
      );

      expect(find.text('Laboratorio de Banano'), findsOneWidget);
      expect(find.text('No hay grupos aún'), findsOneWidget);
    },
  );

  testWidgets('Debe listar los grupos y mostrar el promedio global', (
    WidgetTester tester,
  ) async {
    mockGroupController.isLoading.value = false;
    mockGroupController.groups.assignAll(dummyGroups);
    mockGroupController.globalAverage.value = 4.5;

    await tester.pumpWidget(
      GetMaterialApp(home: GroupScreen(activity: dummyActivity)),
    );

    await tester.pump();

    expect(find.text('Grupo A'), findsOneWidget);

    expect(find.textContaining('Juan Perez'), findsOneWidget);
    expect(find.textContaining('Maria Lopez'), findsOneWidget);

    expect(find.text('4.5'), findsOneWidget);
  });

  testWidgets('Debe mostrar indicador de carga cuando isLoading es true', (
    WidgetTester tester,
  ) async {
    mockGroupController.isLoading.value = true;

    await tester.pumpWidget(
      GetMaterialApp(home: GroupScreen(activity: dummyActivity)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
