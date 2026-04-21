import 'package:app/features/course/ui/viewmodels/course_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';

import 'package:app/central.dart';
import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:app/features/auth/data/repositories/auth_repository.dart';
import 'package:app/features/auth/data/datasources/remote/authentication_source_service_roble.dart';
import 'package:app/core/i_local_preferences.dart';

import 'package:app/features/home/ui/viewmodels/home_controller.dart';
import 'package:app/features/home/data/repositories/course_repository.dart';
import 'package:app/features/home/data/datasource/course_remote_data_source.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../test/helpers/test_helper.dart';
import '../../test/helpers/test_helper.mocks.dart';
import 'teacher_mock.dart';

import 'package:app/features/teacher/data/datasources/course_create_source_service_roble.dart'
    as create_src;

import 'package:app/features/teacher/data/repositories/course_create_repository.dart';
import 'package:app/features/teacher/ui/viewmodels/create_courses_controller.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockClient mockClient;
  late MockILocalPreferences mockPrefs;
  late AuthenticationController authController;
  late HomeController homeController;

  Future<void> slowDown(WidgetTester tester, [int seconds = 1]) async {
    await tester.pump(Duration(seconds: seconds));
  }

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
    dotenv.env['EXPO_PUBLIC_ROBLE_PROJECT_ID'] = 'prueba_202';
  });

  setUp(() {
    TestHelper.resetAndInit();
    mockClient = MockClient();
    mockPrefs = MockILocalPreferences();

    TestHelper.injectMock<http.Client>(mockClient);
    TestHelper.injectMock<ILocalPreferences>(mockPrefs);

    final authDataSource = AuthenticationSourceServiceRoble(client: mockClient);
    final authRepository = AuthRepository(authDataSource);
    authController = AuthenticationController(authRepository);
    TestHelper.injectMock<AuthenticationController>(authController);

    Get.put<ILocalPreferences>(mockPrefs);

    final courseRepo = CourseRepository(
      CourseRemoteDataSource(client: mockClient),
    );
    homeController = Get.put(HomeController(courseRepo));

    final createSource = create_src.CourseRemoteDataSource(client: mockClient);
    final createRepo = CourseCreateRepository(createSource);
    Get.put<CreateController>(CreateController(createRepo));
  });

  tearDown(() {
    Get.reset();
  });

  Widget createWidget() => const GetMaterialApp(home: Central());

  testWidgets("Prueba de integración - Profesor", (tester) async {
    TeacherMock().setupTeacherMocks(mockClient, mockPrefs);

    await initializeDateFormatting('es', null);

    // ***** LOGIN *****
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();
    await slowDown(tester, 2);

    await tester.enterText(
      find.byKey(const Key("loginEmailField")),
      "test@correo.com",
    );
    await slowDown(tester);

    await tester.enterText(
      find.byKey(const Key("loginPasswordField")),
      "123456",
    );
    await slowDown(tester);

    await tester.tap(find.byKey(const Key("loginButton")));
    await tester.pump();
    await slowDown(tester, 2);

    // ***** HOME *****
    homeController.loadCourses();
    await tester.pumpAndSettle();
    await slowDown(tester, 2);

    expect(homeController.courses.length, 1);

    expect(find.text("Hola, Test User"), findsOneWidget);

    expect(find.text("Criptografía Avanzada"), findsOneWidget);

    expect(find.text("+ Crear curso"), findsOneWidget);

    await tester.tap(find.text("+ Crear curso"));
    await tester.pumpAndSettle();
    await slowDown(tester, 2);

    // ***** CREAR CURSO *****
    await tester.enterText(
      find.byType(TextFormField).at(0),
      "Curso de Robótica",
    );
    await slowDown(tester);
    await tester.enterText(find.byType(TextFormField).at(1), "1234");
    await slowDown(tester, 2);
    await tester.tap(find.byKey(const Key("createButton")));
    await tester.pumpAndSettle();
    await slowDown(tester, 2);

    ScaffoldMessenger.of(
      tester.element(find.byType(Scaffold)),
    ).removeCurrentSnackBar();
    await tester.pump();
    await slowDown(tester, 2);

    await tester.tap(find.byKey(const Key("backButton")));
    await tester.pumpAndSettle();

    // ***** HOME *****
    TeacherMock().injectCourseDependencies("c1");
    homeController.loadCourses();
    await tester.pumpAndSettle();
    await slowDown(tester, 2);
    expect(find.text("Curso de Robótica"), findsOneWidget);

    await tester.tap(find.text("Criptografía Avanzada"));
    await tester.pumpAndSettle();

    // ***** COURSE ******
    final courseController = Get.find<CourseController>();
    await slowDown(tester, 2);
    await tester.pumpAndSettle();

    expect(courseController.activities.isNotEmpty, true);

    expect(find.text("Proyecto I+D"), findsOneWidget);

    await slowDown(tester, 2);
    await tester.pumpAndSettle();
  });
}
