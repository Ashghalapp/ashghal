
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../../../../config/app_colors.dart';
import '../../../../../core/util/app_util.dart';
import '../../getx/Auth/verficationsignup_controller.dart';
import '../../widgets/my_appbartext.dart';


class VerficationSignUpScreen extends GetView<VerficationSignUpController> {
  const VerficationSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => VerficationSignUpController());
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
             Text(
              'Please Enter The Digit Code Sent To Your Account  ',
              style: TextStyle(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Form(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    OtpTextField(
                      focusedBorderColor:Theme.of(context).primaryColor,
                      fieldWidth: 46,
                      cursorColor:Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      numberOfFields: 6,
                      borderColor:Theme.of(context).primaryColor,
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
                      onPressed: () {
                        try {
                          controller.resendVerificationCode();
                          // print("/////////$verificationCode");
                        } catch (e) {
                            AppUtil.         buildErrorDialog(
                              "There is something error!.. Try again.");
                        }
                      },
                      child:  Text(
                        'Don\'t get The Code?',
                        style: TextStyle(
                          color:Theme.of(context).primaryColor,
                        ),
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
