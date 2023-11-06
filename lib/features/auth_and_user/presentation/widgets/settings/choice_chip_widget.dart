import 'package:ashghal_app_frontend/config/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoiceChipRow extends StatelessWidget {
  final String title;
  final List<Widget> choices;
  // final int initialSelected;

  const ChoiceChipRow({
    super.key,
    required this.title,
    required this.choices,
    // required this.initialSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Get.theme.dividerTheme.color,
            child: Text(
              title,
              maxLines: 1,
              style: Get.textTheme.bodyMedium,
            ),
          ),
          ...choices.map((choice) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: choice,
            );
          }).toList(),
        ],
      ),
    );
  }
}
