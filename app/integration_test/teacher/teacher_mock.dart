import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:app/core/i_local_preferences.dart';
import '../../test/helpers/test_helper.mocks.dart';

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
              'activities': '3',
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
              'activities': '3',
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

    //Mocks de SharedPreferences
    when(prefs.getString('userId')).thenAnswer((_) async => '1');
    when(prefs.getString('email')).thenAnswer((_) async => 'test@correo.com');
    when(prefs.getString('token')).thenAnswer((_) async => 'token_seguro_abc');
    when(prefs.getString('name')).thenAnswer((_) async => 'Test User');
    when(prefs.getString('rol')).thenAnswer((_) async => 'profesor');
    when(prefs.setString(any, any)).thenAnswer((_) async => true);
  }
}
