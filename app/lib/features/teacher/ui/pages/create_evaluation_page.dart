import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../activity/ui/viewmodels/activity_controller.dart';
import '../../../auth/ui/viewmodels/authentication_controller.dart';
import '../../../course/domain/models/category_model.dart';

import '../../../../core/widgets/header.dart';

class CreateEvaluationPage extends StatefulWidget {
  final String courseId;
  final List<Category> categories;

  const CreateEvaluationPage({
    super.key,
    required this.courseId,
    required this.categories,
  });

  @override
  State<CreateEvaluationPage> createState() => _CreateEvaluationPageState();
}

class _CreateEvaluationPageState extends State<CreateEvaluationPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  final activityController = Get.find<ActivityController>();
  final AuthenticationController authController = Get.find();

  Category? selectedCategory;

  bool puntualidad = true;
  bool aportes = true;
  bool compromiso = true;
  bool actitud = true;

  bool resultadoPrivado = true;
  bool resultadoPublico = false;

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4C3F6D),
              onPrimary: Colors.white,
              onSurface: Color(0xFF4C3F6D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text =
          "${picked.day.toString().padLeft(2, '0')}/"
          "${picked.month.toString().padLeft(2, '0')}/"
          "${picked.year}";
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4C3F6D),
              onPrimary: Colors.white,
              onSurface: Color(0xFF4C3F6D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      controller.text = "$hour:$minute";
    }
  }

  InputDecoration _inputDecoration({String? hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.black45, fontSize: 12),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFB6A9D0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4C3F6D), width: 1.5),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF4C3F6D),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _customField({
    required TextEditingController controller,
    required String hintText,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Color(0xFF4C3F6D), fontSize: 12),
      decoration: _inputDecoration(hintText: hintText, suffixIcon: suffixIcon),
    );
  }

  Widget _checkboxTile({
    required bool value,
    required String title,
    required ValueChanged<bool?> onChanged,
  }) {
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          Transform.scale(
            scale: 0.9,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF7E67B8),
              side: const BorderSide(color: Color(0xFF7E67B8)),
              visualDensity: VisualDensity.compact,
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Color(0xFF4C3F6D), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _parseDateTime(String date, String time) {
    final parts = date.split('/');
    final timeParts = time.split(':');

    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    startDateController.dispose();
    startTimeController.dispose();
    endDateController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C3F6D),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: "Crear evaluación"),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel("Nombre de la evaluación"),
                      TextFormField(
                        controller: nameController,
                        decoration: _inputDecoration(),
                      ),

                      const SizedBox(height: 14),

                      _sectionLabel("Categoría de grupos"),
                      DropdownButtonFormField<Category>(
                        value: selectedCategory,
                        decoration: _inputDecoration(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF4C3F6D),
                        ),

                        items: widget.categories.map((category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(
                              category.name,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),

                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),

                      const SizedBox(height: 14),

                      _sectionLabel("Ventana de tiempo"),

                      const Text(
                        "Inicio",
                        style: TextStyle(
                          color: Color(0xFF4C3F6D),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _customField(
                              controller: startDateController,
                              hintText: "Fecha",
                              suffixIcon: IconButton(
                                onPressed: () => _pickDate(startDateController),
                                icon: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Color(0xFF4C3F6D),
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _customField(
                              controller: startTimeController,
                              hintText: "Hora",
                              suffixIcon: IconButton(
                                onPressed: () => _pickTime(startTimeController),
                                icon: const Icon(
                                  Icons.access_time,
                                  color: Color(0xFF4C3F6D),
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Cierre",
                        style: TextStyle(
                          color: Color(0xFF4C3F6D),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _customField(
                              controller: endDateController,
                              hintText: "Fecha",
                              suffixIcon: IconButton(
                                onPressed: () => _pickDate(endDateController),
                                icon: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Color(0xFF4C3F6D),
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _customField(
                              controller: endTimeController,
                              hintText: "Hora",
                              suffixIcon: IconButton(
                                onPressed: () => _pickTime(endTimeController),
                                icon: const Icon(
                                  Icons.access_time,
                                  color: Color(0xFF4C3F6D),
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _sectionLabel("Criterios a evaluar"),
                      _checkboxTile(
                        value: puntualidad,
                        title: "Puntualidad",
                        onChanged: (value) {
                          setState(() {
                            puntualidad = value ?? false;
                          });
                        },
                      ),
                      _checkboxTile(
                        value: aportes,
                        title: "Aportes",
                        onChanged: (value) {
                          setState(() {
                            aportes = value ?? false;
                          });
                        },
                      ),
                      _checkboxTile(
                        value: compromiso,
                        title: "Compromiso",
                        onChanged: (value) {
                          setState(() {
                            compromiso = value ?? false;
                          });
                        },
                      ),
                      _checkboxTile(
                        value: actitud,
                        title: "Actitud",
                        onChanged: (value) {
                          setState(() {
                            actitud = value ?? false;
                          });
                        },
                      ),

                      const SizedBox(height: 14),

                      _sectionLabel("Resultados"),
                      _checkboxTile(
                        value: resultadoPrivado,
                        title: "Privado",
                        onChanged: (value) {
                          setState(() {
                            resultadoPrivado = value ?? false;
                            resultadoPublico = !(value ?? false);
                          });
                        },
                      ),
                      _checkboxTile(
                        value: resultadoPublico,
                        title: "Público",
                        onChanged: (value) {
                          setState(() {
                            resultadoPublico = value ?? false;
                            resultadoPrivado = !(value ?? false);
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              final start = _parseDateTime(
                                startDateController.text,
                                startTimeController.text,
                              );

                              final end = _parseDateTime(
                                endDateController.text,
                                endTimeController.text,
                              );

                              activityController.name.value =
                                  nameController.text;

                              activityController.categoryId.value =
                                  selectedCategory?.id ?? '';

                              activityController.startDate.value = start;
                              activityController.endDate.value = end;

                              activityController.isPublic.value =
                                  resultadoPublico;
                              await activityController.createNewActivity(
                                widget.courseId,
                              );
                              Navigator.of(context).pop(true);
                            } catch (e) {
                              Get.snackbar("Error", e.toString());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4C3F6D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 12,
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Crear actividad",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
