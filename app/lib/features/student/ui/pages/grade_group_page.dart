import 'package:flutter/material.dart';

import '../../../../core/widgets/header.dart';

class GradeGroupPage extends StatelessWidget {
  GradeGroupPage({super.key});

  final List<Map<String, dynamic>> mockMembers = [
    {
      "name": "Andres Chinchilla",
      "criteria": [
        "Puntualidad",
        "Aportes",
        "Compromiso",
        "Actitud",
      ],
    },
    {
      "name": "Luis Lopez",
      "criteria": [
        "Puntualidad",
        "Aportes",
        "Compromiso",
        "Actitud",
      ],
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
              title: "Propuesta proyecto",
            ),

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
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: mockMembers.length,
                        itemBuilder: (context, index) {
                          final member = mockMembers[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _MemberGradeCard(
                              memberName: member["name"],
                              criteria: List<String>.from(member["criteria"]),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C3F6D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Ver resultado",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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

class _MemberGradeCard extends StatelessWidget {
  final String memberName;
  final List<String> criteria;

  const _MemberGradeCard({
    required this.memberName,
    required this.criteria,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFB8ADD0),
          width: 1,
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFA693C8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9),
                topRight: Radius.circular(9),
              ),
            ),
            child: Text(
              memberName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Column(
            children: criteria.map((criterion) {
              final isLast = criterion == criteria.last;

              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: isLast
                        ? BorderSide.none
                        : const BorderSide(
                            color: Color(0xFFD3CBE3),
                            width: 1,
                          ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Color(0xFFD3CBE3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          criterion,
                          style: const TextStyle(
                            color: Color(0xFF7A7090),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF4C3F6D),
                            fontSize: 12,
                          ),
                          decoration: const InputDecoration(
                            hintText: "0.0",
                            hintStyle: TextStyle(
                              color: Color(0xFF7A7090),
                              fontSize: 12,
                            ),
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}