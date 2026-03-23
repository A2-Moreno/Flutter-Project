import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/course_controller.dart';

// Pantalla principal
class CourseScreen extends StatelessWidget {
  final user = "Usuario";
  // Constructor
  CourseScreen({super.key});

  final CourseController controller = Get.put(CourseController());

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
                  // Botón atrás
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        padding: const EdgeInsets.all(0),
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(height: 48),
                      Image.asset(
                        "assets/logo_sin_fondo.png",
                        height: MediaQuery.of(context).size.height * 0.075,
                      ),
                    ],
                  ),

                  // Icono derecha
                  Text(
                    "Programación Movil",
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
                child: Column(
                  children: [
                    // Titulo de la sección
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            if (isTeacher)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 14,
                                  bottom: 14,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {},
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
                                  child: Text(
                                    "Importar Grupos",
                                    style: TextStyle(
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                              ),

                            Text(
                              "Evaluaciones",
                              style: TextStyle(
                                color: Color(0xFF4c3f6d),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Lista de actividades
                    Expanded(
                      child: Obx(
                        () => ListView.builder(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                          itemCount: controller.activities.length,
                          itemBuilder: (context, index) {
                            // Actividad actual que se esta pintando en la lista
                            final activity = controller.activities[index];

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
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            activity['name'] as String,
                                            style: const TextStyle(
                                              color: Color(0xFF4C3F6D),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (isTeacher)
                                            Text(
                                              "${activity['numero de grupos']} grupos",
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // boton para ver grupos
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {},
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
                                        child: Text(
                                          "Ver",
                                          style: TextStyle(
                                            color: const Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Botones solo profesores
                    if (isTeacher)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4C3F6D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 18,
                            ),
                          ),
                          child: Text(
                            "Ver resultados generales",
                            style: TextStyle(color: const Color(0xFFFFFFFF)),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4C3F6D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 18,
                              ),
                            ),
                            child: Text(
                              "Invitar al curso",
                              style: TextStyle(color: const Color(0xFFFFFFFF)),
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4C3F6D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 18,
                              ),
                            ),
                            child: Text(
                              "Crear evaluación",
                              style: TextStyle(color: const Color(0xFFFFFFFF)),
                            ),
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
