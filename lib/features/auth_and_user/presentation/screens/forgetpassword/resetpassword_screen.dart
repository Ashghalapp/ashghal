import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/localization/app_localization.dart';
import '../../../../../core/util/validinput.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../../../../core/widget/app_textformfield.dart';
import '../../getx/forgetpwd/resetpassword_controller.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   title: const Text("Reset"),
      //   leading: MyCircularIconButton(
      //     onPressed: () {
      //       // Get.back();
      //     },
      //     iconData: Icons.arrow_back_ios,
      //     iconColor: AppColors.bodyDark1,
      //   ),
      // ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            SizedBox(height: Get.height * 0.15),
            Text(
              textAlign: TextAlign.center,
              AppLocalization.resetYourPassword.tr,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalization.pleaseEnterYourNewPasswordDownHere.tr,
              // style: TextStyle(color: AppColors.bodyDark1),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Form(
              key: controller.resetPasswordFormKey,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    GetBuilder<ResetPasswordController>(
                      init: ResetPasswordController(),
                      initState: (_) {},
                      builder: (_) {
                        return Column(
                          children: [
                            AppTextFormField(
                              sufficxIconDataName: controller.isVisible
                                  // ? Icons.visibility_off_outlined
                                  // : Icons.visibility_outlined,
                                  ? AppIcons.hide
                                  : AppIcons.show,
                              obscureText: controller.isVisible,
                              onSuffixIconPressed: () =>
                                  controller.changVisible(),
                              // labelText: '34'.tr,
                              // iconName: Icons.lock_clock_outlined,
                              iconName: AppIcons.lock,
                              hintText: AppLocalization.newPassword,
                              controller: controller.passwordController,
                              validator: (val) {
                                return validInput(val!, 6, 50, 'password');
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AppTextFormField(
                              sufficxIconDataName: controller.isConfirmVisible
                                  // ? Icons.visibility_off_outlined
                                  // : Icons.visibility_outlined,
                                  ? AppIcons.hide
                                  : AppIcons.show,
                              obscureText: controller.isConfirmVisible,
                              onSuffixIconPressed: () =>
                                  controller.changConfirmVisible(),
                              // labelText: '41'.tr,
                              iconName: AppIcons.lock,
                              // iconName: Icons.key_outlined,
                              hintText: AppLocalization.confirmPassword,
                              controller: controller.confirmPasswordController,
                              validator: (val) {
                                return validInput(
                                    val!, 6, 50, 'confirmpassword',
                                    confirmpassword:
                                        controller.passwordController.text);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    AppGesterDedector(
                      text: AppLocalization.submit,
                      color: Theme.of(context).primaryColor,
                      onTap: () => controller.checkResetPassword(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
