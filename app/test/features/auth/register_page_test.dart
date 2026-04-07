import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/features/auth/ui/pages/register_page.dart';
import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';

class TestAuthController extends GetxController
    implements AuthenticationController {
  @override
  var logged = false.obs;

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

  bool signUpWasCalled = false;

  String? namePassed;
  String? emailPassed;
  String? passwordPassed;

  @override
  Future<bool> signUp(name, email, password, bool direct) async {
    signUpWasCalled = true;
    namePassed = name;
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
    await tester.pumpWidget(const GetMaterialApp(home: RegisterPage()));

    expect(find.text("Registro"), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text("Registrarse"), findsOneWidget);
  });

  testWidgets('Muestra errores si campos están vacíos', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: RegisterPage()));

    await tester.ensureVisible(find.text("Registrarse"));
    await tester.tap(find.text("Registrarse"));
    await tester.pump();

    expect(find.text("Ingresa tu nombre"), findsOneWidget);
    expect(find.text("Ingresa tu correo"), findsOneWidget);
    expect(find.text("Ingresa tu contraseña"), findsOneWidget);
    expect(find.text("Confirma tu contraseña"), findsOneWidget);
  });

  testWidgets('Muestra error si email es inválido', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: RegisterPage()));

    await tester.enterText(find.byType(TextFormField).at(0), "Juan");
    await tester.enterText(find.byType(TextFormField).at(1), "correo_mal");
    await tester.enterText(find.byType(TextFormField).at(2), "Password1!");
    await tester.enterText(find.byType(TextFormField).at(3), "Password1!");

    await tester.ensureVisible(find.text("Registrarse"));
    await tester.tap(find.text("Registrarse"));
    await tester.pump();

    expect(find.text("Correo inválido"), findsOneWidget);
  });

  testWidgets('Muestra error si contraseña no cumple reglas', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: RegisterPage()));

    await tester.enterText(find.byType(TextFormField).at(0), "Juan");
    await tester.enterText(find.byType(TextFormField).at(1), "juan@mail.com");
    await tester.enterText(find.byType(TextFormField).at(2), "123");
    await tester.enterText(find.byType(TextFormField).at(3), "123");

    await tester.ensureVisible(find.text("Registrarse"));
    await tester.tap(find.text("Registrarse"));
    await tester.pump();

    expect(find.textContaining("Debe tener"), findsOneWidget);
  });

  testWidgets('Muestra error si contraseñas no coinciden', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: RegisterPage()));

    await tester.enterText(find.byType(TextFormField).at(0), "Juan");
    await tester.enterText(find.byType(TextFormField).at(1), "juan@mail.com");
    await tester.enterText(find.byType(TextFormField).at(2), "Password1!");
    await tester.enterText(find.byType(TextFormField).at(3), "Otra123!");

    await tester.ensureVisible(find.text("Registrarse"));
    await tester.tap(find.text("Registrarse"));
    await tester.pump();

    expect(find.text("Las contraseñas no coinciden"), findsOneWidget);
  });

  testWidgets('Llama signUp cuando datos son correctos', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: RegisterPage()));

    await tester.enterText(find.byType(TextFormField).at(0), "Juan");
    await tester.enterText(find.byType(TextFormField).at(1), "juan@mail.com");
    await tester.enterText(find.byType(TextFormField).at(2), "Password1!");
    await tester.enterText(find.byType(TextFormField).at(3), "Password1!");

    await tester.ensureVisible(find.text("Registrarse"));
    await tester.tap(find.text("Registrarse"));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(controller.signUpWasCalled, true);
    expect(controller.namePassed, "Juan");
    expect(controller.emailPassed, "juan@mail.com");
  });

  testWidgets('Cambia a login al presionar botón', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: RegisterPage()));

    await tester.ensureVisible(find.text("¿Ya tienes una cuenta?"));
    await tester.tap(find.text("¿Ya tienes una cuenta?"));
    await tester.pump();

    expect(controller.signingUp.value, false);
  });
}
