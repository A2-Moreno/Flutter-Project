import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:integration_test/integration_test.dart';

import 'package:app/features/auth/ui/pages/login_page.dart';
import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:app/features/auth/data/repositories/auth_repository.dart';
import 'package:app/features/auth/data/datasources/remote/authentication_source_service_roble.dart';
import 'package:app/core/i_local_preferences.dart';

import '../test/helpers/test_helper.dart';
import '../test/helpers/test_helper.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockClient mockClient;
  late MockILocalPreferences mockPrefs;
  late AuthenticationController authController;

  Future<void> slowDown([int seconds = 1]) async {
    await Future.delayed(Duration(seconds: seconds));
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

    final dataSource = AuthenticationSourceServiceRoble(client: mockClient);
    final repository = AuthRepository(dataSource);

    authController = AuthenticationController(repository);
    TestHelper.injectMock<AuthenticationController>(authController);
  });

  Widget createWidget() => const GetMaterialApp(home: LoginPage());

  group('Pruebas de Integración - Flujo de Autenticación', () {
    testWidgets("Login exitoso: demostración lenta para el profesor", (
      tester,
    ) async {
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'accessToken': 'token_seguro_abc',
            'refreshToken': 'refresh_seguro_abc',
            'user': {'role': 'profesor', 'name': 'Test User'},
          }),
          201,
        ),
      );

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode([
            {
              'id': '1',
              'name': 'Test User',
              'email': 'test@correo.com',
              'role': 'profesor',
            },
          ]),
          200,
        ),
      );

      when(
        mockPrefs.getString('email'),
      ).thenAnswer((_) async => 'test@correo.com');
      when(
        mockPrefs.getString('token'),
      ).thenAnswer((_) async => 'token_seguro_abc');
      when(mockPrefs.getString('name')).thenAnswer((_) async => 'Test User');
      when(mockPrefs.getString('rol')).thenAnswer((_) async => 'profesor');
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key("loginEmailField")),
        "test@correo.com",
      );
      await tester.enterText(
        find.byKey(const Key("loginPasswordField")),
        "123456",
      );
      await tester.pumpAndSettle();
      await slowDown();

      await tester.tap(find.byKey(const Key("loginButton")));

      await tester.pump();

      int retry = 0;
      while (authController.logged.value == false && retry < 10) {
        await tester.pump(const Duration(milliseconds: 500));
        retry++;
      }

      await tester.pumpAndSettle();
      await slowDown(2);

      expect(
        authController.logged.value,
        true,
        reason: "El controlador no cambió a true tras el login",
      );
      expect(authController.isTeacher.value, true);
      expect(authController.userName.value, 'Test User');
    });

    testWidgets("Login fallido: no debe autenticar ante error 401", (
      tester,
    ) async {
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'message': 'Credenciales incorrectas'}),
          401,
        ),
      );

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();
      await slowDown(2);

      await tester.enterText(
        find.byKey(const Key("loginEmailField")),
        "error@correo.com",
      );
      await tester.pumpAndSettle();
      await slowDown();

      await tester.enterText(
        find.byKey(const Key("loginPasswordField")),
        "wrongpass",
      );
      await tester.pumpAndSettle();
      await slowDown();

      await tester.tap(find.byKey(const Key("loginButton")));

      await tester.pump();
      await slowDown(2);

      expect(authController.logged.value, false);

      await tester.pumpAndSettle(const Duration(seconds: 1));
    });
  });
}
