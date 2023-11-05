import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/localization/local_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/choice_chip_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/setting_group_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/setting_item_widget.dart';
import 'package:ashghal_app_frontend/mainscreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LangChoicesData {
  final String label;
  final String code;

  LangChoicesData({
    required this.label,
    required this.code,
  });
}

class LanguageSettingsGroupWidget extends StatelessWidget {
  LanguageSettingsGroupWidget({super.key});
  final AppLocallcontroller _locallcontroller = Get.find();
  List<LangChoicesData> choices = [
    LangChoicesData(
      label: AppLocalization.systemLanguage,
      code: 'sys',
    ),
    LangChoicesData(
      label: AppLocalization.arabic,
      code: 'ar',
    ),
    LangChoicesData(
      label: AppLocalization.english,
      code: 'en',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SettingGroupWidget(
      groupTitle: AppLocalization.appLanguage.tr,
      showEndDivider: true,
      items: [
        // provider item settings
        SettingItemWidget(
          icon: Icons.language,
          label: _locallcontroller.language.value == "en"
              ? AppLocalization.english.tr
              : _locallcontroller.language.value == "ar"
                  ? AppLocalization.arabic.tr
                  : AppLocalization.systemLanguage.tr,
          onTap: () => Get.to(
            () => ChoiceChipRow(
              title: AppLocalization.appLanguage.tr,
              choices: choices.map(
                (chioce) {
                  return Obx(
                    () => ChoiceChip(
                      backgroundColor: Get.theme.cardColor,
                      label: SizedBox(
                        width: Get.width,
                        child: Text(
                          chioce.label.tr,
                        ),
                      ),
                      selected: _locallcontroller.language.value == chioce.code,
                      selectedColor: Get.theme.primaryColor.withOpacity(0.9),
                      labelStyle: Get.textTheme.bodyMedium!.copyWith(
                        color: _locallcontroller.language.value == chioce.code
                            ? Get.textTheme.displayLarge?.color
                            : null,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSelected: (bool value) {
                        _locallcontroller.changeLanguage(chioce.code);
                        // MainScreenController controller = Get.find();
                        // controller.updateUp();
                      },
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
