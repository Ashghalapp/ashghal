import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/account/Resetert_Email_Screen.dart';
import 'package:ashghal_app_frontend/features/account/Screen/edit_profile_screen.dart';
import 'package:ashghal_app_frontend/features/account/reset_password_.dart';
import 'package:ashghal_app_frontend/features/account/widgets/settings_widget.dart/setting_group_widget.dart';
import 'package:ashghal_app_frontend/features/account/widgets/settings_widget.dart/setting_item_widget.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth/presentation/screens/auth/chooseusertype.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingsGroupWidget extends StatelessWidget {
  final User user;
  
  const AccountSettingsGroupWidget({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return SettingGroupWidget(
      groupTitle: AppLocalization.account,
      items: [
        // personal item settings
        SettingItemWidget(
          icon: Icons.manage_accounts,
          label: "Profile",
          onTap: () => Get.to(() => EditAccountScreen()),
        ),

        // provider item settings
        SettingItemWidget(
          icon: Icons.privacy_tip_outlined,
          label: AppLocalization.provider,
          onTap: () => Get.to(() => ChooseUserTypeScreen()),
        ),

        // password item settings
        SettingItemWidget(
          icon: Icons.password,
          label: AppLocalization.password,
          data: "******",
          onTap: () => Get.to(() => ResetertPasswordScreen()),
        ),

        // email item settings
        SettingItemWidget(
          icon: Icons.email,
          label: AppLocalization.email,
          data: user.email,
          onTap: () => Get.to(() => Restert_Email_Screen()),
        ),

        // phone item settings
        if (user.phone != null)
          SettingItemWidget(
            icon: Icons.account_box_outlined,
            label: AppLocalization.phoneNumber,
            data: user.phone,
            onTap: () => Get.to(() => Restert_Email_Screen()),
          ),
      ],
    );
  }
}
