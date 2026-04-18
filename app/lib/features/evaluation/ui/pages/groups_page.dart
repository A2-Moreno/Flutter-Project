import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/header.dart';
import '../../../groups/ui/viewmodels/group_controller.dart';

class GroupsPage extends StatefulWidget {
  final String courseId;
  const GroupsPage({super.key, required this.courseId});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final GroupController controller = Get.find();

  @override
  void initState() {
    super.initState();
    if (widget.courseId.isNotEmpty) {
      controller.loadAllMyGroups(widget.courseId);
    } else {
      print("No se recibió courseId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C3F6D),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'Grupos'),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.error.isNotEmpty) {
                    return Center(child: Text(controller.error.value));
                  }

                  if (controller.allMyGroups.isEmpty) {
                    return const Center(
                      child: Text("No tienes grupos asignados"),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                    itemCount: controller.allMyGroups.length,
                    itemBuilder: (context, index) {
                      final item = controller.allMyGroups[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GroupDeliveryCard(
                          title: item.categoryName,
                          groupName: item.groupName,
                          status:
                              "${item.membersCount}/${item.membersCount} (Completo)",
                          onTap: () {},
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

class GroupDeliveryCard extends StatelessWidget {
  final String title;
  final String groupName;
  final String status;
  final VoidCallback onTap;

  const GroupDeliveryCard({
    super.key,
    required this.title,
    required this.groupName,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: const BoxDecoration(
                color: Color(0xFFA693C8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                border: Border.all(color: const Color(0xFF9B8CB9), width: 1.2),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      child: Text(
                        groupName,
                        style: const TextStyle(
                          color: Color(0xFF4C3F6D),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 44,
                    color: const Color(0xFF9B8CB9),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        status,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF4C3F6D),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
