import 'package:app/features/general_results/ui/viewmodels/general_controller.dart';
import 'package:flutter/material.dart';
import 'package:app/core/i_local_preferences.dart';
import 'package:app/features/activity/domain/models/activity_model.dart';
import 'package:app/features/activity/domain/usecases/get_activities_by_course_usecase.dart';
import 'package:app/features/auth/domain/models/authentication_user.dart';
import 'package:app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:app/features/course/domain/models/category_model.dart';
import 'package:app/features/course/domain/use_cases/get_categories_usecase.dart';
import 'package:app/features/course/ui/viewmodels/course_controller.dart';
import 'package:app/features/import_csv/domain/use_cases/import_groups.dart';
import 'package:app/features/save_to_db/domain/use_cases/import_groupsdb.dart';
import 'package:app/features/save_to_db/ui/viewmodels/savedb_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app/features/course/ui/pages/course_page.dart';

class MockCourseController extends GetxController implements CourseController {
  @override
  var isLoading = false.obs;
  @override
  var availableActivities = <Activity>[].obs;
  @override
  var expiredActivities = <Activity>[].obs;
  @override
  var activities = <Activity>[].obs;
  @override
  var categories = <Category>[].obs;

  @override
  Future<void> loadCategories(dynamic id) async {}
  @override
  Future<void> loadActivities(dynamic id) async {}
  @override
  void openCategoryStudent(dynamic a) {}
  @override
  void openCategory(dynamic a) {}
  @override
  void createActivityPage(dynamic id) {}
  @override
  void openGroupsStudent(dynamic id) {}
  @override
  void openGeneralResults(dynamic id) {}

  @override
  GetActivitiesByCourse get getActivities => throw UnimplementedError();
  @override
  GetCategories get getCategories => throw UnimplementedError();
}

class MockAuthenticationController extends GetxController
    implements AuthenticationController {
  @override
  var isTeacher = false.obs;
  @override
  var logged = false.obs;
  @override
  var isLoading = false.obs;
  @override
  var signingUp = false.obs;
  @override
  var validating = false.obs;
  @override
  var userName = ''.obs;
  @override
  var userEmail = ''.obs;
  @override
  var userPassword = ''.obs;
  @override
  AuthenticationUser? loggedUser;

  @override
  Future<bool> login(email, password) async => true;
  @override
  Future<bool> signUp(name, email, password, bool direct) async => true;
  @override
  Future<void> logOut() async {}
  @override
  Future<bool> validateToken() async => true;
  @override
  Future<AuthenticationUser?> getLoggedUser() async => loggedUser;
  @override
  Future<List<AuthenticationUser>> getUsers() async => [];
  @override
  Future<void> forgotPassword(String email) async {}
  @override
  Future<bool> validate(String email, String validationCode) async => true;
  @override
  Future<void> verifyAccount(String e, String c, String p, String n) async {}

  @override
  IAuthRepository get authentication => throw UnimplementedError();
  @override
  ILocalPreferences get localPreferences => throw UnimplementedError();
}

class MockImportGroupsController extends GetxController
    implements ImportGroupsController {
  @override
  Future<void> importCsv(dynamic courseId) async {}
  @override
  ImportGroups get importGroups => throw UnimplementedError();
  @override
  ImportGroupsToDb get importGroupsToDb => throw UnimplementedError();
}

class MockCourseResultsController extends GetxController
    implements CourseResultsController {
  @override
  var isLoading = false.obs;
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final testActivities = [
    Activity(
      id: '1',
      name: 'Actividad de Prueba 1',
      courseId: '123',
      categoryId: 'cat1',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 7)),
      isPublic: true,
    ),
    Activity(
      id: '2',
      name: 'Actividad Vencida',
      courseId: '123',
      categoryId: 'cat1',
      startDate: DateTime.now().subtract(const Duration(days: 14)),
      endDate: DateTime.now().subtract(const Duration(days: 7)),
      isPublic: false,
    ),
  ];

  setUpAll(() async {
    await initializeDateFormatting('es', null);
  });

  late CourseController controller;
  late AuthenticationController authController;
  late ImportGroupsController importController;
  late CourseResultsController resultsController;

  setUp(() {
    importController = Get.put<ImportGroupsController>(
      MockImportGroupsController(),
    );
    controller = Get.put<CourseController>(MockCourseController());
    authController = Get.put<AuthenticationController>(
      MockAuthenticationController(),
    );
    resultsController = Get.put<CourseResultsController>(
      MockCourseResultsController(),
    );
  });

  tearDown(() {
    Get.reset();
  });

  final dummyCourse = {'_id': '123', 'name': 'Curso de Prueba Flutter'};

  testWidgets('Debe mostrar el título del curso y estado vacío', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(home: CourseScreen(course: dummyCourse)),
    );

    expect(find.text('Curso de Prueba Flutter'), findsOneWidget);
    expect(find.text('No hay actividades aún'), findsOneWidget);
  });

  testWidgets('Debe mostrar actividades cuando el controlador tiene datos', (
    WidgetTester tester,
  ) async {
    controller.availableActivities.assignAll([testActivities[0]]);
    controller.isLoading.value = false;

    await tester.pumpWidget(
      GetMaterialApp(home: CourseScreen(course: dummyCourse)),
    );
    await tester.pump();

    expect(find.text('Actividad de Prueba 1'), findsOneWidget);
    expect(find.text('No hay actividades aún'), findsNothing);
  });

  testWidgets('Debe mostrar botones de profesor solo cuando tiene el rol', (
    WidgetTester tester,
  ) async {
    authController.isTeacher.value = true;

    await tester.pumpWidget(
      GetMaterialApp(home: CourseScreen(course: dummyCourse)),
    );
    await tester.pump();

    expect(find.text('Importar Grupos'), findsOneWidget);
    expect(find.text('Crear evaluación'), findsOneWidget);
  });

  testWidgets('Debe mostrar indicador de carga cuando isLoading es true', (
    WidgetTester tester,
  ) async {
    controller.isLoading.value = true;

    await tester.pumpWidget(
      GetMaterialApp(home: CourseScreen(course: dummyCourse)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
