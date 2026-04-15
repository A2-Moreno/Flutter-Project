import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/group_controller.dart';
import '../../../save_to_db/ui/viewmodels/savedb_controller.dart';
import '../../../auth/ui/viewmodels/authentication_controller.dart';
import '../../../activity/domain/models/activity_model.dart';
import '../../../../core/widgets/header.dart';

class GroupScreen extends StatefulWidget {
  final Activity activity;

  const GroupScreen({super.key, required this.activity});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

String capitalizeWords(String text) {
  if (text.isEmpty) return text;

  return text
      .split(' ')
      .map(
        (word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase(),
      )
      .join(' ');
}

class _GroupScreenState extends State<GroupScreen> {
  final importController = Get.find<ImportGroupsController>();
  final GroupController controller = Get.find();

  final AuthenticationController authController = Get.find();

  @override
  void initState() {
    super.initState();
    controller.loadGroups(widget.activity.id);
    controller.loadGlobalAverage(widget.activity.id);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF4C3F6D),
      body: SafeArea(
        child: Column(
          children: [
            //Header
            AppHeader(title: widget.activity.name),

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 30, 18, 5),
                      child: const Text(
                        "Grupos",
                        style: TextStyle(
                          color: Color(0xFF4C3F6D),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.groups.isEmpty) {
                          return const Center(
                            child: Text(
                              "No hay grupos aún",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 100),
                          itemCount: controller.groups.length,
                          itemBuilder: (context, index) {
                            final group = controller.groups[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () => controller.openGroup(
                                  widget.activity,
                                  group,
                                ),
                                child: Container(
                                  width: screenWidth * 0.9,
                                  height: screenWidth * 0.3,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: const Color(0xFF7C6A9F),
                                      width: 2,
                                    ),
                                  ),
                                  foregroundDecoration: BoxDecoration(
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
                                        child: Container(
                                          color: const Color(0xFF7C6A9F),
                                          child: Center(
                                            child: Text(
                                              group.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                            "${group.members.map((m) => capitalizeWords(m.name)).join('\n')} ",
                                            style: const TextStyle(
                                              color: Color(0xFF4C3F6D),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),

                    ///*
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
                      child: Center(
                        child: Column(
                          children: [
                            const Text(
                              "Media de la evaluación",
                              style: TextStyle(
                                color: Color(0xFF4C3F6D),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: screenWidth * 0.65,
                              height: screenHeight * 0.2,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFF7C6A9F),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      width: screenWidth * 0.2,
                                      height: screenWidth * 0.15,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF7C6A9F),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Center(
                                        child: Obx(() {
                                          if (controller.isLoading2.value) {
                                            return const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            );
                                          }

                                          return Text(
                                            controller.globalAverage.value
                                                .toStringAsFixed(1),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Promedio de todas",
                                    style: TextStyle(
                                      color: Color(0xFF4C3F6D),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "las evaluaciones",
                                    style: TextStyle(
                                      color: Color(0xFF4C3F6D),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
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
            ),
          ],
        ),
      ),
    );
  }
}
