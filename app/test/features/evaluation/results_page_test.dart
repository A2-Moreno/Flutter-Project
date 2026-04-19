import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/features/activity/domain/models/activity_model.dart';
import 'package:app/features/evaluation/ui/pages/results_page.dart';
import 'package:app/features/evaluation/ui/viewmodels/results_controller.dart';

class MockResultsController extends GetxController implements ResultsController {
  @override
  final isLoading = false.obs;

  @override
  final error = ''.obs;

  @override
  final mySummary = Rxn<Map<String, dynamic>>();

  @override
  final publicResults = <Map<String, dynamic>>[].obs;

  @override
  final globalAverage = 0.0.obs;

  Activity? builtActivity;

  @override
  Future<void> buildResults(Activity activity) async {
    builtActivity = activity;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockResultsController mockResultsController;

  final publicActivity = Activity(
    id: 'activity_1',
    name: 'Evaluación Final',
    courseId: 'course_1',
    categoryId: 'category_1',
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 1)),
    isPublic: true,
  );

  final privateActivity = Activity(
    id: 'activity_2',
    name: 'Evaluación Privada',
    courseId: 'course_1',
    categoryId: 'category_1',
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 1)),
    isPublic: false,
  );

  Widget buildTestableWidget(Activity activity) {
    return GetMaterialApp(
      home: ResultsPage(activity: activity),
    );
  }

  setUp(() {
    Get.testMode = true;
    Get.reset();

    mockResultsController = MockResultsController();
    Get.put<ResultsController>(mockResultsController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('debe ejecutar buildResults al abrir la pantalla',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(publicActivity));
    await tester.pump();

    expect(mockResultsController.builtActivity, publicActivity);
  });

  testWidgets('debe mostrar indicador de carga cuando isLoading es true',
      (WidgetTester tester) async {
    mockResultsController.isLoading.value = true;

    await tester.pumpWidget(buildTestableWidget(publicActivity));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('debe mostrar mensaje de error cuando error tiene contenido',
      (WidgetTester tester) async {
    mockResultsController.error.value = 'Error al cargar resultados';

    await tester.pumpWidget(buildTestableWidget(publicActivity));
    await tester.pump();

    expect(find.text('Error al cargar resultados'), findsOneWidget);
  });

  testWidgets('debe mostrar mensaje cuando no hay resultados disponibles',
      (WidgetTester tester) async {
    mockResultsController.mySummary.value = {
      'name': 'Tu resultado',
      'average': '0.0',
      'criteria': <Map<String, String>>[],
    };
    mockResultsController.publicResults.clear();

    await tester.pumpWidget(buildTestableWidget(publicActivity));
    await tester.pump();

    expect(find.text('Aún no hay resultados disponibles'), findsOneWidget);
  });

  testWidgets('debe mostrar solo tu resultado cuando existe mySummary',
      (WidgetTester tester) async {
    mockResultsController.mySummary.value = {
      'name': 'Tu resultado',
      'average': '4.3',
      'criteria': <Map<String, String>>[
        {'label': 'Puntualidad', 'score': '4.5'},
        {'label': 'Aportes', 'score': '4.0'},
      ],
    };
    mockResultsController.publicResults.clear();

    await tester.pumpWidget(buildTestableWidget(privateActivity));
    await tester.pump();

    expect(find.text('Resultados'), findsOneWidget);
    expect(find.text('Tu resultado'), findsOneWidget);
    expect(find.text('4.3'), findsOneWidget);
    expect(find.text('Puntualidad'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('Aportes'), findsOneWidget);
    expect(find.text('4.0'), findsOneWidget);
  });

  testWidgets('debe mostrar resultados publicos cuando la actividad es publica',
      (WidgetTester tester) async {
    mockResultsController.mySummary.value = {
      'name': 'Tu resultado',
      'average': '4.3',
      'criteria': <Map<String, String>>[
        {'label': 'Puntualidad', 'score': '4.5'},
      ],
    };

    mockResultsController.publicResults.assignAll([
      {
        'name': 'Camila',
        'average': '4.7',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '5.0'},
          {'label': 'Aportes', 'score': '4.4'},
        ],
      },
      {
        'name': 'Juan',
        'average': '3.9',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '4.0'},
          {'label': 'Aportes', 'score': '3.8'},
        ],
      },
    ]);

    await tester.pumpWidget(buildTestableWidget(publicActivity));
    await tester.pump();

    expect(find.text('Tu resultado'), findsOneWidget);
    expect(find.text('4.3'), findsOneWidget);

    expect(find.text('Camila'), findsOneWidget);
    expect(find.text('4.7'), findsOneWidget);
    expect(find.text('5.0'), findsOneWidget);
    expect(find.text('4.4'), findsOneWidget);

    expect(find.text('Juan'), findsOneWidget);
    expect(find.text('3.9'), findsOneWidget);
    expect(find.text('4.0'), findsOneWidget);
    expect(find.text('3.8'), findsOneWidget);
  });

  testWidgets(
      'no debe mostrar resultados publicos cuando la actividad no es publica',
      (WidgetTester tester) async {
    mockResultsController.mySummary.value = {
      'name': 'Tu resultado',
      'average': '4.3',
      'criteria': <Map<String, String>>[
        {'label': 'Puntualidad', 'score': '4.5'},
      ],
    };

    mockResultsController.publicResults.assignAll([
      {
        'name': 'Camila',
        'average': '4.7',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '5.0'},
        ],
      },
    ]);

    await tester.pumpWidget(buildTestableWidget(privateActivity));
    await tester.pump();

    expect(find.text('Tu resultado'), findsOneWidget);
    expect(find.text('4.3'), findsOneWidget);

    expect(find.text('Camila'), findsNothing);
    expect(find.text('4.7'), findsNothing);
    expect(find.text('5.0'), findsNothing);
  });

  testWidgets('debe renderizar una tabla por cada resultado visible',
      (WidgetTester tester) async {
    mockResultsController.mySummary.value = {
      'name': 'Tu resultado',
      'average': '4.3',
      'criteria': <Map<String, String>>[
        {'label': 'Puntualidad', 'score': '4.5'},
      ],
    };

    mockResultsController.publicResults.assignAll([
      {
        'name': 'Camila',
        'average': '4.7',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '5.0'},
        ],
      },
      {
        'name': 'Juan',
        'average': '3.9',
        'criteria': <Map<String, String>>[
          {'label': 'Puntualidad', 'score': '4.0'},
        ],
      },
    ]);

    await tester.pumpWidget(buildTestableWidget(publicActivity));
    await tester.pump();

    expect(find.byType(ResultTableCard), findsNWidgets(3));
  });
}