import 'dart:convert';
import 'package:loggy/loggy.dart';
import '../../../../core/i_local_preferences.dart';
import '../../domain/models/activity_model.dart';

class LocalActivityCacheSource {
  final ILocalPreferences prefs;

  static const int _ttlMinutes = 10;

  LocalActivityCacheSource(this.prefs);

  String _key(String courseId) => 'cache_activities_$courseId';
  String _timestampKey(String courseId) =>
      'cache_activities_timestamp_$courseId';

  Future<bool> isCacheValid(String courseId) async {
    try {
      final ts = await prefs.getString(_timestampKey(courseId));
      if (ts == null) return false;

      final timestamp = DateTime.parse(ts);
      final diff = DateTime.now().difference(timestamp).inMinutes;

      final valid = diff < _ttlMinutes;

      logInfo(
          '⏱️ Activity cache [$courseId]: ${diff}m → ${valid ? "VALID" : "EXPIRED"}');

      return valid;
    } catch (e) {
      logError("Error checking activity cache: $e");
      return false;
    }
  }

  Future<void> cacheActivities(
      String courseId, List<Activity> activities) async {
    try {
      final jsonList = activities.map((a) => _toJson(a)).toList();

      await prefs.setString(_key(courseId), jsonEncode(jsonList));
      await prefs.setString(
        _timestampKey(courseId),
        DateTime.now().toIso8601String(),
      );

      logInfo('💾 Cached ${activities.length} activities [$courseId]');
    } catch (e) {
      logError("Error caching activities: $e");
    }
  }

  Future<List<Activity>> getCachedActivities(String courseId) async {
    try {
      final encoded = await prefs.getString(_key(courseId));

      if (encoded == null || encoded.isEmpty) {
        throw Exception("No cache");
      }

      final List data = jsonDecode(encoded);

      final list = data.map((e) => _fromJson(e)).toList();

      logInfo('📦 Loaded ${list.length} cached activities [$courseId]');

      return list;
    } catch (e) {
      logError("Error reading cache: $e");
      throw Exception("Cache failed");
    }
  }

  Future<void> clearCache(String courseId) async {
    await prefs.remove(_key(courseId));
    await prefs.remove(_timestampKey(courseId));
    logInfo('🗑️ Activity cache cleared [$courseId]');
  }


  Map<String, dynamic> _toJson(Activity a) => {
        "_id": a.id,
        "name": a.name,
        "course_id": a.courseId,
        "category_id": a.categoryId,
        "start_date": a.startDate.toIso8601String(),
        "end_date": a.endDate.toIso8601String(),
        "is_public": a.isPublic,
      };

  Activity _fromJson(Map<String, dynamic> json) {
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