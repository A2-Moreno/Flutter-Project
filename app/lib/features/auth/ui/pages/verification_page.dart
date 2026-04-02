import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewmodels/authentication_controller.dart';
import '../../../../core/widgets/top_curve_clipper.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final AuthenticationController controller = Get.find();
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final code = codeController.text.trim();

    if (code.isEmpty) {
      Get.snackbar(
        "Error",
        "Ingresa el código de verificación",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await controller.verifyAccount(
        controller.userEmail.value,
        code,
        controller.userPassword.value,
        controller.userName.value,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Curva decorativa superior
            Stack(
              children: [
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: const Color(0xFF4c3f6d),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      "assets/logo_sin_fondo.png",
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                  ),
                ),
              ],
            ),

            // Formulario
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      children: [
                        const Text(
                          "Verificación",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 25),

                        Text(
                          controller.userEmail.value.isNotEmpty
                              ? "Te enviamos un código de verificación a ${controller.userEmail.value}"
                              : "Te enviamos un código de verificación a tu correo",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4C3F6D),
                          ),
                        ),

                        const SizedBox(height: 35),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Código de verificación",
                              style: TextStyle(
                                color: Color(0xFF4C3F6D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: codeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Ingresa el código',
                                filled: true,
                                fillColor: const Color(0xFFFFFFFF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        Center(
                          child: ElevatedButton(
                            onPressed: _verifyCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4c3f6d),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Verificar código",
                              style: TextStyle(
                                color: Color(0xFFdcd7d4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
