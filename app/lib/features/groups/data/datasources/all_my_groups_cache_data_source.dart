import 'dart:convert';
import 'package:app/core/i_local_preferences.dart';
import '../../domain/models/all_groups_model.dart';

class LocalAllMyGroupsCache {
  final ILocalPreferences prefs;

  static const _ttlMinutes = 10;

  LocalAllMyGroupsCache(this.prefs);

  String _key(String courseId, String userId) =>
      "all_my_groups_${courseId}_$userId";

  String _timestampKey(String courseId, String userId) =>
      "all_my_groups_ts_${courseId}_$userId";

  // =============================
  // VALIDAR CACHE
  // =============================
  Future<bool> isValid(String courseId, String userId) async {
    final ts = await prefs.getString(_timestampKey(courseId, userId));

    if (ts == null) return false;

    final diff = DateTime.now()
        .difference(DateTime.parse(ts))
        .inMinutes;

    return diff < _ttlMinutes;
  }

  // =============================
  // GUARDAR
  // =============================
  Future<void> save(
    String courseId,
    String userId,
    List<AllMyGroups> data,
  ) async {
    final jsonList = data.map((e) => e.toJson()).toList();

    await prefs.setString(
      _key(courseId, userId),
      jsonEncode(jsonList),
    );

    await prefs.setString(
      _timestampKey(courseId, userId),
      DateTime.now().toIso8601String(),
    );
  }

  // =============================
  // LEER
  // =============================
  Future<List<AllMyGroups>> get(
    String courseId,
    String userId,
  ) async {
    final raw = await prefs.getString(_key(courseId, userId));

    if (raw == null) throw Exception("No cache");

    final decoded = jsonDecode(raw) as List;

    return decoded
        .map((e) => AllMyGroups.fromJson(e))
        .toList();
  }

  // =============================
  // LIMPIAR
  // =============================
  Future<void> clear(String courseId, String userId) async {
    await prefs.remove(_key(courseId, userId));
    await prefs.remove(_timestampKey(courseId, userId));
  }

}