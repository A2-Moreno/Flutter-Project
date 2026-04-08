import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:app/features/auth/ui/pages/login_page.dart';
import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:app/features/auth/data/repositories/auth_repository.dart';
import 'package:app/features/auth/data/datasources/remote/authentication_source_service_roble.dart';
import 'package:app/core/i_local_preferences.dart';

class FakeHttpClient extends Fake implements http.Client {
  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    if (url.path.contains('/login') &&
        body.toString().contains('test@correo.com')) {
      return http.Response(
        jsonEncode({
          'accessToken': 'token_ok',
          'refreshToken': 'refresh_ok',
          'user': {
            'id': '1',
            'email': 'test@correo.com',
            'role': 'profesor',
            'name': 'Usuario Test',
          },
        }),
        201,
      );
    }
    return http.Response(jsonEncode({'message': 'Unauthorized'}), 401);
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    if (url.path.contains('/database/')) {
      return http.Response(
        jsonEncode([
          {
            'id': '1',
            'email': 'test@correo.com',
            'name': 'Usuario Test',
            'role': 'profesor',
          },
        ]),
        200,
      );
    }
    return http.Response('Not Found', 404);
  }
}

class FakePreferences extends Fake implements ILocalPreferences {
  @override
  Future<bool> setString(String key, String value) async => true;

  @override
  Future<String?> getString(String key) async {
    if (key == 'token') return "token_ok";
    if (key == 'email') return "test@correo.com";
    if (key == 'userId') return "1";
    if (key == 'rol') return "profesor";
    if (key == 'name') return "Usuario Test";
    return null;
  }
}

void main() {
  late AuthenticationController authController;
  setUpAll(() async {
    await dotenv.load(fileName: '.env');
    dotenv.env['EXPO_PUBLIC_ROBLE_PROJECT_ID'] = 'prueba_202';
  });

  setUp(() {
    Get.testMode = true;
    Get.reset();

    final fakeClient = FakeHttpClient();
    final fakePrefs = FakePreferences();

    Get.put<ILocalPreferences>(fakePrefs);

    // Data source real (pero con cliente fake)
    final dataSource = AuthenticationSourceServiceRoble(client: fakeClient);

    // Repo real
    final repository = AuthRepository(dataSource);

    // Controller real (esto es clave en integración)
    authController = AuthenticationController(repository);

    Get.put<AuthenticationController>(authController);
  });

  Widget createWidget() {
    return const GetMaterialApp(home: LoginPage());
  }

  testWidgets("Login exitoso", (tester) async {
    await tester.pumpWidget(createWidget());

    await tester.enterText(
      find.byKey(const Key("loginEmailField")),
      "test@correo.com",
    );

    await tester.enterText(
      find.byKey(const Key("loginPasswordField")),
      "123456",
    );

    await tester.tap(find.byKey(const Key("loginButton")));
    await tester.pump(Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(authController.logged.value, true);
  });

  testWidgets("Login fallido", (tester) async {
    await tester.pumpWidget(createWidget());

    await tester.enterText(
      find.byKey(const Key("loginEmailField")),
      "wrong@test.com",
    );

    await tester.enterText(
      find.byKey(const Key("loginPasswordField")),
      "badpass",
    );

    await tester.tap(find.byKey(const Key("loginButton")));

    await tester.pump();

    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(authController.logged.value, false);
  });
}
