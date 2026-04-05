import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../course/domain/models/category_model.dart';

import '../../../../../core/widgets/header.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  final List<Map<String, String>> mockGroups = const [
    {
      'title': 'Entrega 1',
      'group': 'Grupo 01',
      'status': '4/4 (Completo)',
    },
    {
      'title': 'Entrega 2',
      'group': 'Grupo 08',
      'status': '4/4 (Completo)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C3F6D),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Grupos',
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                  itemCount: mockGroups.length,
                  itemBuilder: (context, index) {
                    final item = mockGroups[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GroupDeliveryCard(
                        title: item['title']!,
                        groupName: item['group']!,
                        status: item['status']!,
                        onTap: () {},
                      ),
                    );
                  },
                ),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
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
                border: Border.all(
                  color: const Color(0xFF9B8CB9),
                  width: 1.2,
                ),
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