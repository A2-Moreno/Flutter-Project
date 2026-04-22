import 'package:get/get.dart';
import '../../features/home/data/datasource/course_cache_data_source.dart';

class CacheCleaner {
  static Future<void> clearAll() async {
    try {
      await Get.find<LocalCourseCacheSource>().clearCache();
    } catch (_) {}
  }
}