import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/features/teacher/ui/pages/create_evaluation_page.dart';
import 'package:app/features/activity/ui/viewmodels/activity_controller.dart';
import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:app/features/course/domain/models/category_model.dart';

/// ----------------------
/// MOCKS
/// ----------------------

class MockActivityController extends GetxController
    implements ActivityController {
  var called = false;

  @override
  var name = ''.obs;

  @override
  var categoryId = ''.obs;

  @override
  Rxn<DateTime> startDate = Rxn<DateTime>();

  @override
  Rxn<DateTime> endDate = Rxn<DateTime>();

  @override
  var isPublic = false.obs;

  @override
  Future<void> createNewActivity(String courseId) async {
    called = true;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthController extends GetxController
    implements AuthenticationController {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// ----------------------
/// MAIN TEST
/// ----------------------

void main() {
  late MockActivityController activityController;

  final categories = [
    Category(id: "1", name: "Grupo A", groupCount: 2),
    Category(id: "2", name: "Grupo B", groupCount: 3),
  ];

  setUp(() {
    Get.testMode = true;

    activityController = MockActivityController();

    Get.put<ActivityController>(activityController);
    Get.put<AuthenticationController>(MockAuthController());
  });

  tearDown(() {
    Get.reset();
  });

  /// ----------------------
  /// RENDER
  /// ----------------------
  testWidgets('Renderiza correctamente', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: CreateEvaluationPage(courseId: "course1", categories: categories),
      ),
    );

    expect(find.text("Crear evaluación"), findsOneWidget);
    expect(find.text("Nombre de la evaluación"), findsOneWidget);
    expect(find.text("Categoría de grupos"), findsOneWidget);
  });

  /// ----------------------
  /// INPUT
  /// ----------------------
  testWidgets('Permite escribir en los campos', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: CreateEvaluationPage(courseId: "course1", categories: categories),
      ),
    );

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), "Parcial 1");
    await tester.enterText(fields.at(1), "01/01/2026");
    await tester.enterText(fields.at(2), "10:00");
    await tester.enterText(fields.at(3), "02/01/2026");
    await tester.enterText(fields.at(4), "12:00");

    expect(find.text("Parcial 1"), findsOneWidget);
    expect(find.text("10:00"), findsOneWidget);
  });

  /// ----------------------
  /// VALIDACIÓN VACÍOS
  /// ----------------------
  testWidgets('Muestra errores si campos están vacíos', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: CreateEvaluationPage(courseId: "course1", categories: categories),
      ),
    );

    await tester.ensureVisible(find.byKey(const Key("createEvaluationButton")));
    await tester.tap(find.byKey(const Key("createEvaluationButton")));
    await tester.pump();

    expect(find.text("El nombre es obligatorio"), findsOneWidget);
    expect(find.text("Selecciona una categoría"), findsOneWidget);
    expect(find.text("Fecha requerida"), findsWidgets);
    expect(find.text("Hora requerida"), findsWidgets);
  });

  /// ----------------------
  /// VALIDACIÓN FECHAS
  /// ----------------------
  testWidgets('Valida que cierre sea posterior al inicio', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: CreateEvaluationPage(courseId: "course1", categories: categories),
      ),
    );

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), "Parcial");

    // seleccionar categoría
    await tester.tap(find.byType(DropdownButtonFormField<Category>));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Grupo A").last);
    await tester.pumpAndSettle();

    // inicio > fin (ERROR)
    await tester.enterText(fields.at(1), "05/01/2026");
    await tester.enterText(fields.at(2), "10:00");
    await tester.enterText(fields.at(3), "04/01/2026");
    await tester.enterText(fields.at(4), "09:00");

    await tester.ensureVisible(find.byKey(const Key("createEvaluationButton")));
    await tester.tap(find.byKey(const Key("createEvaluationButton")));
    await tester.pump();

    expect(find.text("El cierre debe ser posterior al inicio"), findsOneWidget);
  });

  /// ----------------------
  /// FLUJO EXITOSO
  /// ----------------------
  testWidgets('Crea evaluación correctamente', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: CreateEvaluationPage(courseId: "course1", categories: categories),
      ),
    );

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), "Parcial Final");

    // categoría
    await tester.tap(find.byType(DropdownButtonFormField<Category>));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Grupo A").last);
    await tester.pumpAndSettle();

    // fechas válidas
    await tester.enterText(fields.at(1), "01/01/2026");
    await tester.enterText(fields.at(2), "10:00");
    await tester.enterText(fields.at(3), "02/01/2026");
    await tester.enterText(fields.at(4), "12:00");

    await tester.ensureVisible(find.byKey(const Key("createEvaluationButton")));
    await tester.tap(find.byKey(const Key("createEvaluationButton")));
    await tester.pump();

    expect(activityController.called, true);
  });
}
