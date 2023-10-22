import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';
import '../../config/app_icons.dart';
import '../../core/localization/app_localization.dart';
import '../../core/util/validinput.dart';
import '../../core/widget/app_buttons.dart';
import '../../core/widget/app_textformfield.dart';
import 'getx/resetpassword_controller.dart';




class ResetertPasswordScreen extends GetView<ResetertPasswordController> {
  const ResetertPasswordScreen({
    super.key,
  });
// class Rest_password extends StatelessWidget {
//   const Rest_password({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "restart_password",
          style: TextStyle(
            color: Colors.black,
            // color: Colors.grey[700],
            fontFamily: 'Nunito',
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body:
          //  ListView(
          //   children: [
          //     Container(
          //       height: 100.0,
          //       decoration: const BoxDecoration(
          //         // color: Colors.blue,
          //         shape: BoxShape.circle,
          //       ),
          //       child: SizedBox(
          //         width: double.infinity,
          //         height: 100.0,
          //         child: Image.asset(
          //           "assets/images/jobs.jpg",
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Form(
          //           child: Column(
          //         children: [
          //           buildFieldWithLabel(label: "New Password", ),
          //           buildFieldWithLabel(
          //               label: "Password", isSecure: true,
          //               onClick: () => Get.to(() => EditAccountScreen())),
          //           buildFieldWithLabel(
          //               label: " Agen insert Password", isSecure: true),
          //           const SizedBox(height: 10),
          //           // const SizedBox(height: 14),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               buildButtonWidget(
          //                   text: "Save",
          //                   onClick: () => Get.to(() => EditAccountScreen())),
          //               buildButtonWidget(text: "Cancel", onClick: () {Get.back();}),
          //             ],
          //           ),
          //         ],
          //       )),
          //     )
          //   ],
          // ),
          ListView(
        children: [
          SizedBox(
            // height: 100.0,
            width: double.infinity,
            // decoration: const BoxDecoration(
            //   // color: Colors.blue,
            //   shape: BoxShape.circle,
            // ),
            child: SizedBox(
              width: double.infinity,
              // height: 100.0,
              child: Image.asset(
                "assets/images/jobs.jpg",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: controller.resetPasswordFormKey,
              child: GetX(
                builder: (ResetertPasswordController controller) {
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
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
                      !controller.Flage.value
                          ? Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: AppTextFormField(
                                    controller: controller.Email,
                                    hintText: '',
                                    lable: 'New Password',
                                    obscureText: true,
                                    textInputtype: TextInputType.phone,
                                    // onPressed: () {},
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    print("${controller.Email.text}********************");
                                    controller.check_email(controller.Email.text);
                                  },
                                  child: const Text(
                                    "Check ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          : controller.Flage.value
                              ? Column(
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
                                      hintText: '34'.tr,
                                      // iconName: Icons.lock_clock_outlined,
                                      iconName: AppIcons.lock,
                                      lable: AppLocalization.newPassword,
                                      controller: controller.passwordController,
                                      validator: (val) {
                                        return validInput(
                                            val!, 6, 50, 'password');
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    AppTextFormField(
                                      sufficxIconDataName:
                                          controller.isConfirmVisible
                                              // ? Icons.visibility_off_outlined
                                              // : Icons.visibility_outlined,
                                              ? AppIcons.hide
                                              : AppIcons.show,
                                      obscureText: controller.isConfirmVisible,
                                      onSuffixIconPressed: () =>
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
                                            confirmpassword: controller
                                                .passwordController.text);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    MyGesterDedector(
                                      text: AppLocalization.submit,
                                      color: Theme.of(context).primaryColor,
                                      onTap: () =>
                                          controller.checkResetPassword(),
                                    ),
                                  ],
                                )
                              : const Center(
                                  child: Text("Check Password"),
                                )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
