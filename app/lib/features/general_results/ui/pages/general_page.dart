import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/header.dart';
import '../viewmodels/general_controller.dart';
import '../../../auth/ui/viewmodels/authentication_controller.dart';
import '../../../evaluation/ui/pages/results_page.dart';
import '../../../evaluation/ui/pages/results_page.dart';

class GeneralPage extends StatefulWidget {
  final String courseId;

  const GeneralPage({super.key, required this.courseId});

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

String capitalizeWords(String text) {
  return text
      .trim()
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1);
      })
      .join(' ');
}

class _GeneralPageState extends State<GeneralPage> {
  final CourseResultsController controller = Get.find();

  final AuthenticationController authController = Get.find();
  bool showStudents = true;

  @override
  void initState() {
    super.initState();
    controller.loadCourseResults(widget.courseId);
    controller.loadGroupsGlobalAverage(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheidht = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF4C3F6D),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(title: "Resultados Generales"),

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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showStudents = true;
                                });
                              },
                              child: Text(
                                "Estudiantes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: showStudents
                                      ? const Color(0xFF4C3F6D)
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.057,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "|",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.056,
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showStudents = false;
                                });
                              },
                              child: Text(
                                "Grupos",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: !showStudents
                                      ? const Color(0xFF4C3F6D)
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.057,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Obx(() {
                        if (showStudents) {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (controller.students.isEmpty) {
                            return const Center(
                              child: Text("No hay estudiantes"),
                            );
                          }

                          return ListView.builder(
                            itemCount: controller.students.length,
                            itemBuilder: (context, index) {
                              final studentResult = controller.students[index];

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.08,
                                  vertical: 6,
                                ),
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  padding: const EdgeInsets.only(left: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF4C3F6D),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          capitalizeWords(
                                            studentResult["name"],
                                          ),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF4C3F6D),
                                          ),
                                          child: Center(
                                            child: Text(
                                              studentResult["average"],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (controller.groupResults.isEmpty) {
                            return const Center(child: Text("No hay datos"));
                          }

                          return ListView.builder(
                            itemCount: controller.groupResults.length,
                            itemBuilder: (context, index) {
                              final activity = controller.groupResults[index];
                              final groups = activity["groups"] as List;

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1,
                                  vertical: 6,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4C3F6D),
                                        blurRadius: 2,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ExpansionTile(
                                    title: Text(
                                      activity["activity"],
                                      style: const TextStyle(
                                        color: Color(0xFF4C3F6D),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    children: [
                                      SizedBox(
                                        height: 200,
                                        child: ListView.builder(
                                          itemCount: groups.length,
                                          itemBuilder: (context, i) {
                                            final group = groups[i];

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    20,
                                                    8,
                                                    8,
                                                    8,
                                                  ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(group["name"]),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        group["average"]
                                                            .toString(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }),
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
