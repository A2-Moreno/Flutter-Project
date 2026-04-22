import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/features/home/ui/pages/home_page.dart';
import 'package:app/features/home/ui/viewmodels/home_controller.dart';
import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:app/features/home/domain/repositories/i_course_repository.dart';

class FakeCourseRepository implements ICourseRepository {
  List<Map<String, dynamic>> fakeCourses = [];

  @override
  Future<List<Map<String, dynamic>>> getCoursesByUserEmail() async {
    await Future.delayed(const Duration(milliseconds: 10)); 
    return fakeCourses;
  }

  @override
  Future<void> clearCache() async {
    
  }
  
}

class MockAuthController extends GetxController
    implements AuthenticationController {
  @override
  var userName = ''.obs;

  @override
  var isTeacher = false.obs;

  @override
  var logged = false.obs;

  bool logoutCalled = false;

  @override
  Future<void> logOut() async {
    logoutCalled = true;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestHomeController extends HomeController {
  TestHomeController(super.repository);

  bool crearCursoTapped = false;
  bool cursoTapped = false;

  @override
  void abrirCrearCurso() {
    crearCursoTapped = true;
  }

  @override
  void abrirCurso(Map<String, dynamic> course) {
    cursoTapped = true;
  }
}

void main() {
  late FakeCourseRepository repository;
  late MockAuthController authController;
  late TestHomeController homeController;

  setUp(() {
    Get.testMode = true;

    repository = FakeCourseRepository();
    authController = MockAuthController();
    homeController = TestHomeController(repository);

    Get.put<AuthenticationController>(authController);
    Get.put<HomeController>(homeController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Render básico sin cursos', (tester) async {
    authController.userName.value = "Ale";
    authController.logged.value = true;

    repository.fakeCourses = [];

    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining("Hola, Ale"), findsOneWidget);
    expect(find.text("No tienes cursos inscritos"), findsOneWidget);
  });

  testWidgets('Muestra cursos correctamente', (tester) async {
    authController.userName.value = "Ale";
    authController.logged.value = true;

    repository.fakeCourses = [
      {'name': 'Matemáticas', 'activities': 5},
      {'name': 'Historia', 'activities': 3},
    ];

    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text("Matemáticas"), findsOneWidget);
    expect(find.text("Historia"), findsOneWidget);
    expect(find.text("5 actividades"), findsOneWidget);
  });

  testWidgets('Muestra botón crear curso si es profesor', (tester) async {
    authController.isTeacher.value = true;
    authController.logged.value = true;

    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text("+ Crear curso"), findsOneWidget);
  });

  testWidgets('No muestra botón crear curso si no es profesor', (tester) async {
    authController.isTeacher.value = false;
    authController.logged.value = true;

    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text("+ Crear curso"), findsNothing);
  });

  testWidgets('Llama logout al presionar botón', (tester) async {
    authController.logged.value = true;

    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.exit_to_app));
    await tester.pump();

    expect(authController.logoutCalled, true);
  });

  testWidgets('Botón crear curso responde al tap', (tester) async {
    authController.isTeacher.value = true;
    authController.logged.value = true;

    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text("+ Crear curso"));
    await tester.pump();

    expect(homeController.crearCursoTapped, true);
  });

  testWidgets('Botón crear curso responde al tap', (tester) async {
    authController.isTeacher.value = true;
    authController.logged.value = true;

    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text("+ Crear curso"));
    await tester.pump();

    expect(homeController.crearCursoTapped, true);
  });
}
