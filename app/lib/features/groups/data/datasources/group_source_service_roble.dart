import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'i_group_source_service_roble.dart';
import '../../../../../core/i_local_preferences.dart';

class GroupDetailRemoteDataSource implements IGroupDetailRemoteDataSource {
  final http.Client httpClient;

  final contract = dotenv.get(
    'EXPO_PUBLIC_ROBLE_PROJECT_ID',
    fallback: "NO_ENV",
  );

  final String baseUrl = 'roble-api.openlab.uninorte.edu.co';

  GroupDetailRemoteDataSource({http.Client? client})
    : httpClient = client ?? http.Client();

  Future<String> _getToken() async {
    final prefs = Get.find<ILocalPreferences>();
    final token = await prefs.getString('token');

    if (token == null) {
      throw Exception("No token found");
    }

    return token;
  }

  @override
  Future<List<dynamic>> read({
    required String table,
    Map<String, String>? filters,
  }) async {
    final token = await _getToken();

    final query = {"tableName": table, ...?filters};

    final uri = Uri.https(baseUrl, '/database/$contract/read', query);

    final response = await httpClient.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data;
    }

    throw Exception("Error reading $table");
  }

  @override
  Future<List<Map<String, dynamic>>> getScoresByEvaluation(
    String evaluationId,
  ) async {
    final token = await _getToken();

    final uri = Uri.https(baseUrl, '/database/$contract/read', {
      "tableName": "evaluation_scores",
      "evaluation_id": evaluationId,
    });

    final response = await httpClient.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Error obteniendo scores");
    }
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  }

  @override
  Future<List<Map<String, dynamic>>> getEvaluationsByActivity(
    String activityId,
  ) async {
    final token = await _getToken();

    final uri = Uri.https(baseUrl, '/database/$contract/read', {
      "tableName": "evaluation",
      "activity_id": activityId,
    });

    final response = await httpClient.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Error obteniendo evaluaciones");
    }

    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  }
}
