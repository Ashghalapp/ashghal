import 'package:ashghal_app_frontend/config/theme_controller.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/localization/local_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/choice_chip_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/language_settings_group_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/setting_group_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/setting_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class ThemeSettingsGroupWidget extends StatelessWidget {
  ThemeSettingsGroupWidget({super.key});

  late final themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    List<String> choices = [
      AppLocalization.system,
      AppLocalization.light,
      AppLocalization.dark,
    ];
    return SettingGroupWidget(
      groupTitle: AppLocalization.themeMode.tr,
      showEndDivider: true,
      items: [
        SettingItemWidget(
          icon: Icons.language,
          label: AppLocalization.themeMode.tr,
          onTap: () => Get.to(
            () => ChoiceChipRow(
              title: AppLocalization.themeMode.tr,
              choices: choices.map(
                (chioce) {
                  return Obx(
                    () => ChoiceChip(
                      backgroundColor: Get.theme.cardColor,
                      label: SizedBox(
                        width: Get.width,
                        child: Text(
                          chioce.tr,
                        ),
                      ),
                      selected: themeController.themeMode.value.name ==
                          chioce.toLowerCase(),
                      selectedColor: Get.theme.primaryColor.withOpacity(0.9),
                      labelStyle: Get.textTheme.bodyMedium!.copyWith(
                        color: themeController.themeMode.value.name ==
                                chioce.toLowerCase()
                            ? Get.textTheme.displayLarge?.color
                            : null,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSelected: (bool value) {
                        if (value) {
                          themeController.themeMode.value =
                              ThemeMode.values.byName(chioce.toLowerCase());
                          themeController
                              .changeTheme(themeController.themeMode.value);
                          Restart.restartApp();
                        }
                      },
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        SettingItemWidget(
          icon: Icons.color_lens,
          label: "Color",
          onTap: () {},
        ),
      ],
    );
  }
}
