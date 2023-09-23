import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/app_colors.dart';

import '../../../../../core/localization/app_localization.dart';
import '../../../../../core/util/validinput.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../../../../core/widget/app_textformfield.dart';
import '../../getx/forgetpwd/resetpassword_controller.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Reset',
          style: TextStyle(
            // fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.bodyDark1,
          ),
        ),
        leading: MyCircularIconButton(
          onPressed: () {
            // Get.back();
          },
          iconData: Icons.arrow_back_ios,
          iconColor: AppColors.bodyDark1,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                '40'.tr,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '43'.tr,
                style: TextStyle(color: AppColors.bodyDark1),
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
                              MyTextFormField(
                                sufficxIconDataName: controller.isVisible
                                    // ? Icons.visibility_off_outlined
                                    // : Icons.visibility_outlined,
                                    ? AppIcons.hide
                                    : AppIcons.show,
                                obscureText: controller.isVisible,
                                onPressed: () => controller.changVisible(),
                                hintText: '34'.tr,
                                // iconName: Icons.lock_clock_outlined,
                                iconName: AppIcons.lock,
                                lable: AppLocalization.newPassword,
                                controller: controller.passwordController,
                                validator: (val) {
                                  return validInput(val!, 6, 50, 'password');
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              MyTextFormField(
                                sufficxIconDataName: controller.isConfirmVisible
                                    // ? Icons.visibility_off_outlined
                                    // : Icons.visibility_outlined,
                                    ? AppIcons.hide
                                    : AppIcons.show,
                                obscureText: controller.isConfirmVisible,
                                onPressed: () =>
                                    controller.changConfirmVisible(),
                                hintText: '41'.tr,
                                iconName: AppIcons.lock,
                                // iconName: Icons.key_outlined,
                                lable: AppLocalization.confirmPassword,
                                controller:
                                    controller.confirmPasswordController,
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
                      const SizedBox(
                        height: 20,
                      ),
                      MyGesterDedector(
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
      ),
    );
  }
}
