import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/settings/change_email_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/localization/app_localization.dart';
import '../../../../../../core/util/validinput.dart';
import '../../../../../../core/widget/app_buttons.dart';
import '../../../../../../core/widget/app_textformfield.dart';

class ChangeEmailScreen extends GetView<ChangeEmailController> {
  const ChangeEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("<>>>>>>>>>>>>>>>>in forget screen>");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            SizedBox(height: Get.height * 0.2),
            Text(
              AppLocalization.changeYourEmail,
              textAlign: TextAlign.center,
              style: Get.textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalization.pleaseEnterNewEmail,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            Form(
              key: controller.verifyEmailFormKey,
              child: AppTextFormField(
                // labelText: AppLocalization.enterYourEmail,
                // iconName: Icons.email_outlined,
                iconName: AppIcons.email,
                hintText: AppLocalization.email,
                obscureText: false,
                controller: controller.emailController,
                validator: (val) {
                  return validInput(val!, 10, 50, 'email');
                },
                margin: const EdgeInsets.only(bottom: 20, top: 30),
              ),
            ),
            AppGesterDedector(
              text: AppLocalization.next,
              color: Theme.of(context).primaryColor,
              onTap: () => controller.submitVerifyEmailButton(),
            ),
          ],
        ),
      ),
    );
  }
}
