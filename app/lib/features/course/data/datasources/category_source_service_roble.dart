import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../core/i_local_preferences.dart';
import '../../domain/models/category_model.dart';
import 'i_category_source_service_roble.dart';

class CourseViewRemoteDataSourceRoble
    implements ICourseViewRemoteDataSource {

  final http.Client httpClient;

  final contract = dotenv.get(
    'EXPO_PUBLIC_ROBLE_PROJECT_ID',
    fallback: "NO_ENV",
  );

  final String baseUrl = 'roble-api.openlab.uninorte.edu.co';

  CourseViewRemoteDataSourceRoble({http.Client? client})
      : httpClient = client ?? http.Client();

  Future<String> _getToken() async {
    final prefs = Get.find<ILocalPreferences>();
    final token = await prefs.getString('token');
    if (token == null) throw Exception("No token");
    return token;
  }

  @override
  Future<List<Category>> getCategoriesWithGroups(
    String courseId,
  ) async {

    final token = await _getToken();

    // 1. Obtener categorías
    final categoryUri = Uri.https(
      baseUrl,
      '/database/$contract/read',
      {
        "tableName": "category",
        "course_id": courseId,
      },
    );

    final categoryResponse = await httpClient.get(
      categoryUri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (categoryResponse.statusCode != 200) {
      throw Exception("Error obteniendo categorías");
    }

    final List categories = jsonDecode(categoryResponse.body);

    List<Category> result = [];

    // 2. Para cada categoría → contar grupos
    for (final cat in categories) {

      final categoryId = cat["_id"];

      final groupUri = Uri.https(
        baseUrl,
        '/database/$contract/read',
        {
          "tableName": "groups",
          "category_id": categoryId,
        },
      );

      final groupResponse = await httpClient.get(
        groupUri,
        headers: {"Authorization": "Bearer $token"},
      );

      if (groupResponse.statusCode != 200) {
        throw Exception("Error obteniendo grupos");
      }

      final List groups = jsonDecode(groupResponse.body);

      result.add(
        Category(
          id: categoryId,
          name: cat["name"],
          groupCount: groups.length,
        ),
      );
    }

    return result;
  }
}