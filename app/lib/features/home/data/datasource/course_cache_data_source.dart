import 'dart:convert';
import 'package:loggy/loggy.dart';
import '../../../../core/i_local_preferences.dart';

class LocalCourseCacheSource {
  final ILocalPreferences prefs;

  static const String _cacheKey = 'cache_courses';
  static const String _cacheTimestampKey = 'cache_courses_timestamp';
  static const int _cacheTTLMinutes = 10;

  LocalCourseCacheSource(this.prefs);

  Future<bool> isCacheValid() async {
    try {
      final timestampStr = await prefs.getString(_cacheTimestampKey);
      if (timestampStr == null) return false;

      final timestamp = DateTime.parse(timestampStr);
      final diff = DateTime.now().difference(timestamp).inMinutes;

      final isValid = diff < _cacheTTLMinutes;

      logInfo(
        '⏱️ Course cache age: ${diff}m / TTL: $_cacheTTLMinutes → ${isValid ? "VALID" : "EXPIRED"}',
      );

      return isValid;
    } catch (e) {
      logError('Error checking course cache: $e');
      return false;
    }
  }

  Future<void> cacheCourses(List<Map<String, dynamic>> courses) async {
    try {
      final encoded = jsonEncode(courses);

      await prefs.setString(_cacheKey, encoded);
      await prefs.setString(
        _cacheTimestampKey,
        DateTime.now().toIso8601String(),
      );

      logInfo('Course cache saved: ${courses.length}');
    } catch (e) {
      logError('Error saving course cache: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCachedCourses() async {
    try {
      final encoded = await prefs.getString(_cacheKey);

      if (encoded == null || encoded.isEmpty) {
        throw Exception('No course cache');
      }

      final decoded = jsonDecode(encoded) as List;

      final courses = decoded
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      logInfo('Course cache loaded: ${courses.length}');

      return courses;
    } catch (e) {
      logError('Error reading course cache: $e');
      throw Exception('Cache read failed');
    }
  }

  Future<void> clearCache() async {
    try {
      await prefs.remove(_cacheKey);
      await prefs.remove(_cacheTimestampKey);

      logInfo('Course cache cleared');
    } catch (e) {
      logError('Error clearing cache: $e');
    }
  }
}