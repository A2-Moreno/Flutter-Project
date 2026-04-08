import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/header.dart';
import '../../../activity/domain/models/activity_model.dart';
import '../viewmodels/results_controller.dart';

class ResultsPage extends StatefulWidget {
  final Activity activity;

  const ResultsPage({super.key, required this.activity});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final ResultsController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.buildResults(widget.activity);
  }

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

                  final my = controller.mySummary.value;
                  final others = controller.publicResults;
                  

                  return ListView(
                    children: [
                      // 🔹 TU RESULTADO (SIEMPRE)
                      if (my != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: ResultTableCard(
                            name: my["name"],
                            average: my["average"],
                            highlighted: false,
                            criteria: List<Map<String, String>>.from(
                              my["criteria"],
                            ),
                          ),
                        ),

                      // 🔹 RESULTADOS DE OTROS (SOLO SI ES PUBLICA)
                      if (widget.activity.isPublic)
                        ...others.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: ResultTableCard(
                              name: item["name"],
                              average: item["average"],
                              highlighted: false,
                              criteria: List<Map<String, String>>.from(
                                item["criteria"],
                              ),
                            ),
                          );
                        }).toList(),
                    ],
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