import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/settings/settings_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/settings/show_edit_profile_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/account_settings_group_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/language_settings_group_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/setting_item_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/theme_settings_group_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TextEditingController Accont1 = TextEditingController();

class SettingScreen extends GetView<ShowEditProfileController> {
  final User user;
  SettingScreen({super.key, required this.user});

  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    // final bool next;
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalization.settings.tr)),
      body: ListView(
        children: [
          AccountSettingsGroupWidget(user: user),
          ThemeSettingsGroupWidget(),
          LanguageSettingsGroupWidget(),

          // delete account
          SettingItemWidget(
            icon: Icons.delete,
            // iconColor: Colors.red,
            label: AppLocalization.deleteAccount,
            labelStyle: Get.textTheme.bodyMedium?.copyWith(color: Colors.red),
            onTap: () => settingsController.submitDeleteAccount(),
          ),

          // log out
          SettingItemWidget(
            icon: Icons.logout,
            label: AppLocalization.logout,
            onTap: () => settingsController.logOut(),
          ),
        ],
      ),
    );
  }
}
