import 'package:ashghal_app_frontend/config/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoiceChipRow extends StatefulWidget {
  final List<String> choices;
  final void Function(int selectedChoic) changeSelected;
  final int initialSelected;

  const ChoiceChipRow({
    super.key,
    required this.choices,
    required this.changeSelected,
    required this.initialSelected,
  });

  @override
  _ChoiceChipRowState createState() => _ChoiceChipRowState();
}

class _ChoiceChipRowState extends State<ChoiceChipRow> {

  @override
  void initState() {
    super.initState();
  }

  late final themeController = Get.find<ThemeController>();
  // late String selectedChoice = themeController.themeMode.value.name;
  @override
  Widget build(BuildContext context) {
    // selectedChoice = themeController.themeMode.value.name;
    List<String> choices =
        ThemeMode.values.map((e) => e.name).toList(); // widget.choices;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Get.theme.dividerTheme.color,
            child: Text(
              "Theme Mode",
              maxLines: 1,
              style: Get.textTheme.bodyMedium,
            ),
          ),
          ...choices.map((choice) {
            return Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ChoiceChip(
                  backgroundColor: Get.theme.cardColor,
                  label: SizedBox(
                    width: Get.width,
                    child: Text(
                      choice,
                    ), // textAlign: TextAlign.center),
                  ),
                  selected: themeController.themeMode.value.name == choice,
                  selectedColor: Get.theme.primaryColor.withOpacity(0.9),
                  labelStyle: Get.textTheme.bodyMedium!.copyWith(
                    color: themeController.themeMode.value.name == choice
                        ? Get.textTheme.displayLarge?.color
                        : null,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onSelected: (bool selected) {
                    if (selected) {
                      themeController.themeMode.value =
                          ThemeMode.values.byName(choice);
                      themeController
                          .changeTheme(themeController.themeMode.value);
                    }
                  },
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
