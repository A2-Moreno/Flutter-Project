import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/header.dart';
import '../../../activity/domain/models/activity_model.dart';
import '../../../groups/domain/models/group_model.dart';
import '../viewmodels/teacher_results_controller.dart';
import 'results_page.dart'; // reutilizamos ResultTableCard

class TeacherResultsPage extends StatefulWidget {
  final Activity activity;
  final Group group;

  const TeacherResultsPage({
    super.key,
    required this.activity,
    required this.group,
  });

  @override
  State<TeacherResultsPage> createState() => _TeacherResultsPageState();
}

class _TeacherResultsPageState extends State<TeacherResultsPage> {
  final controller = Get.find<TeacherResultsController>();

  @override
  void initState() {
    super.initState();

    controller.loadGroupResults(
      widget.activity,
      widget.group,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C3F6D),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: "Resultados del grupo"),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.error.isNotEmpty) {
                    return Center(
                      child: Text(controller.error.value),
                    );
                  }

                  final items = controller.studentsResults;

                  if (items.isEmpty) {
                    return const Center(
                      child: Text("No hay resultados disponibles"),
                    );
                  }

                  
                  final sorted = [...items];
                  sorted.sort((a, b) =>
                      double.parse(b["average"])
                          .compareTo(double.parse(a["average"]))
                  );

                  return ListView.builder(
                    itemCount: sorted.length,
                    itemBuilder: (context, index) {
                      final item = sorted[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: ResultTableCard(
                          name: item["name"],
                          average: item["average"],
                          highlighted: index == 0, 
                          criteria: List<Map<String, String>>.from(
                            item["criteria"],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}