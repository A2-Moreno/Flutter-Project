import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/course_controller.dart';
import '../../../save_to_db/ui/viewmodels/savedb_controller.dart';

class CourseScreen extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseScreen({super.key, required this.course});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final importController = Get.find<ImportGroupsController>();
  final CourseController controller = Get.find();

  bool get isTeacher => true;

  @override
  void initState() {
    super.initState();
    controller.loadCategories(widget.course['_id']);
  }

  @override
  Widget build(BuildContext context) {
    final courseId = widget.course['_id'];
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF4c3f6d),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Image.asset(
                        "assets/logo_sin_fondo.png",
                        height: MediaQuery.of(context).size.height * 0.075,
                      ),
                    ],
                  ),
                  Text(
                    widget.course['name'] ?? "Curso",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // BODY
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // TITLE + BUTTON
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                      child: Column(
                        children: [
                          if (isTeacher)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await importController.importCsv(courseId);

                                    // 🔥 RECARGAR DATOS DESPUÉS DE IMPORTAR
                                    await controller.loadCategories(courseId);

                                    Get.snackbar(
                                      "Éxito",
                                      "Grupos importados correctamente",
                                    );
                                  } catch (e) {
                                    Get.snackbar("Error", e.toString());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4C3F6D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: const Text(
                                  "Importar Grupos",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          const Text(
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

                    // LISTA
                    Expanded(
                      child: Obx(() {
                        // 🔄 LOADING
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // 📭 VACÍO
                        if (controller.activities.isEmpty) {
                          return const Center(
                            child: Text(
                              "No hay categorías aún",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        }

                        // ✅ LISTA
                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                          itemCount: controller.activities.length,
                          itemBuilder: (context, index) {
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: const Color(0xFF7C6A9F),
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
                                            activity.name,
                                            style: const TextStyle(
                                              color: Color(0xFF4C3F6D),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (isTeacher)
                                            Text(
                                              "${activity.groupCount} grupos",
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF4C3F6D),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: const Text(
                                        "Ver",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),

                    // BOTONES
                    if (isTeacher)
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4C3F6D),
                          ),
                          child: const Text(
                            "Ver resultados generales",
                            style: TextStyle(color: Colors.white),
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