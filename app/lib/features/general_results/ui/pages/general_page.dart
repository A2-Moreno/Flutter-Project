import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/header.dart';
import '../viewmodels/general_controller.dart';
import '../../../auth/ui/viewmodels/authentication_controller.dart';
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
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (showStudents) {
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
                          return ListView.builder(
                            itemCount: controller.group_results.length,
                            itemBuilder: (context, index) {
                              final groupResult =
                                  controller.group_results[index];
                              return ListTile();
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
