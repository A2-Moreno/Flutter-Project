import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../core/i_local_preferences.dart';
import 'i_general_results_source_service_roble.dart';

class GeneralRemoteDataSource implements IGeneralRemoteDataSource {
  final http.Client httpClient;

  GeneralRemoteDataSource({http.Client? client})
      : httpClient = client ?? http.Client();

  final contract = dotenv.get(
    'EXPO_PUBLIC_ROBLE_PROJECT_ID',
    fallback: "NO_ENV",
  );

  final String baseUrl = 'roble-api.openlab.uninorte.edu.co';

  final Map<String, Map<String, dynamic>> _userCache = {};

  Future<String> _getToken() async {
    final prefs = Get.find<ILocalPreferences>();
    final token = await prefs.getString('token');

    if (token == null) {
      throw Exception("No token found");
    }

    return token;
  }

  @override
  Future<List<Map<String, dynamic>>> read({
    required String table,
    Map<String, String>? filters,
  }) async {
    final token = await _getToken();

    final query = {
      "tableName": table,
      ...?filters,
    };

    final uri = Uri.https(baseUrl, '/database/$contract/read', query);

    final response = await httpClient.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Error reading $table");
    }

    final data = jsonDecode(response.body);

    return List<Map<String, dynamic>>.from(data);
  }

  @override
  Future<List<Map<String, dynamic>>> getActivitiesByCourse(
    String courseId,
  ) async {
    final data = await read(
      table: "activity",
      filters: {"course_id": courseId},
    );

    return data;
  }

  @override
  Future<List<Map<String, dynamic>>> getEvaluationsByActivity(
    String activityId,
  ) async {
    final data = await read(
      table: "evaluation",
      filters: {"activity_id": activityId},
    );

    return data;
  }

  @override
  Future<List<Map<String, dynamic>>> getScoresByEvaluation(
    String evaluationId,
  ) async {
    final data = await read(
      table: "evaluation_scores",
      filters: {"evaluation_id": evaluationId},
    );

    return data;
  }

  @override
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    // 🔹 cache
    if (_userCache.containsKey(userId)) {
      return _userCache[userId];
    }

    final data = await read(
      table: "Users",
      filters: {"userId": userId},
    );

    if (data.isEmpty) return null;

    final user = data.first;

    _userCache[userId] = user;

    return user;
  }
}