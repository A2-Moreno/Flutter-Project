import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/features/auth/ui/pages/verification_page.dart';
import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';

class TestAuthController extends GetxController
    implements AuthenticationController {
  @override
  var userEmail = ''.obs;

  @override
  var userPassword = ''.obs;

  @override
  var userName = ''.obs;

  bool verifyCalled = false;
  String? codePassed;

  @override
  Future<void> verifyAccount(
    String email,
    String code,
    String password,
    String name,
  ) async {
    verifyCalled = true;
    codePassed = code;
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

  testWidgets('Renderiza VerificationPage correctamente', (tester) async {
    controller.userEmail.value = "test@mail.com";

    await tester.pumpWidget(const GetMaterialApp(home: VerificationPage()));

    expect(find.text("Verificación"), findsOneWidget);
    expect(find.textContaining("test@mail.com"), findsOneWidget);
    expect(find.text("Verificar código"), findsOneWidget);
  });

  testWidgets('Muestra errores si no escribe código', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: VerificationPage()));

    await tester.tap(find.text("Verificar código"));
    await tester.pump();

    expect(find.text("Ingresa el código de verificación"), findsOneWidget);
  });

  testWidgets('Muestra errores si el código no tiene 6 dígitos', (
    tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: VerificationPage()));

    await tester.enterText(
      find.byKey(const Key("verificationCodeField")),
      "12345",
    );
    await tester.tap(find.text("Verificar código"));
    await tester.pump();

    expect(find.text("El código debe tener 6 dígitos"), findsOneWidget);
  });

  testWidgets('Llama verifyAccount cuando datos son correctos', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: VerificationPage()));

    await tester.enterText(
      find.byKey(const Key("verificationCodeField")),
      "123456",
    );
    await tester.tap(find.text("Verificar código"));
    await tester.pump();

    expect(controller.verifyCalled, true);
    expect(controller.codePassed, "123456");
  });
}
