import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'package:app/core/i_local_preferences.dart';
import 'package:app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:app/features/course/ui/viewmodels/course_controller.dart';
import 'package:app/features/groups/ui/viewmodels/group_controller.dart';

@GenerateMocks([http.Client, ILocalPreferences, IAuthRepository])
class TestHelper {
  static void resetAndInit() {
    Get.testMode = true;
    Get.reset();
  }

  static T injectMock<T>(T mock) {
    return Get.put<T>(mock);
  }
}
