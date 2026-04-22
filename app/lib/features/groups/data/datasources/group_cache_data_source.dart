import 'dart:convert';
import 'package:app/core/i_local_preferences.dart';
import '../../domain/models/group_model.dart';

class LocalGroupCacheSource {
  final ILocalPreferences prefs;

  static const _prefix = "groups_";
  static const _timestampPrefix = "groups_ts_";
  static const _ttlMinutes = 10;

  LocalGroupCacheSource(this.prefs);

  String _key(String categoryId) => "$_prefix$categoryId";
  String _tsKey(String categoryId) => "$_timestampPrefix$categoryId";

  Future<bool> isCacheValid(String categoryId) async {
    final ts = await prefs.getString(_tsKey(categoryId));
    if (ts == null) return false;

    final diff = DateTime.now().difference(DateTime.parse(ts)).inMinutes;

    return diff < _ttlMinutes;
  }

  Future<void> cacheGroups(String categoryId, List<Group> groups) async {
    final jsonList = groups.map((g) => g.toJson()).toList();

    await prefs.setString(_key(categoryId), jsonEncode(jsonList));
    await prefs.setString(_tsKey(categoryId), DateTime.now().toIso8601String());
  }

  Future<List<Group>> getCachedGroups(String categoryId) async {
    final raw = await prefs.getString(_key(categoryId));

    if (raw == null) throw Exception("No cache");

    final decoded = jsonDecode(raw) as List;

    return decoded.map((e) => Group.fromJson(e)).toList();
  }

  Future<void> clearCache(String categoryId) async {
    await prefs.remove(_key(categoryId));
    await prefs.remove(_tsKey(categoryId));
  }

}