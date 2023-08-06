


import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../../config/app_colors.dart';

import '../../../../../core/localization/localization_strings.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../getx/forgetpwd/successresetpassword_controller.dart';





class SuccesResetPassword extends GetView<SuccessResetPasswordControllerImp> {
  const SuccesResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
        LocalizationString.success,
          style: const TextStyle(
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
             Center(
              child: Icon(
                Icons.check_circle_outline,
                size: 200,
                color:Theme.of(context).primaryColor,
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              LocalizationString.successResetPassword,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  height: 2,
                  color: Colors.grey),
            ),
            const SizedBox(
              height: 40,
            ),
            MyGesterDedector(
              text: LocalizationString.signIn,
              onTap: () {
                controller.goToLogIn();
              },
            )
          ],
        ),
      ),
    );
  }
}
