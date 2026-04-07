import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../core/i_local_preferences.dart';
import '../../domain/models/activity_model.dart';
import 'i_activity_remote_datasource.dart';

class ActivityRemoteDataSourceRoble implements IActivityRemoteDataSource {

  final http.Client httpClient;

  final contract = dotenv.get(
    'EXPO_PUBLIC_ROBLE_PROJECT_ID',
    fallback: "NO_ENV",
  );

  final String baseUrl = 'roble-api.openlab.uninorte.edu.co';

  ActivityRemoteDataSourceRoble({http.Client? client})
      : httpClient = client ?? http.Client();

  Future<String> _getToken() async {
    final prefs = Get.find<ILocalPreferences>();
    final token = await prefs.getString('token');
    if (token == null) throw Exception("No token");
    return token;
  }

  @override
  Future<void> createActivity(Activity activity) async {
    final token = await _getToken();

    final uri = Uri.https(baseUrl, '/database/$contract/insert');

    final body = jsonEncode({
      "tableName": "activity",
      "records": [
        {
          "_id": activity.id,
          "name": activity.name,
          "course_id": activity.courseId,
          "category_id": activity.categoryId,
          "start_date": activity.startDate.toIso8601String(),
          "end_date": activity.endDate.toIso8601String(),
          "is_public": activity.isPublic,
        }
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
      throw Exception("Error creando actividad: ${response.body}");
    }
  }

  @override
  Future<List<Activity>> getActivitiesByCategory(String categoryId) async {
    final token = await _getToken();

    final uri = Uri.https(
      baseUrl,
      '/database/$contract/read',
      {
        "tableName": "activity",
        "category_id": categoryId,
      },
    );

    final response = await httpClient.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Error obteniendo actividades");
    }

    final List data = jsonDecode(response.body);

    return data.map((json) => _mapToActivity(json)).toList();
  }

  @override
  Future<List<Activity>> getActivitiesByCourse(String courseId) async {
    final token = await _getToken();

    final uri = Uri.https(
      baseUrl,
      '/database/$contract/read',
      {
        "tableName": "activity",
        "course_id": courseId,
      },
    );

    final response = await httpClient.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Error obteniendo actividades");
    }

    final List data = jsonDecode(response.body);

    return data.map((json) => _mapToActivity(json)).toList();
  }

  Activity _mapToActivity(Map<String, dynamic> json) {
    return Activity(
      id: json["_id"],
      name: json["name"],
      courseId: json["course_id"],
      categoryId: json["category_id"],
      startDate: DateTime.parse(json["start_date"]),
      endDate: DateTime.parse(json["end_date"]),
      isPublic: json["is_public"],
    );
  }
}