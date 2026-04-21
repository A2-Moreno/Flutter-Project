import 'package:app/features/activity/domain/models/activity_model.dart';
import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:app/features/groups/domain/models/all_groups_model.dart';
import 'package:app/features/groups/domain/models/group_member_model.dart';
import 'package:app/features/groups/domain/models/group_model.dart';
import 'package:app/features/groups/ui/pages/group_page.dart';
import 'package:app/features/groups/ui/viewmodels/group_controller.dart';
import 'package:app/features/save_to_db/ui/viewmodels/savedb_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

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
  String? loadedGlobalAverageActivityId;
  Activity? openedActivity;
  Group? openedGroup;

  @override
  Future<void> loadGroups(String activityId) async {
    loadedActivityId = activityId;
  }

  @override
  Future<void> loadGlobalAverage(String activityId) async {
    loadedGlobalAverageActivityId = activityId;
  }

  @override
  Future<void> loadAllMyGroups(String courseId) async {}

  @override
  Future<void> refreshGroups(String categoryId) async {}

  @override
  void openGroup(Activity activity, Group group) {
    openedActivity = activity;
    openedGroup = group;
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

class MockImportGroupsController extends GetxController
    implements ImportGroupsController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> setLargeScreen(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1200, 2200);
  tester.view.devicePixelRatio = 1.0;

  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  Widget buildTestableWidget() {
    return GetMaterialApp(
      home: GroupScreen(activity: dummyActivity),
    );
  }

  setUp(() {
    Get.testMode = true;
    Get.reset();

    mockGroupController = MockGroupController();

    Get.put<GroupController>(mockGroupController);
    Get.put<ImportGroupsController>(MockImportGroupsController());
    Get.put<AuthenticationController>(MockAuthenticationController());
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'Debe ejecutar loadGroups y loadGlobalAverage al abrir la pantalla',
    (WidgetTester tester) async {
      await setLargeScreen(tester);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(mockGroupController.loadedActivityId, dummyActivity.id);
      expect(
        mockGroupController.loadedGlobalAverageActivityId,
        dummyActivity.id,
      );
    },
  );

  testWidgets(
    'Debe mostrar el título de la actividad y lista vacía inicialmente',
    (WidgetTester tester) async {
      await setLargeScreen(tester);

      mockGroupController.isLoading.value = false;
      mockGroupController.groups.clear();
      mockGroupController.globalAverage.value = 0.0;

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.text('Actividad de Prueba 1'), findsOneWidget);
      expect(find.text('Grupos'), findsOneWidget);
      expect(find.text('No hay grupos aún'), findsOneWidget);
      expect(find.text('Media de la evaluación'), findsOneWidget);
      expect(find.text('0.0'), findsOneWidget);
    },
  );

  testWidgets(
    'Debe listar los grupos y mostrar el promedio global',
    (WidgetTester tester) async {
      await setLargeScreen(tester);

      mockGroupController.isLoading.value = false;
      mockGroupController.groups.assignAll(dummyGroups);
      mockGroupController.globalAverage.value = 4.5;

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.text('Grupo A'), findsOneWidget);
      expect(find.textContaining('Juan Perez'), findsOneWidget);
      expect(find.textContaining('Maria Lopez'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('Media de la evaluación'), findsOneWidget);
    },
  );

  testWidgets(
    'Debe mostrar indicador de carga cuando isLoading es true',
    (WidgetTester tester) async {
      await setLargeScreen(tester);

      mockGroupController.isLoading.value = true;

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Debe mostrar loading del promedio global cuando isLoading2 es true',
    (WidgetTester tester) async {
      await setLargeScreen(tester);

      mockGroupController.isLoading.value = false;
      mockGroupController.groups.assignAll(dummyGroups);
      mockGroupController.isLoading2.value = true;

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Debe abrir el grupo al tocar una tarjeta',
    (WidgetTester tester) async {
      await setLargeScreen(tester);

      mockGroupController.isLoading.value = false;
      mockGroupController.groups.assignAll(dummyGroups);
      mockGroupController.globalAverage.value = 4.5;

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      await tester.tap(find.text('Grupo A'));
      await tester.pump();

      expect(mockGroupController.openedActivity, dummyActivity);
      expect(mockGroupController.openedGroup, dummyGroups.first);
    },
  );

  testWidgets(
    'capitalizeWords debe capitalizar correctamente',
    (WidgetTester tester) async {
      expect(capitalizeWords('juan perez'), 'Juan Perez');
      expect(capitalizeWords('MARIA LOPEZ'), 'Maria Lopez');
      expect(capitalizeWords('cAmIlA'), 'Camila');
    },
  );
}