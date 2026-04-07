import 'package:flutter/material.dart';

import '../../../../core/widgets/header.dart';

class ResultsPage extends StatelessWidget {
  ResultsPage({super.key});

  final List<Map<String, dynamic>> mockResults = [
    {
      "name": "Tu resultado",
      "average": "4.4",
      "highlighted": false,
      "criteria": [
        {"label": "Puntualidad", "score": "4.6"},
        {"label": "Aportes", "score": "4.0"},
        {"label": "Compromiso", "score": "4.3"},
        {"label": "Actitud", "score": "4.7"},
      ],
    },
    {
      "name": "Andres Chinchilla",
      "average": "4.4",
      "highlighted": false,
      "criteria": [
        {"label": "Puntualidad", "score": "4.6"},
        {"label": "Aportes", "score": "4.0"},
        {"label": "Compromiso", "score": "4.3"},
        {"label": "Actitud", "score": "4.7"},
      ],
    },
    {
      "name": "Luis Lopez",
      "average": "4.4",
      "highlighted": true,
      "criteria": [
        {"label": "Puntualidad", "score": "4.8"},
        {"label": "Aportes", "score": "4.1"},
        {"label": "Compromiso", "score": "4.4"},
        {"label": "Actitud", "score": "4.3"},
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
              title: "Resultados",
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
                child: ListView.builder(
                  itemCount: mockResults.length,
                  itemBuilder: (context, index) {
                    final item = mockResults[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: ResultTableCard(
                        name: item["name"],
                        average: item["average"],
                        highlighted: item["highlighted"],
                        criteria: List<Map<String, String>>.from(
                          item["criteria"],
                        ),
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

class ResultTableCard extends StatelessWidget {
  final String name;
  final String average;
  final bool highlighted;
  final List<Map<String, String>> criteria;

  const ResultTableCard({
    super.key,
    required this.name,
    required this.average,
    required this.highlighted,
    required this.criteria,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlighted
              ? const Color(0xFF2196F3)
              : const Color(0xFFB8ADD0),
          width: highlighted ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFA693C8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9),
                topRight: Radius.circular(9),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  average,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: List.generate(criteria.length, (index) {
              final row = criteria[index];
              final isLast = index == criteria.length - 1;

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
                          row["label"] ?? "",
                          style: const TextStyle(
                            color: Color(0xFF7A7090),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          row["score"] ?? "",
                          style: const TextStyle(
                            color: Color(0xFF4C3F6D),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}