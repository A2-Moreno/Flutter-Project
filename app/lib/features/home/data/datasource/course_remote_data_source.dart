import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loggy/loggy.dart';
import '../../../../../core/i_local_preferences.dart';
import 'i_course_source.dart';

class CourseRemoteDataSource implements ICourseRemoteDataSource {
  final http.Client httpClient;

  CourseRemoteDataSource({http.Client? client})
    : httpClient = client ?? http.Client();

  @override
  Future<List<Map<String, dynamic>>> getCoursesByUserEmail() async {
    final contract = dotenv.get(
      'EXPO_PUBLIC_ROBLE_PROJECT_ID',
      fallback: "NO_ENV",
    );

    final String baseUrl = 'roble-api.openlab.uninorte.edu.co';

    final ILocalPreferences prefs = Get.find();

    final token = await prefs.getString('token');
    final email = await prefs.getString('email');
    final rol = await prefs.getString('rol');

    if (email == null || token == null || rol == null) {
      throw Exception("No email or token or rol");
    }

    //  Buscar usuario por email
    final userUri = Uri.https(baseUrl, '/database/$contract/read', {
      'tableName': 'Users',
      'email': email,
    });

    final userResponse = await httpClient.get(
      userUri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (userResponse.statusCode != 200) {
      throw Exception("Error getting user");
    }

    final List<dynamic> users = jsonDecode(userResponse.body);

    if (users.isEmpty) {
      logInfo("⚠️ Usuario no existe en DB");
      return [];
    }

    final user = users.first;

    if (!user.containsKey('userId')) {
      logInfo("⚠️ userId no encontrado");
      return [];
    }

    final userId = user['userId'];
    prefs.setString('userId', userId);

    //  Buscar cursos
    if (rol == 'profesor') {
      // 🔹 PROFESOR
      final courseUri = Uri.https(baseUrl, '/database/$contract/read', {
        'tableName': 'course',
        'profesor_id': userId.toString(),
      });

      final response = await httpClient.get(
        courseUri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception("Error getting courses");
      }

      final List<dynamic> courses = jsonDecode(response.body);
      return courses.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      //ESTUDIANTE

      final membersUri = Uri.https(baseUrl, '/database/$contract/read', {
        'tableName': 'course_members',
        'estudiante_id': userId.toString(),
      });
      final membersResponse = await httpClient.get(
        membersUri,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (membersResponse.statusCode != 200) {
        throw Exception("Error getting course memberships");
      }
      final List<dynamic> memberships = jsonDecode(membersResponse.body);
      if (memberships.isEmpty) {
        return [];
      }
      final courseIds = memberships
          .map((m) => m['course_id'].toString())
          .toList();
      List<Map<String, dynamic>> courses = [];
      for (var id in courseIds) {
        final uri = Uri.https(baseUrl, '/database/$contract/read', {
          'tableName': 'course',
          '_id': id,
        });
        final res = await httpClient.get(
          uri,
          headers: {'Authorization': 'Bearer $token'},
        );
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          if (data.isNotEmpty) {
            courses.add(Map<String, dynamic>.from(data.first));
          }
        }
      }
      return courses;
    }
  }
}
