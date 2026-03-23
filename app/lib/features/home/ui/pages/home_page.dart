import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/home_controller.dart';

// Pantalla principal
class HomeScreen extends StatelessWidget {
  final user = "Usuario";
  // Constructor
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  bool get isTeacher => true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF4c3f6d),
      body: SafeArea(
        child: Column(
          children: [
            // Encabezado superior morado
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 48),
                      Image.asset(
                        "assets/logo_sin_fondo.png",
                        height: MediaQuery.of(context).size.height * 0.075,
                      ),
                    ],
                  ),

                  // Icono derecha
                  Text(
                    "Hola, $user",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Zona principal
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    Obx(
                      () => ListView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 24, 18, 100),
                        itemCount: controller.courses.length,
                        itemBuilder: (context, index) {
                          // Curso actual que se esta pintando en la lista
                          final course = controller.courses[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              width: screenWidth * 0.9,
                              height: screenWidth * 0.25,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Color(0xFF7C6A9F),
                                  width: 2,
                                ),
                              ),

                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.network(
                                      "https://picsum.photos/500/500",
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            course['name'] as String,
                                            style: const TextStyle(
                                              color: Color(0xFF4C3F6D),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${course['activities']} actividades",
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: controller.abrirCurso,
                                    padding: const EdgeInsets.all(0),
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF4C3F6D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Boton para crear curso, solo profesores
                    if (isTeacher)
                      Positioned(
                        right: 18,
                        bottom: 18,
                        child: ElevatedButton(
                          onPressed: controller.abrirCrearCurso,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4C3F6D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            "+ Crear curso",
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
