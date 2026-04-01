import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/features/auth/ui/pages/verification_page.dart';

import '../viewmodels/authentication_controller.dart';
import '../../../../core/widgets/top_curve_clipper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.title});

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthenticationController controller = Get.find();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      Get.snackbar(
        "Error",
        "Las contraseñas no coinciden",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final success = await controller.signUp(name, email, password, false);

      if (success) {
        Get.to(
          () => const VerificationPage(title: "Verificación"),
          arguments: {'email': email, 'password': password, 'name': name},
        );
      } else {
        Get.snackbar(
          "Error",
          "No se pudo registrar el usuario",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Ocurrió un problema: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
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
                          "Registro",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Nombre completo
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nombre completo",
                              style: TextStyle(
                                color: Color(0xFF4C3F6D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Nombre completo',
                                filled: true,
                                fillColor: const Color(0xFFFFFFFF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Correo
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Correo",
                              style: TextStyle(
                                color: Color(0xFF4C3F6D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: 'Correo institucional',
                                filled: true,
                                fillColor: const Color(0xFFFFFFFF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Contraseña
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Contraseña",
                              style: TextStyle(
                                color: Color(0xFF4C3F6D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Contraseña',
                                filled: true,
                                fillColor: const Color(0xFFFFFFFF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Confirmar contraseña
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Confirmar contraseña",
                              style: TextStyle(
                                color: Color(0xFF4C3F6D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Confirmar contraseña',
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
                            onPressed: () {
                              _register();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4c3f6d),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Registrarse",
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
