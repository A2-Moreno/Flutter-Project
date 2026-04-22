import 'i_course_create_source.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../teacher/domain/models/course_model.dart';
import '../../../../core/i_local_preferences.dart';
import 'package:get/get.dart';
import 'dart:convert';

class CreateCourseRemoteDataSource implements ICourseCreateRemoteDataSource {
  final http.Client httpClient;

  CreateCourseRemoteDataSource({http.Client? client})
    : httpClient = client ?? http.Client();

  final contract = dotenv.get(
    'EXPO_PUBLIC_ROBLE_PROJECT_ID',
    fallback: "NO_ENV",
  );

  final String baseUrl = 'roble-api.openlab.uninorte.edu.co';

  @override
  Future<void> createCourse(Course course) async {
    final ILocalPreferences prefs = Get.find();
    final token = await prefs.getString('token');
    final userId = await prefs.getString('userId');

    final uri = Uri.https(baseUrl, '/database/$contract/insert');
    if (userId == null) {
      throw Exception("UserId is null");
    }

    final body = jsonEncode({
      "tableName": "course",
      "records": [
        {
          "name": course.name,
          "nrc": course.nrc,
          "profesor_id": userId,
        },
      ],
    });

    final response = await httpClient.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    if (response.statusCode != 201) {
      throw Exception("Error creating course: ${response.body}");
    }
  }
}
