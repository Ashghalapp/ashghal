
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/app_colors.dart';

import '../../../../../core/localization/localization_strings.dart';
import '../../../../../core/util/validinput.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../../../../core/widget/app_textformfield.dart';
import '../../getx/forgetpwd/resetpassword_controller.dart';





class ResetPasswordScreen extends GetView<ResetPasswordController> {
 
   const ResetPasswordScreen({super.key, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Reset',
          style: TextStyle(
            // fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.gray,
          ),
        ),
        leading: MyCircularIconButton(
          onPressed: () {
            // Get.back();
          },
          iconData: Icons.arrow_back_ios,
          iconColor: AppColors.gray,
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
                style: const TextStyle(color: AppColors.gray),
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
                                sufficxIconData: controller.isVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                obscureText: controller.isVisible,
                                onPressed: () => controller.changVisible(),
                                hintText: '34'.tr,
                                iconData: Icons.lock_clock_outlined,
                                lable: '35'.tr,
                                controller: controller.passwordController,
                                validator: (val) {
                                  return validInput(val!, 6, 50, 'password');
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              MyTextFormField(
                                sufficxIconData: controller.isConfirmVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                obscureText: controller.isConfirmVisible,
                                onPressed: () =>
                                    controller.changConfirmVisible(),
                                hintText: '41'.tr,
                                iconData: Icons.key_outlined,
                                lable: '42'.tr,
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
                        text: LocalizationString.submit,
                        color:Theme.of(context).primaryColor,
                        onTap: () {
                          controller.checkResetPassword();
                        },
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
