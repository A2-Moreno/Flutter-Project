import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/header.dart';
import '../viewmodels/create_courses_controller.dart';

class CreateCourseScreen extends StatelessWidget {
  const CreateCourseScreen({super.key});

  final _formKey = const GlobalObjectKey<FormState>("createCourseForm");

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final nrcController = TextEditingController();
    final createController = Get.find<CreateController>();

    return Scaffold(
      backgroundColor: const Color(0xFF4C3F6D),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: "Crear curso"),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nombre del curso",
                            style: TextStyle(
                              color: Color(0xFF4C3F6D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "El nombre es obligatorio";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFFFFFFF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "NRC",
                            style: TextStyle(
                              color: Color(0xFF4C3F6D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: nrcController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "El NRC es obligatorio";
                              }

                              if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                                return "El NRC debe ser un número de 4 dígitos";
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFFFFFFF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        key: const Key("createButton"),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final name = nameController.text.trim();
                            final nrc = nrcController.text.trim();

                            createController.createCourse(name, nrc);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4C3F6D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          "Crear curso",
                          style: TextStyle(color: Colors.white),
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
