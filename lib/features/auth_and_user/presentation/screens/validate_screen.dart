import 'package:ashghal_app_frontend/core/widget/app_scaffold_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/validate_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../../config/app_colors.dart';

import '../../../../core/localization/app_localization.dart';

import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';


class ValidateScreen extends StatelessWidget {
  final String message;
  final Function resendCodeFunction;
  final Future Function(String code) verifyCodeFunction;
  const ValidateScreen({
    super.key,
    required this.message,
    required this.resendCodeFunction,
    required this.verifyCodeFunction,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                AppLocalization.otpVerification,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 30
              ),
              Text(
                message,
                style: Get.textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Form(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: OtpTextField(
                          clearText: true,
                          focusedBorderColor: Theme.of(context).primaryColor,
                          fieldWidth: 50,
                          cursorColor: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          numberOfFields: 6,
                          borderColor: Theme.of(context).primaryColor,
                          //set to true to show as box or false to show as dash
                          showFieldAsBox: true,
                          //runs when every textfield is filled
                          onSubmit: (String verificationCode) async {
                            EasyLoading.show(status: AppLocalization.loading);
                            await verifyCodeFunction(verificationCode);
                            EasyLoading.dismiss();
                            // controller.checkCode(verificationCode);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GetBuilder<ValidateController>(
                        builder: (controller) {
                          RxInt remainingSeconds = controller.remainingSeconds;
                          return Column(
                            children: [
                              if (remainingSeconds.value <= 0)
                                TextButton(
                                  onPressed: () {
                                    controller.resendCode(resendCodeFunction);

                                    // controller.resendCode();
                                  },
                                  child: Text(
                                    'Resend Code',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              if (remainingSeconds.value > 0)
                                Obx(
                                  () => Text(
                                    'Resend code in ${remainingSeconds.value} seconds',
                                    style:
                                        TextStyle(color: AppColors.bodyDark1),
                                  ),
                                )
                            ],
                          );
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
