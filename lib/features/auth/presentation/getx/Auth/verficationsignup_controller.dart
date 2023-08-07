import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/verify_email_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/resend_email_verification_code.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/app_routes.dart';
import '../../../../../core/localization/localization_strings.dart';
import '../../../../../core/services/dependency_injection.dart' as di;

class VerficationSignUpController extends GetxController {  
  Future verifyCode(String verficationCode) async {
    VerifyEmailUseCase verifyEmail= di.getIt();
    VerifyEmailRequest request = VerifyEmailRequest(code: verficationCode);
    (await verifyEmail.call(request)).fold((failure) {
      AppUtil.showMessage(failure.message, Get.theme.colorScheme.error);
    }, (success) {
      AppUtil.showMessage(success.message, Colors.green);
      Get.offNamed(AppRoutes.succesSignUp);
    });
  }

  Future resendVerificationCode() async {
    ResendEmailVerificationCodeUseCase resendEmailVerifyCode = di.getIt();
    AppUtil.showMessage(LocalizationString.resendingCode, Colors.green);
    (await resendEmailVerifyCode.call()).fold((failure) {
      AppUtil.showMessage(failure.message, Get.theme.colorScheme.error);
    }, (success) {
      AppUtil.showMessage(success.message, Colors.green);
    });
  }
}
