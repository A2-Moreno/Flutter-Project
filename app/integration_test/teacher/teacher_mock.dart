import 'dart:convert';
import 'package:app/features/activity/domain/models/activity_model.dart';
import 'package:app/features/activity/domain/usecases/get_activities_by_course_usecase.dart';
import 'package:app/features/course/domain/models/category_model.dart';
import 'package:app/features/course/domain/use_cases/get_categories_usecase.dart';
import 'package:app/features/course/ui/viewmodels/course_controller.dart';
import 'package:app/features/general_results/domain/models/global_average_model.dart';
import 'package:app/features/general_results/domain/models/groups_global_average_model.dart';
import 'package:app/features/general_results/domain/use_cases/get_global_average_usecase.dart';
import 'package:app/features/general_results/domain/use_cases/get_groups_global_average.dart';
import 'package:app/features/general_results/ui/viewmodels/general_controller.dart';
import 'package:app/features/import_csv/domain/use_cases/import_groups.dart';
import 'package:app/features/save_to_db/domain/use_cases/import_groupsdb.dart';
import 'package:app/features/save_to_db/ui/viewmodels/savedb_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:app/core/i_local_preferences.dart';
import '../../test/helpers/test_helper.mocks.dart';
import 'package:get/get.dart';

class TeacherMock {
  bool newCourseCreated = false;

  void setupTeacherMocks(MockClient client, MockILocalPreferences prefs) {
    //Mock POST autenticación
    when(
      client.post(any, headers: anyNamed('headers'), body: anyNamed('body')),
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

    //Mock GET usuario
    when(
      client.get(
        argThat(
          predicate<Uri>((uri) => uri.toString().contains('tableName=Users')),
        ),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => http.Response(
        jsonEncode([
          {
            'userId': '1',
            'name': 'Test User',
            'role': 'profesor',
            'email': 'test@correo.com',
          },
        ]),
        200,
      ),
    );

    //Mock POST curso
    when(
      client.post(
        argThat(
          predicate<Uri>((uri) => uri.toString().contains('/insert')),
        ), // Cambiado a /insert
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async {
      newCourseCreated = true;
      return http.Response(
        jsonEncode({'message': 'Success'}),
        201,
      ); // Retorna 201 como espera tu source
    });

    // Mock GET cursos
    when(
      client.get(
        argThat(
          predicate<Uri>((uri) => uri.toString().contains('tableName=course')),
        ),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async {
      if (!newCourseCreated) {
        // Primera respuesta: Solo 1 curso
        return http.Response(
          jsonEncode([
            {
              'id': 'c1',
              'name': 'Criptografía Avanzada',
              'activities': '2',
              'profesor_id': '1',
            },
          ]),
          200,
        );
      } else {
        // Respuesta tras crear: 2 cursos
        return http.Response(
          jsonEncode([
            {
              'id': 'c1',
              'name': 'Criptografía Avanzada',
              'activities': '2',
              'profesor_id': '1',
            },
            {
              'id': 'c2',
              'name': 'Curso de Robótica',
              'activities': '0',
              'profesor_id': '1',
            },
          ]),
          200,
        );
      }
    });

    //Mock GET categorías
    when(
      client.get(
        argThat(
          predicate<Uri>(
            (uri) => uri.toString().contains('tableName=category'),
          ),
        ),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => http.Response(
        jsonEncode([
          {'_id': 'cat_1', 'name': 'Proyecto Final', 'course_id': 'c1'},
          {'_id': 'cat_2', 'name': 'Laboratorios', 'course_id': 'c1'},
        ]),
        200,
      ),
    );

    // Mock GET número de grupos
    when(
      client.get(
        argThat(
          predicate<Uri>((uri) => uri.toString().contains('tableName=groups')),
        ),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => http.Response(
        jsonEncode([
          {'id': 'g1'},
          {'id': 'g2'},
        ]),
        200,
      ),
    );

    //Mock GET evaluaciones
    when(
      client.get(
        argThat(
          predicate<Uri>(
            (uri) => uri.toString().contains('tableName=activities'),
          ),
        ),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => http.Response(
        jsonEncode([
          {
            '_id': 'act_1',
            'name': 'Entrega 1: Propuesta',
            'endDate': DateTime.now()
                .add(const Duration(days: 10))
                .toIso8601String(),
          },
          {
            '_id': 'act_2',
            'name': 'Examen Parcial',
            'endDate': DateTime.now()
                .subtract(const Duration(days: 1))
                .toIso8601String(),
          },
        ]),
        200,
      ),
    );

    //Mocks de SharedPreferences
    when(prefs.getString('userId')).thenAnswer((_) async => '1');
    when(prefs.getString('email')).thenAnswer((_) async => 'test@correo.com');
    when(prefs.getString('token')).thenAnswer((_) async => 'token_seguro_abc');
    when(prefs.getString('name')).thenAnswer((_) async => 'Test User');
    when(prefs.getString('rol')).thenAnswer((_) async => 'profesor');
    when(prefs.setString(any, any)).thenAnswer((_) async => true);
  }

  void injectCourseDependencies(String courseId) {
    Get.delete<CourseController>(force: true);
    Get.delete<CourseResultsController>(force: true);
    Get.delete<ImportGroupsController>(force: true);

    final mockGetCategories = MockGetCategories();
    final mockGetActivities = MockGetActivitiesByCourse();
    final mockImportGroups = MockImportGroups();
    final mockImportGroupsToDb = MockImportGroupsToDb();
    final mockGetCourseAvg = MockGetCourseGlobalAverages();
    final mockGetGroupsAvg = MockGetGroupsGlobalAverage();

    when(mockGetCategories.execute(courseId)).thenAnswer(
      (_) async => <Category>[
        Category(id: "cat_1", name: "Algoritmos", groupCount: 0),
      ],
    );

    when(mockGetActivities.execute(courseId)).thenAnswer(
      (_) async => <Activity>[
        Activity(
          id: "act_1",
          name: "Proyecto I+D",
          courseId: courseId,
          categoryId: "cat_1",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 1)),
          isPublic: true,
        ),
      ],
    );

    Get.put<ImportGroupsController>(
      ImportGroupsController(mockImportGroups, mockImportGroupsToDb),
      permanent: true,
    );

    Get.put<CourseController>(
      CourseController(mockGetCategories, mockGetActivities),
      permanent: true,
    );

    Get.put<CourseResultsController>(
      CourseResultsController(mockGetCourseAvg, mockGetGroupsAvg),
      permanent: true,
    );
  }
}

class MockGetCategories extends Mock implements GetCategories {
  @override
  Future<List<Category>> execute(String? courseId) => super.noSuchMethod(
    Invocation.method(#execute, [courseId]),
    // ESTO ES LA CLAVE: Evita el error de Null subtype
    returnValue: Future.value(<Category>[]),
  );
}

class MockGetActivitiesByCourse extends Mock implements GetActivitiesByCourse {
  @override
  Future<List<Activity>> execute(String? courseId) => super.noSuchMethod(
    Invocation.method(#execute, [courseId]),
    returnValue: Future.value(<Activity>[]),
  );
}

class MockImportGroups extends Mock implements ImportGroups {}

class MockImportGroupsToDb extends Mock implements ImportGroupsToDb {}

class MockGetCourseGlobalAverages extends Mock
    implements GetCourseGlobalAverages {
  @override
  Future<List<StudentGlobalAverage>> execute(String? courseId) =>
      super.noSuchMethod(
        Invocation.method(#execute, [courseId]),
        returnValue: Future.value(<StudentGlobalAverage>[]),
      );
}

class MockGetGroupsGlobalAverage extends Mock
    implements GetGroupsGlobalAverage {
  @override
  Future<List<GroupActivityAverage>> execute(String? courseId) =>
      super.noSuchMethod(
        Invocation.method(#execute, [courseId]),
        returnValue: Future.value(<GroupActivityAverage>[]),
      );
}
