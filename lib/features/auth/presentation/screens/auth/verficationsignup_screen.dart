import 'package:ashghal_app_frontend/features/auth/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth/presentation/getx/Auth/singup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../../../../config/app_colors.dart';
import '../../widgets/my_appbartext.dart';

class VerficationSignUpScreen extends GetView<SignUpController> {
  const VerficationSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SignUpController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: MyAppBarText(
          text: 'verfication'.tr,
        ),
        // ignore: prefer_const_constructors
        // leading: MyCircularIconButton(
        //   onPressed: () {
        //     // Get.back();
        //   },
        //   iconData: Icons.arrow_back_ios,
        //   iconColor: AppColors.gray,
        // ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: ListView(
          children: [
            Text(
              textAlign: TextAlign.center,
              'Check Code',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Please Enter The Digit Code Sent To Your Account  ',
              style: TextStyle(color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Form(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    OtpTextField(
                      focusedBorderColor: Theme.of(context).primaryColor,
                      fieldWidth: 46,
                      cursorColor: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      numberOfFields: 6,
                      borderColor: Theme.of(context).primaryColor,
                      //set to true to show as box or false to show as dash
                      showFieldAsBox: true,
                      //runs when a code is typed in
                      onCodeChanged: (String code) async {
                        // PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        //   verificationId: verificationId,
                        //   smsCode: _otpController.text.trim(),
                        // );
                        // await _authController.signInWithPhoneNumber(code);
                      },
                      //runs when every textfield is filled
                      onSubmit: (String verificationCode) async {                        
                        controller.verifyCode(verificationCode);
                        print("/////////verificationCode:$verificationCode");
                      }, // end onSubmit
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(shadowColor: Colors.white),
                      onPressed: () => controller.resendCode(),
                      child: Text(
                        'Don\'t get The Code?',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
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
