import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/header.dart';
import '../../../groups/ui/viewmodels/group_controller.dart';
import '../../../activity/domain/models/activity_model.dart';
import '../viewmodels/evaluation_controller.dart';

class GradeGroupPage extends StatefulWidget {
  final Activity activity;

  const GradeGroupPage({super.key, required this.activity});

  @override
  State<GradeGroupPage> createState() => _GradeGroupPageState();
}

class _GradeGroupPageState extends State<GradeGroupPage> {
  final GroupController controller = Get.find();
  final EvaluationController evalController = Get.find();

  final List<String> criteria = [
    "Puntualidad",
    "Aportes",
    "Compromiso",
    "Actitud",
  ];

  @override
  void initState() {
    super.initState();
    controller.loadGroups(widget.activity.id);
    evalController.init(widget.activity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C3F6D),
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(title: widget.activity.name),

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
                  if (controller.isLoading.value ||
                      evalController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.error.isNotEmpty) {
                    return Center(child: Text(controller.error.value));
                  }

                  final group = controller.myGroup.value;

                  if (group == null) {
                    return const Center(
                      child: Text(
                        "No perteneces a ningún grupo en esta categoría",
                      ),
                    );
                  }

                  final members = group.members;

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            final member = members[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _MemberGradeCard(
                                memberName: member.name,
                                evaluatedUserId: member.userId,
                                criteria: criteria,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => evalController.isEvaluationMode.value
                                ? ElevatedButton(
                                    onPressed: () {
                                      evalController.submit(widget.activity.id);
                                    },
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
                                      "Enviar evaluacion",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              evalController.openResults(widget.activity);
                            },
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

class GradeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Permitir borrar el contenido
    if (text.isEmpty) {
      return newValue;
    }

    // Solo permite:
    // 1, 1.0, 1.5, 2, 2.3, ..., 5, 5.0
    // Máximo un decimal
    final regex = RegExp(r'^[1-5](\.\d?)?$');

    if (!regex.hasMatch(text)) {
      return oldValue;
    }

    final value = double.tryParse(text);

    if (value == null || value < 1.0 || value > 5.0) {
      return oldValue;
    }

    return newValue;
  }
}

class _MemberGradeCard extends StatelessWidget {
  final String memberName;
  final String evaluatedUserId;
  final List<String> criteria;

  const _MemberGradeCard({
    required this.memberName,
    required this.evaluatedUserId,
    required this.criteria,
  });

  @override
  Widget build(BuildContext context) {
    final EvaluationController evalController = Get.find();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFB8ADD0), width: 1),
        color: Colors.white,
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
                        : const BorderSide(color: Color(0xFFD3CBE3), width: 1),
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
                        child: Obx(() {
                          if (evalController.isResultMode.value) {
                            final myGrade = evalController
                                .mySubmittedGrades[evaluatedUserId]?[criterion];

                            return Text(
                              myGrade != null
                                  ? myGrade.toStringAsFixed(1)
                                  : "-",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF4C3F6D),
                                fontSize: 12,
                              ),
                            );
                          }

                          return TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              GradeInputFormatter(),
                            ],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF4C3F6D),
                              fontSize: 12,
                            ),
                            decoration: const InputDecoration(
                              hintText: "1.0",
                              hintStyle: TextStyle(
                                color: Color(0xFF7A7090),
                                fontSize: 12,
                              ),
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onChanged: (value) {
                              if (value.isEmpty) return;

                              final parsed = double.tryParse(value);

                              if (parsed != null &&
                                  parsed >= 1.0 &&
                                  parsed <= 5.0) {
                                evalController.setGrade(
                                  evaluatedUserId,
                                  criterion,
                                  parsed,
                                );
                              }
                            },
                          );
                        }),
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