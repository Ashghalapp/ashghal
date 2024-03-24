import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/dialog_util.dart';
import 'package:ashghal_app_frontend/core/widget/check_password_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/settings/change_email_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/settings/show_edit_profile_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/settings/show_edit_provider_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/settings/change_password_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/setting_group_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/setting_item_widget.dart';
import 'package:ashghal_app_frontend/tester%20copy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingsGroupWidget extends StatelessWidget {
  final User user;

  const AccountSettingsGroupWidget({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return SettingGroupWidget(
      groupTitle: AppLocalization.account.tr,
      items: [
        // personal item settings
        SettingItemWidget(
          icon: Icons.manage_accounts,
          label: AppLocalization.profile.tr,
          onTap: () => Get.to(() => ShowEditProfileScreen())?.then((value) {
            print(
                "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<baack>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
          }),
        ),

        // provider item settings
        SettingItemWidget(
          icon: Icons.privacy_tip_outlined,
          label: AppLocalization.provider.tr,
          onTap: () => Get.to(() => ShowEditProviderScreen()),
        ),

        // password item settings
        SettingItemWidget(
          icon: Icons.password,
          label: AppLocalization.changePassword.tr,
          data: "******",
          onTap: () {
            // Get.to(teest());
            DialogUtil.showDialogForWidget(
              child: CheckPasswordWidget(
                onCorrectCheck: () {
                  // close the dialog
                  Get.back();
                  Get.to(() => ChangePasswordScreen());
                },
              ),
            ).then((value) {
              Get.delete<CheckPasswordController>();
            });
          },
        ),

        // email item settings
        SettingItemWidget(
          icon: Icons.email,
          label: AppLocalization.changeEmail,
          data: user.email,
          onTap: () {
            DialogUtil.showDialogForWidget(
              child: CheckPasswordWidget(
                onCorrectCheck: () {
                  // close the dialog
                  Get.back();
                  Get.to(() => const ChangeEmailScreen());
                },
              ),
            ).then((value) {
              Get.delete<CheckPasswordController>();
            });
            // Get.defaultDialog(title: "", content: CheckPasswordWidget());
            // AppUtil.buildPasswordDialog("12345");
            // Get.to(() => const ChangeEmailScreen());
          },
        ),

        // phone item settings
        if (user.phone != null)
          SettingItemWidget(
            icon: Icons.account_box_outlined,
            label: AppLocalization.phoneNumber.tr,
            data: user.phone,
            onTap: () {},
          ),
      ],
    );
  }
}
