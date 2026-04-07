import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/authentication_controller.dart';
import '../../../../core/widgets/top_curve_clipper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthenticationController controller = Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final result = await controller.login(email, password);
      if (result) {
        controller.logged.value;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Curva superior
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
                            "Bienvenido",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 50),

                          // EMAIL
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Usuario",
                                style: TextStyle(
                                  color: Color(0xFF4C3F6D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                key: const Key("loginEmailField"),
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: 'Correo Institucional',
                                  filled: true,
                                  fillColor: const Color(0xFFFFFFFF),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Ingresa tu correo";
                                  }

                                  final emailRegex = RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+$',
                                  );
                                  if (!emailRegex.hasMatch(value)) {
                                    return "Correo inválido";
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // PASSWORD
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
                                key: const Key("loginPasswordField"),
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
                                  return null;
                                },
                              ),

                              const SizedBox(height: 40),

                              // BOTÓN LOGIN
                              Center(
                                child: ElevatedButton(
                                  key: const Key("loginButton"),
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4c3f6d),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Iniciar sesión",
                                    style: TextStyle(
                                      color: Color(0xFFdcd7d4),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // REGISTRO
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("¿No tienes una cuenta?"),
                                  TextButton(
                                    onPressed: () =>
                                        controller.signingUp.value = true,
                                    child: const Text(
                                      "Regístrate",
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
