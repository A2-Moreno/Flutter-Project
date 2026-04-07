import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/authentication_controller.dart';
import '../../../../core/widgets/top_curve_clipper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

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

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    try {
      final success = await controller.signUp(name, email, password, false);

      if (success) {
        controller.userName.value = name;
        controller.userEmail.value = email;
        controller.userPassword.value = password;
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
                    child: Form(
                      key: _formKey,
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

                          // 🔹 NOMBRE
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
                                key: const Key("registerNameField"),
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: 'Nombre completo',
                                  filled: true,
                                  fillColor: const Color(0xFFFFFFFF),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Ingresa tu nombre";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // 🔹 EMAIL
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
                                key: const Key("registerEmailField"),
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: 'Correo institucional',
                                  filled: true,
                                  fillColor: const Color(0xFFFFFFFF),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Ingresa tu correo";
                                  }

                                  final emailRegex = RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+$',
                                  );

                                  if (!emailRegex.hasMatch(value.trim())) {
                                    return "Correo inválido";
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // 🔹 PASSWORD
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
                                key: const Key("registerPasswordField"),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Ingresa tu contraseña";
                                  }

                                  List<String> errors = [];

                                  if (value.length < 8) {
                                    errors.add("• 8 caracteres");
                                  }
                                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                    errors.add("• Una mayúscula");
                                  }
                                  if (!RegExp(r'[a-z]').hasMatch(value)) {
                                    errors.add("• Una minúscula");
                                  }
                                  if (!RegExp(r'\d').hasMatch(value)) {
                                    errors.add("• Un número");
                                  }
                                  if (!RegExp(
                                    r'[^A-Za-z0-9]',
                                  ).hasMatch(value)) {
                                    errors.add("• Un símbolo");
                                  }

                                  if (errors.isNotEmpty) {
                                    return "Debe tener:\n${errors.join('\n')}";
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // 🔹 CONFIRM PASSWORD
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
                                key: const Key("registerConfirmPasswordField"),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Confirma tu contraseña";
                                  }

                                  if (value != passwordController.text) {
                                    return "Las contraseñas no coinciden";
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // 🔹 BOTONES
                          Column(
                            children: [
                              ElevatedButton(
                                key: const Key("registerButton"),
                                onPressed: _register,
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
                              TextButton(
                                key: const Key("goToLoginButton"),
                                onPressed: () =>
                                    controller.signingUp.value = false,
                                child: const Text(
                                  "¿Ya tienes una cuenta?",
                                  style: TextStyle(
                                    color: Color(0xFF4c3f6d),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
