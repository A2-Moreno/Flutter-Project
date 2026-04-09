import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/header.dart';
import '../viewmodels/home_controller.dart';
import '../../../auth/ui/viewmodels/authentication_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  /*final HomeController controller = Get.put(
    HomeController(CourseRepository(CourseRemoteDataSource())),
  );*/

  final HomeController controller = Get.find();

  final AuthenticationController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    controller.reload();

    return Scaffold(
      backgroundColor: const Color(0xFF4C3F6D),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => AppHeader(
                title: "Hola, ${authController.userName.value}",
                showBackButton: false,
                leading: Transform.flip(
                  flipX: true,
                  child: IconButton(
                    onPressed: () => authController.logOut(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.exit_to_app, color: Colors.white),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity, // Asegura que ocupe todo el ancho
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  // CAMBIO: Usamos Column en lugar de Stack para apilar verticalmente
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TÍTULO "Tus cursos"
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
                      child: Text(
                        "Tus cursos",
                        style: const TextStyle(
                          color: Color(
                            0xFF4C3F6D,
                          ), // CAMBIO: Color oscuro para que se vea sobre fondo blanco
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // LISTA DE CURSOS
                    Expanded(
                      child: Stack(
                        // Mantenemos un Stack aquí solo para el botón flotante
                        children: [
                          Obx(() {
                            if (controller.courses.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No tienes cursos inscritos",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              // Quitamos el top padding exagerado porque ya tenemos el título arriba
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                0,
                                18,
                                100,
                              ),
                              itemCount: controller.courses.length,
                              itemBuilder: (context, index) {
                                final course = controller.courses[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap: () => controller.abrirCurso(course),
                                    child: Container(
                                      width: screenWidth * 0.9,
                                      height: screenWidth * 0.25,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFFFF),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: const Color(0xFF7C6A9F),
                                          width: 2,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              course['name'] ?? 'Sin nombre',
                                              style: const TextStyle(
                                                color: Color(0xFF4C3F6D),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${course['activities'] ?? 0} actividades",
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),

                          // BOTÓN FLOTANTE (Solo para profesores)
                          Obx(
                            () => authController.isTeacher.value
                                ? Positioned(
                                    right: 18,
                                    bottom: 18,
                                    child: ElevatedButton(
                                      onPressed: controller.abrirCrearCurso,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF4C3F6D,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 14,
                                        ),
                                      ),
                                      child: const Text(
                                        "+ Crear curso",
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
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
