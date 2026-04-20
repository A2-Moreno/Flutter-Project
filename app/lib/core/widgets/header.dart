import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final Widget? leading;

  const AppHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final logoHeight = MediaQuery.of(context).size.height * 0.075;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 40,
                child:
                    leading ??
                    (showBackButton
                        ? IconButton(
                            key: const Key("backButton"),
                            onPressed: () => Get.back(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox.shrink()),
              ),
              const Spacer(),
              Image.asset(
                "assets/logo_sin_fondo.png",
                height: logoHeight,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
