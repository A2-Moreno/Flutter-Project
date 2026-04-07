import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:app/features/auth/ui/pages/login_page.dart';

class TestAuthController extends GetxController
    implements AuthenticationController {
  @override
  var logged = false.obs;

  @override
  var signingUp = false.obs;

  bool loginWasCalled = false;
  String? emailPassed;
  String? passwordPassed;

  @override
  Future<bool> login(email, password) async {
    loginWasCalled = true;
    emailPassed = email;
    passwordPassed = password;
    return true;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late TestAuthController controller;

  setUp(() {
    Get.testMode = true;
    controller = TestAuthController();
    Get.put<AuthenticationController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Renderiza correctamente', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    expect(find.text("Bienvenido"), findsOneWidget);
    expect(find.byKey(const Key("loginEmailField")), findsOneWidget);
    expect(find.byKey(const Key("loginPasswordField")), findsOneWidget);
    expect(find.byKey(const Key("loginButton")), findsOneWidget);
  });

  testWidgets('Muestra error si campos están vacíos', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    await tester.tap(find.byKey(const Key("loginButton")));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text("Ingresa tu correo"), findsOneWidget);
    expect(find.text("Ingresa tu contraseña"), findsOneWidget);
  });

  testWidgets('Muestra error si email es inválido', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    await tester.enterText(
      find.byKey(const Key("loginEmailField")),
      "correo_invalido",
    );

    await tester.enterText(
      find.byKey(const Key("loginPasswordField")),
      "123456",
    );

    await tester.tap(find.byKey(const Key("loginButton")));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text("Correo inválido"), findsOneWidget);
  });

  testWidgets('Permite escribir en los campos', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    await tester.enterText(
      find.byKey(const Key("loginEmailField")),
      "test@mail.com",
    );

    await tester.enterText(
      find.byKey(const Key("loginPasswordField")),
      "123456",
    );

    expect(find.text("test@mail.com"), findsOneWidget);
    expect(find.text("123456"), findsOneWidget);
  });

  testWidgets('Llama login cuando datos son correctos', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    await tester.enterText(
      find.byKey(const Key("loginEmailField")),
      "ahuelvas@uninorte.edu.co",
    );

    await tester.enterText(
      find.byKey(const Key("loginPasswordField")),
      "Uninorte-123",
    );

    await tester.tap(find.byKey(const Key("loginButton")));
    await tester.pump();

    expect(controller.loginWasCalled, true);
    expect(controller.emailPassed, "ahuelvas@uninorte.edu.co");
    expect(controller.passwordPassed, "Uninorte-123");
  });

  testWidgets('Cambia a modo registro al presionar "Regístrate"', (
    tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));
    await tester.ensureVisible(find.text("Regístrate"));
    await tester.tap(find.text("Regístrate"));
    await tester.pump();

    expect(controller.signingUp.value, true);
  });
}
