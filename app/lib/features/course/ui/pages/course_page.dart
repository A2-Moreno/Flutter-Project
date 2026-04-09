import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../../core/widgets/header.dart';
import '../viewmodels/course_controller.dart';
import '../../../save_to_db/ui/viewmodels/savedb_controller.dart';
import '../../../auth/ui/viewmodels/authentication_controller.dart';

//import '../../../student/ui/pages/groups_page.dart';

class CourseScreen extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseScreen({super.key, required this.course});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final importController = Get.find<ImportGroupsController>();
  final CourseController controller = Get.find();

  final AuthenticationController authController = Get.find();
  final showAvailable = true.obs;
  @override
  void initState() {
    super.initState();
    controller.loadCategories(widget.course['_id']);
    controller.loadActivities(widget.course['_id']);
  }

  @override
  Widget build(BuildContext context) {
    final courseId = widget.course['_id'];
    final screenWidth = MediaQuery.of(context).size.width;
    String formatDateEs(DateTime date) {
      final formatted = DateFormat(
        "EEEE, d 'de' MMMM 'de' yyyy - hh:mm a",
        'es',
      ).format(date);

      return formatted[0].toUpperCase() + formatted.substring(1);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF4C3F6D),
      body: SafeArea(
        child: Column(
          children: [
            //Header
            AppHeader(title: widget.course['name'] ?? "Curso"),

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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (authController.isTeacher.value)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await importController.importCsv(
                                        courseId,
                                      );
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 14,
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
                                color: Color(0xFF4C3F6D),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Obx(() {
                        return Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => showAvailable.value = true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: showAvailable.value
                                        ? const Color(0xFF4C3F6D)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: const Color(0xFF4C3F6D),
                                    ),
                                  ),
                                  child: Text(
                                    "Disponibles",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: showAvailable.value
                                          ? Colors.white
                                          : const Color(0xFF4C3F6D),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => showAvailable.value = false,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !showAvailable.value
                                        ? const Color(0xFF4C3F6D)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: const Color(0xFF4C3F6D),
                                    ),
                                  ),
                                  child: Text(
                                    "Finalizadas",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: !showAvailable.value
                                          ? Colors.white
                                          : const Color(0xFF4C3F6D),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(height: 25),

                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final activities = showAvailable.value
                            ? controller.availableActivities
                            : controller.expiredActivities;
                        if (activities.isEmpty) {
                          return const Center(
                            child: Text(
                              "No hay actividades aún",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            final activity = activities[index];

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
                                          Flexible(
                                            child: Text(
                                              formatDateEs(activity.endDate),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (!authController.isTeacher.value) {
                                          controller.openCategoryStudent(
                                            activity,
                                          );
                                        } else {
                                          controller.openCategory(activity);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF4C3F6D,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
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
                    if (authController.isTeacher.value)
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4C3F6D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 18,
                                ),
                              ),
                              child: const Text(
                                "Ver resultados generales",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controller.createActivityPage(courseId);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4C3F6D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 18,
                                ),
                              ),
                              child: const Text(
                                "Crear evaluación",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.openGroupsStudent(courseId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4C3F6D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 18,
                              ),
                            ),
                            child: const Text(
                              "Tus grupos",
                              style: TextStyle(color: Colors.white),
                            ),
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
