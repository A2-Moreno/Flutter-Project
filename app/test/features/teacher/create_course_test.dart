import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/features/teacher/ui/pages/create_course.dart';
import 'package:app/features/teacher/ui/viewmodels/create_courses_controller.dart';

class MockCreateController extends GetxController implements CreateController {
  bool called = false;
  String? name;
  String? nrc;

  @override
  Future<void> createCourse(String name, String nrc) async {
    called = true;
    this.name = name;
    this.nrc = nrc;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockCreateController controller;

  setUp(() {
    Get.testMode = true;
    controller = MockCreateController();
    Get.put<CreateController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Renderiza correctamente la pantalla', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: CreateCourseScreen()));

    expect(find.text("Crear curso"), findsWidgets);
    expect(find.text("Nombre del curso"), findsOneWidget);
    expect(find.text("NRC"), findsOneWidget);
  });

  testWidgets('Permite escribir en los campos', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: CreateCourseScreen()));

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), "Matemáticas");
    await tester.enterText(fields.at(1), "1234");

    expect(find.text("Matemáticas"), findsOneWidget);
    expect(find.text("1234"), findsOneWidget);
  });

  testWidgets('Llama createCourse cuando el formulario es válido', (
    tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: CreateCourseScreen()));

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), "Física");
    await tester.enterText(fields.at(1), "9999");

    await tester.tap(find.byKey(const Key("createButton")));
    await tester.pump();

    expect(controller.called, true);
    expect(controller.name, "Física");
    expect(controller.nrc, "9999");
  });

  testWidgets('No envía si el nombre está vacío', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: CreateCourseScreen()));

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), ""); // vacío
    await tester.enterText(fields.at(1), "1234");

    await tester.tap(find.byKey(const Key("createButton")));
    await tester.pump();

    expect(find.text("El nombre es obligatorio"), findsOneWidget);
    expect(controller.called, false);
  });

  testWidgets('No envía si el NRC está vacío', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: CreateCourseScreen()));

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), "Matemáticas");
    await tester.enterText(fields.at(1), "");

    await tester.tap(find.byKey(const Key("createButton")));
    await tester.pump();

    expect(find.text("El NRC es obligatorio"), findsOneWidget);
    expect(controller.called, false);
  });

  testWidgets('No envía si el NRC no tiene 4 dígitos', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: CreateCourseScreen()));

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), "Matemáticas");
    await tester.enterText(fields.at(1), "12"); // inválido

    await tester.tap(find.byKey(const Key("createButton")));
    await tester.pump();

    expect(find.text("El NRC debe ser un número de 4 dígitos"), findsOneWidget);
    expect(controller.called, false);
  });
}
