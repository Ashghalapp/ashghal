import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/choice_chip_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/setting_group_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/setting_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeSettingsGroupWidget extends StatelessWidget {
  const ThemeSettingsGroupWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SettingGroupWidget(
      groupTitle: AppLocalization.theme,
      showEndDivider: true,
      items: [
        // provider item settings
        SettingItemWidget(
          icon: Icons.color_lens_outlined,
          label: "ThemeMode",
          onTap: () => Get.to(
            () => ChoiceChipRow(
              choices: const [],
              changeSelected: (selectedChoice) {},
              initialSelected: 0,
            ),
          ),
        ),

        // personal item settings
        SettingItemWidget(
          icon: Icons.color_lens,
          label: "Color",
          onTap: () {},
        ),
      ],
    );
  }
}
