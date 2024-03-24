import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_icons.dart';
import '../../../../../core/localization/app_localization.dart';
import '../../../../../core/util/validinput.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../../../../core/widget/app_textformfield.dart';
import '../../getx/settings/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: Get.height * 0.15),
          Container(
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.only(top: 30, bottom: 5),
            child: Text(
              AppLocalization.changeYourPassword,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Container(
            alignment: AlignmentDirectional.center,
            margin: const EdgeInsets.all(10),
            child: Text(
              AppLocalization
                  .pleaseEnterOldPasswordThenNewPasswordThenConfirmIt.tr,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Form(
              key: controller.changePasswordFormKey,
              child: GetX<ChangePasswordController>(
                init: ChangePasswordController(),
                builder: (controller) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // // old password
                      // AppTextFormField(
                      //   sufficxIconDataName: controller.isPasswordVisible.value
                      //       ? AppIcons.hide
                      //       : AppIcons.show,
                      //   obscureText: controller.isPasswordVisible.value,
                      //   onSuffixIconPressed: () =>
                      //       controller.changPasswordVisible(),
                      //   controller: controller.passwordController,
                      //   labelText: AppLocalization.oldPassword,
                      //   hintText: AppLocalization.enterOldPassword,
                      //   padding: const EdgeInsets.symmetric(horizontal: 15),
                      //   validator: (val) => validInput(val!, 6, 30, 'password'),
                      //   errorText: controller.errorPassword.value,
                      //   // margin: const EdgeInsets.only(bottom: 15),
                      // ),
      
                      // // forget password
                      // Container(
                      //   alignment: AlignmentDirectional.centerEnd,
                      //   child: TextButton(
                      //     onPressed: () {
                      //       controller.changePasswordFormKey.currentState
                      //           ?.reset();
                      //       Get.toNamed(AppRoutes.forgetPassword);
                      //     },
                      //     child: Text(
                      //       AppLocalization.forgetPassword,
                      //       style: Get.textTheme.labelMedium,
                      //     ),
                      //   ),
                      // ),
      
                      // new password
                      AppTextFormField(
                        sufficxIconDataName:
                            controller.isNewPasswordVisible.value
                                ? AppIcons.hide
                                : AppIcons.show,
                        obscureText: controller.isNewPasswordVisible.value,
                        onSuffixIconPressed: () =>
                            controller.changNewPasswordVisible(),
                        controller: controller.newPasswordController,
                        labelText: AppLocalization.newPassword,
                        hintText: AppLocalization.enterNewPassword,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.only(bottom: 20, top: 15),
                        validator: (val) => validInput(val!, 6, 30, 'password'),
                      ),
      
                      // confirm new password
                      AppTextFormField(
                        sufficxIconDataName:
                            controller.isNewPasswordVisible.value
                                ? AppIcons.hide
                                : AppIcons.show,
                        obscureText: controller.isNewPasswordVisible.value,
                        onSuffixIconPressed: () =>
                            controller.changNewPasswordVisible(),
                        controller: controller.confirmPasswordController,
                        labelText: AppLocalization.confirmPassword,
                        hintText: AppLocalization.enterConfirmPassword,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.only(bottom: 15),
                        validator: (val) => validInput(
                            val!, 6, 30, 'confirmpassword',
                            confirmpassword:
                                controller.newPasswordController.text),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AppGesterDedector(
              onTap: () => controller.submitChangePasswordButton(),
              text: AppLocalization.changePassword,
            ),
          ),
        ],
      ),
    );
  }
}
