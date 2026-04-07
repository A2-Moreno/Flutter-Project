import 'package:app/core/local_preferences_secured.dart';
import 'package:app/core/local_preferences_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'core/i_local_preferences.dart';
import 'core/refresh_client.dart';
import 'features/auth/data/datasources/remote/authentication_source_service_roble.dart';
import 'features/auth/data/datasources/remote/i_authentication_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/domain/repositories/i_auth_repository.dart';
import 'features/auth/ui/viewmodels/authentication_controller.dart';

import 'features/teacher/ui/viewmodels/create_courses_controller.dart';
import 'features/teacher/domain/repositories/i_course_create_repository.dart';
import 'features/teacher/data/repositories/course_create_repository.dart';
import 'features/teacher/data/datasources/course_create_source_service_roble.dart';
import 'features/teacher/data/datasources/i_course_create_source.dart';

import 'core/themes/app_theme.dart';
import './central.dart';

import 'core/global_bindings/app_binding.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  Loggy.initLoggy(logPrinter: const PrettyPrinter(showColors: true));

  if (!kIsWeb) {
    Get.put<ILocalPreferences>(LocalPreferencesSecured());
  } else {
    Get.put<ILocalPreferences>(LocalPreferencesShared());
  }

  Get.lazyPut<IAuthenticationSource>(
    () => AuthenticationSourceServiceRoble(),
    fenix: true,
  );

  Get.put<http.Client>(
    RefreshClient(http.Client(), Get.find<IAuthenticationSource>()),
    tag: 'apiClient',
    permanent: true,
  );

  Get.put<IAuthRepository>(AuthRepository(Get.find()));
  Get.put(AuthenticationController(Get.find()));

  Get.lazyPut<ICourseCreateRemoteDataSource>(() => CourseRemoteDataSource());
  Get.put<ICourseCreateRepository>(CourseCreateRepository(Get.find()));
  Get.put(CreateController(Get.find()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Eva',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      home: Central(),
    );
  }
}
