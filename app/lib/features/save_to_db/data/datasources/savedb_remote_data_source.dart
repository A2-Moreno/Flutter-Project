import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../core/i_local_preferences.dart';
import 'i_savedb_remote_data_source.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class GroupRemoteDataSourceRoble implements IGroupRemoteDataSource {
  final http.Client httpClient;

  final contract = dotenv.get(
    'EXPO_PUBLIC_ROBLE_PROJECT_ID',
    fallback: "NO_ENV",
  );

  final String baseUrl = 'roble-api.openlab.uninorte.edu.co';

  GroupRemoteDataSourceRoble({http.Client? client})
    : httpClient = client ?? http.Client();

  Future<String> _getToken() async {
    final prefs = Get.find<ILocalPreferences>();
    final token = await prefs.getString('token');
    if (token == null) throw Exception("No token");
    return token;
  }

  // CATEGORY
  @override
  Future<String> createCategory(String courseId, String name) async {
    final token = await _getToken();

    final uri = Uri.https(baseUrl, '/database/$contract/insert');

    final body = jsonEncode({
      "tableName": "category",
      "records": [
        {"course_id": courseId, "name": name},
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

    logInfo("Create Category: ${response.body}");

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      if (data["inserted"] != null && data["inserted"].isNotEmpty) {
        return data["inserted"][0]["_id"];
      }

      throw Exception("No se insertó categoría");
    }

    throw Exception("Error creando categoría");
  }

  // GROUP
  @override
  Future<String> createGroup(
    String categoryId,
    String name,
    String code,
  ) async {
    final token = await _getToken();

    final uri = Uri.https(baseUrl, '/database/$contract/insert');

    final body = jsonEncode({
      "tableName": "groups",
      "records": [
        {"category_id": categoryId, "name": name, "code": code},
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

    logInfo("Create Group: ${response.body}");

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      if (data["inserted"] != null && data["inserted"].isNotEmpty) {
        return data["inserted"][0]["_id"];
      }

      throw Exception("No se insertó grupo");
    }

    throw Exception("Error creando grupo");
  }

  // USER (GET OR CREATE)
  @override
  Future<String> getOrCreateUser(String email, String name) async {
    final token = await _getToken();

    final readUri = Uri.https(baseUrl, '/database/$contract/read', {
      "tableName": "Users",
      "email": email,
    });

    final readResponse = await httpClient.get(
      readUri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (readResponse.statusCode == 200) {
      final List users = jsonDecode(readResponse.body);

      if (users.isNotEmpty) {
        return users.first["userId"];
      }
    }

    final newUserId = const Uuid().v4();

    final insertUri = Uri.https(baseUrl, '/database/$contract/insert');

    final body = jsonEncode({
      "tableName": "Users",
      "records": [
        {
          "userId": newUserId,
          "email": email,
          "name": name,
        },
      ],
    });

    final response = await httpClient.post(
      insertUri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    logInfo("Create User: ${response.body}");

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      if (data["inserted"] != null && data["inserted"].isNotEmpty) {
        return data["inserted"][0]["userId"];
      }

      throw Exception("No se insertó usuario");
    }

    throw Exception("Error creando usuario");
  }

  // COURSE MEMBERS
  @override
  Future<void> addUserToCourse(String userId, String courseId) async {
    final token = await _getToken();

    final uri = Uri.https(baseUrl, '/database/$contract/insert');

    final body = jsonEncode({
      "tableName": "course_members",
      "records": [
        {"estudiante_id": userId, "course_id": courseId},
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

    logInfo("Add to course: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception("Error agregando usuario a curso");
    }
  }

  // GROUP MEMBERS
  @override
  Future<void> addUserToGroup(String userId, String groupId) async {
    final token = await _getToken();

    final uri = Uri.https(baseUrl, '/database/$contract/insert');

    final body = jsonEncode({
      "tableName": "group_members",
      "records": [
        {"estudiante_id": userId, "group_id": groupId},
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

    logInfo("Add to group: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception("Error agregando usuario a grupo");
    }
  }
}
