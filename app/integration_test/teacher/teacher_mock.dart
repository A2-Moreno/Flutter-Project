import 'dart:convert';
import 'package:app/features/activity/domain/models/activity_model.dart';
import 'package:app/features/activity/domain/usecases/get_activities_by_course_usecase.dart';
import 'package:app/features/course/domain/models/category_model.dart';
import 'package:app/features/course/domain/use_cases/get_categories_usecase.dart';
import 'package:app/features/course/ui/viewmodels/course_controller.dart';
import 'package:app/features/evaluation/domain/models/evaluation_result_model.dart';
import 'package:app/features/evaluation/domain/usecases/get_evaluation_results_usecase.dart';
import 'package:app/features/evaluation/ui/viewmodels/teacher_results_controller.dart';
import 'package:app/features/general_results/domain/models/global_average_model.dart';
import 'package:app/features/general_results/domain/models/groups_global_average_model.dart';
import 'package:app/features/general_results/domain/use_cases/get_global_average_usecase.dart';
import 'package:app/features/general_results/domain/use_cases/get_groups_global_average.dart';
import 'package:app/features/general_results/ui/viewmodels/general_controller.dart';
import 'package:app/features/groups/domain/models/group_member_model.dart';
import 'package:app/features/groups/domain/models/group_model.dart';
import 'package:app/features/groups/domain/use_cases/get_all_my_groups.dart';
import 'package:app/features/groups/domain/use_cases/get_evaluations_by_activity_usecase.dart';
import 'package:app/features/groups/domain/use_cases/get_groups_by_category_usecase.dart';
import 'package:app/features/groups/domain/use_cases/get_my_group_usecase.dart';
import 'package:app/features/groups/ui/viewmodels/group_controller.dart';
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

  void setupTeacherMocks(
    MockClient client,
    MockILocalPreferences prefs,
    courseId,
  ) {
    final mockGetCategories = MockGetCategories();
    final mockGetActivities = MockGetActivitiesByCourse();
    final mockImportGroups = MockImportGroups();
    final mockImportGroupsToDb = MockImportGroupsToDb();
    final mockGetCourseAvg = MockGetCourseGlobalAverages();
    final mockGetGroupsAvg = MockGetGroupsGlobalAverage();
    final mockGetGroups = MockGetGroupsByCategory();
    final mockGetMyGroup = MockGetMyGroup();
    final mockGetAllGroups = MockGetAllMyGroups();
    final mockGetGlobalAvg = MockGetGlobalAverage();
    final mockGetResults = MockGetEvaluationResults();

    final resultadosAna = [
      EvaluationResult(
        evaluatorId: "prof_1",
        evaluatorName: "Profesor Test",
        scoresByCriterion: {
          "puntualidad": [5.0, 4.0],
          "aportes": [4.5],
          "compromiso": [5.0, 4.0],
          "actitud": [4.5],
        },
      ),
    ];

    final listaDeGrupos = [
      Group(
        id: "g1",
        name: "Equipo de Desarrollo Alfa",
        code: "ALFA-01",
        members: [
          GroupMember(userId: "u1", name: "Ana García", email: "ana@test.com"),
          GroupMember(userId: "u2", name: "Juan Pérez", email: "juan@test.com"),
        ],
      ),
      Group(
        id: "g2",
        name: "Equipo de Diseño Beta",
        code: "BETA-02",
        members: [
          GroupMember(
            userId: "u3",
            name: "Carlos Ruiz",
            email: "carlos@test.com",
          ),
        ],
      ),
    ];

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
      return http.Response(jsonEncode({'message': 'Success'}), 201);
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
        return http.Response(
          jsonEncode([
            {
              '_id': 'c1',
              'name': 'Criptografía Avanzada',
              'nrc': '2222',
              'profesor_id': '1',
            },
          ]),
          200,
        );
      } else {
        return http.Response(
          jsonEncode([
            {
              '_id': 'c1',
              'name': 'Criptografía Avanzada',
              'nrc': '2222',
              'profesor_id': '1',
            },
            {
              '_id': 'c2',
              'name': 'Curso de Robótica',
              'nrc': '4321',
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

    //GET actividades
    when(
      client.get(
        argThat(
          predicate<Uri>(
            (uri) =>
                uri.path.contains('/read') &&
                uri.queryParameters['tableName'] == 'activity',
          ),
        ),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((invocation) async {
      final Uri uri = invocation.positionalArguments[0];
      final String? courseId = uri.queryParameters['course_id'];

      if (courseId == 'c1') {
        return http.Response(
          jsonEncode([
            {
              "_id": "act_1",
              "start_date": "2026-01-01T00:00:00Z", // Fecha en el pasado
              "end_date": "2026-12-31T23:59:59Z", // Fecha en el futuro
            },
          ]),
          200,
        );
      }

      return http.Response(jsonEncode([]), 200);
    });

    //Mocks de SharedPreferences
    when(prefs.getString('userId')).thenAnswer((_) async => '1');
    when(prefs.getString('email')).thenAnswer((_) async => 'test@correo.com');
    when(prefs.getString('token')).thenAnswer((_) async => 'token_seguro_abc');
    when(prefs.getString('name')).thenAnswer((_) async => 'Test User');
    when(prefs.getString('rol')).thenAnswer((_) async => 'profesor');
    when(prefs.setString(any, any)).thenAnswer((_) async => true);

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
        Activity(
          id: "act_2",
          name: "Taller RSA",
          courseId: courseId,
          categoryId: "cat_1",
          startDate: DateTime.now(),
          endDate: DateTime.now().subtract(Duration(days: 1)),
          isPublic: true,
        ),
      ],
    );

    when(mockGetGroups.execute(any)).thenAnswer((_) async => listaDeGrupos);
    when(mockGetGlobalAvg.execute(any)).thenAnswer((_) async => 4.8);

    when(
      mockGetResults.execute(any, any),
    ).thenAnswer((_) async => resultadosAna);

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

    Get.put<GroupController>(
      GroupController(
        mockGetGroups,
        mockGetMyGroup,
        mockGetAllGroups,
        mockGetGlobalAvg,
      ),
      permanent: true,
    );

    Get.put<TeacherResultsController>(
      TeacherResultsController(mockGetResults),
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

class MockGetGroupsByCategory extends Mock implements GetGroupsByCategory {
  @override
  Future<List<Group>> execute(String? activityId) => super.noSuchMethod(
    Invocation.method(#execute, [activityId]),
    returnValue: Future.value(<Group>[]),
  );
}

class MockGetMyGroup extends Mock implements GetMyGroup {}

class MockGetAllMyGroups extends Mock implements GetAllMyGroups {}

class MockGetGlobalAverage extends Mock implements GetGlobalAverage {
  @override
  Future<double> execute(String? activityId) => super.noSuchMethod(
    Invocation.method(#execute, [activityId]),
    returnValue: Future.value(0.0),
  );
}

class MockGetEvaluationResults extends Mock implements GetEvaluationResults {
  @override
  Future<List<EvaluationResult>> execute(String? activityId, String? userId) =>
      super.noSuchMethod(
        Invocation.method(#execute, [activityId, userId]),
        returnValue: Future.value(<EvaluationResult>[]),
      );
}
