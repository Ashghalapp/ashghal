import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/account/widgets/settings_widget.dart/setting_group_widget.dart';
import 'package:ashghal_app_frontend/features/account/widgets/settings_widget.dart/setting_item_widget.dart';
import 'package:flutter/material.dart';

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
          onTap: () {},
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
