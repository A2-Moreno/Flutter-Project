import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loggy/loggy.dart';
import 'dart:math';

import '../../../../../core/i_local_preferences.dart';
import 'i_evaluation_remote_data_source.dart';

String generateId() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random();

  return List.generate(12, (index) => chars[rand.nextInt(chars.length)]).join();
}

class EvaluationRemoteDataSourceRoble
    implements IEvaluationRemoteDataSource {

  final http.Client httpClient;

  final contract = dotenv.get(
    'EXPO_PUBLIC_ROBLE_PROJECT_ID',
    fallback: "NO_ENV",
  );

  final String baseUrl = 'roble-api.openlab.uninorte.edu.co';

  EvaluationRemoteDataSourceRoble({http.Client? client})
      : httpClient = client ?? http.Client();

  Future<String> _getToken() async {
    final prefs = Get.find<ILocalPreferences>();
    final token = await prefs.getString('token');
    if (token == null) throw Exception("No token");
    return token;
  }

  // =============================
  // CHECK IF USER EVALUATED
  // =============================
  @override
  Future<bool> hasUserEvaluated(
    String activityId,
    String evaluatorId,
  ) async {

    final token = await _getToken();

    final uri = Uri.https(baseUrl, '/database/$contract/read', {
      "tableName": "evaluation",
      "activity_id": activityId,
      "evaluator_id": evaluatorId,
    });

    final response = await httpClient.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Error verificando evaluación");
    }

    final List data = jsonDecode(response.body);

    return data.isNotEmpty;
  }

  // =============================
  // SUBMIT EVALUATION
  // =============================
  @override
  Future<void> submitEvaluation(
    String activityId,
    String groupId,
    String evaluatorId,
    Map<String, Map<String, double>> data,
  ) async {

    final token = await _getToken();

    for (final entry in data.entries) {
      final evaluatedId = entry.key;
      final scores = entry.value;

      final evaluationId = generateId();

      // 1. Crear evaluation
      final evalBody = jsonEncode({
        "tableName": "evaluation",
        "records": [
          {
            "_id": evaluationId,
            "activity_id": activityId,
            "group_id": groupId,
            "evaluator_id": evaluatorId,
            "evaluated_id": evaluatedId,
          }
        ],
      });

      final evalUri = Uri.https(baseUrl, '/database/$contract/insert');

      final evalResponse = await httpClient.post(
        evalUri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: evalBody,
      );

      if (evalResponse.statusCode != 201) {
        throw Exception("Error creando evaluation");
      }

      // 2. Crear scores
      final scoreRecords = scores.entries.map((s) {
        return {
          "evaluation_id": evaluationId,
          "criterion": s.key,
          "score": s.value,
        };
      }).toList();

      final scoreBody = jsonEncode({
        "tableName": "evaluation_scores",
        "records": scoreRecords,
      });

      final scoreResponse = await httpClient.post(
        evalUri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: scoreBody,
      );

      if (scoreResponse.statusCode != 201) {
        throw Exception("Error creando scores");
      }
    }
  }

  // =============================
  // GET EVALUATIONS
  // =============================
  @override
  Future<List<Map<String, dynamic>>> getEvaluationsByUser(
    String activityId,
    String userId,
  ) async {

    final token = await _getToken();

    final uri = Uri.https(baseUrl, '/database/$contract/read', {
      "tableName": "evaluation",
      "activity_id": activityId,
      "evaluator_id": userId,
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

  // =============================
  // GET SCORES
  // =============================
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
  Future<List<Map<String, dynamic>>> getEvaluations(
    String activityId,
    String userId,
  ) async {

    final token = await _getToken();

    final uri = Uri.https(baseUrl, '/database/$contract/read', {
      "tableName": "evaluation",
      "activity_id": activityId,
      "evaluated_id": userId,
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


  // =============================
  // GET USER
  // =============================
  @override
  Future<Map<String, dynamic>?> getUserById(String userId) async {

    final token = await _getToken();

    final uri = Uri.https(baseUrl, '/database/$contract/read', {
      "tableName": "Users",
      "userId": userId,
    });

    final response = await httpClient.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Error obteniendo usuario");
    }

    final List data = jsonDecode(response.body);

    if (data.isEmpty) return null;

    return data.first;
  }
}