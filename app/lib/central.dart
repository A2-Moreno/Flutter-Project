import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/auth/ui/viewmodels/authentication_controller.dart';
import 'features/auth/ui/pages/login_page.dart';
import 'features/home/ui/pages/home_page.dart';
import 'features/auth/ui/pages/register_page.dart';
import 'features/auth/ui/pages/verification_page.dart';

class Central extends StatelessWidget {
  const Central({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationController = Get.find();
    return Obx(() {
      if (authenticationController.logged.value) {
        return HomeScreen();
      }
      if (authenticationController.validating.value) {
        return VerificationPage();
      }
      if (authenticationController.signingUp.value) {
        return RegisterPage();
      }
      return LoginPage();
    });
  }
}
