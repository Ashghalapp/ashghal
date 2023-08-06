
import 'package:ashghal/core/constant/app_colors.dart';
import 'package:ashghal/core/function/validinput.dart';
import 'package:ashghal/core/localization/localization_strings.dart';
import 'package:ashghal/core/widget/app_buttons.dart';
import 'package:ashghal/core/widget/app_textformfield.dart';
import 'package:ashghal/features/auth/presntaion/getx/Auth/forgetpassword_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';





class ForgetPassword extends GetView<ForgetPasswordController> {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
        LocalizationString.verify,
          style: const TextStyle(
            // fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.gray,
          ),
        ),
        leading: MyCircularIconButton(
          onPressed: () {
            Get.back();
          },
          iconData: Icons.arrow_back_ios,
          iconColor: AppColors.gray,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
               LocalizationString.checkEmail,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
               LocalizationString.enterYourEmailForOpt,
                style: const TextStyle(color: AppColors.gray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Form(
                key: controller.forgetPasswordFormKey,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      MyTextFormField(
                        hintText: LocalizationString.enterYourEmail,
                        iconData: Icons.email_outlined,
                        lable: LocalizationString.email,
                        obscureText: false,
                        controller: controller.emailController,
                        validator: (val) {
                          return validInput(val!, 10, 50, 'email');
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyGesterDedector(
                        text: LocalizationString.next,
                        color:Theme.of(context).primaryColor,
                        onTap: () => controller.checkEmail(),
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
