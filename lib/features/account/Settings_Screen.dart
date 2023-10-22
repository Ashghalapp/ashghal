import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/account/reset_password_.dart';
import 'package:ashghal_app_frontend/features/account/widgets/settings_widget.dart/account_settings_group_widget.dart';
import 'package:ashghal_app_frontend/features/account/widgets/settings_widget.dart/setting_item_widget.dart';
import 'package:ashghal_app_frontend/features/account/widgets/settings_widget.dart/theme_settings_group_widget.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth/presentation/screens/auth/chooseusertype.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Resetert_Email_Screen.dart';
import 'Screen/edit_profile_screen.dart';
import 'getx/edit_profile_controller.dart';

TextEditingController Accont1 = TextEditingController();

class SettingScreen extends GetView<EditProfileController> {
  final User user;
  const SettingScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // final bool next;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.settings.tr,
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AccountSettingsGroupWidget(user: user),
          const ThemeSettingsGroupWidget(),
          // InformationSettingThems(NameLabel: 'Themes'),
          SettingItemWidget(icon: Icons.logout, label: AppLocalization.logout,onTap: () {
            SharedPref.setUserLoggedIn(false);
            Get.offAllNamed(AppRoutes.logIn);
            AppUtil.showMessage(AppLocalization.success, Colors.green);
          },)
        ],
      ),
    );
  }

}

Widget buildGroupWidget({
  required String titleGroup,
  List<Widget>? ittemsWidgets,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titleGroup),
        buildIGroupItemWidget(
            iconData: Icons.account_box_outlined,
            label: 'Account',
            data: 'المعلومات الاساسية',
            // next: true,
            onClick: () {

            }),
        buildIGroupItemWidget(
          iconData: Icons.privacy_tip_outlined,
          label: 'Provider',
          data: 'Clint',
          // next: true,
          onClick: () {
            Get.to(() => ChooseUserTypeScreen());
          },
        ),
        buildIGroupItemWidget(
          iconData: Icons.password,
          label: 'Password',
          data: 'Kasswrh Al mohamidi',
          // next: true,
          onClick: () {
            Get.to(() => ResetertPasswordScreen());
          },
        ),
        buildIGroupItemWidget(
          iconData: Icons.email,
          label: 'Email',
          data: 'KasswrhAlmohamidi@asswrhAlmohamidi@gmail.com',
          // next: true,
          onClick: () {
            Get.to(() => Restert_Email_Screen());
          },
        ),
        Divider(
          thickness: 4,
        )
      ],
    ),
  );
}

Widget buildIGroupItemWidget({
  required IconData iconData,
  required String label,
  required String data,
  required void Function() onClick,
}) {
  return ListTile(
    onTap: onClick,
    leading: Icon(iconData, color: Get.theme.iconTheme.color),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          maxLines: 1,
          style: Get.textTheme.bodyMedium,
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Text(
            data,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontSize: (Get.textTheme.bodyMedium?.fontSize ?? 14) - 2,
            ),
          ),
        ),
      ],
    ),
  );
}
