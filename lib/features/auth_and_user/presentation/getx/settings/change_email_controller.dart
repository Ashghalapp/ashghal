import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/dependency_injection.dart'
    as di;
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/settings/settings_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/add_or_change_email_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/check_email_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/validate_email_code_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/add_or_change_email_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/check_email_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/send_email_verification_code_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/validate_email_code_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/success_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/validate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ChangeEmailController extends GetxController {
  late TextEditingController emailController;

  late GlobalKey<FormState> verifyEmailFormKey;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    verifyEmailFormKey = GlobalKey();
  }

   @override
  void onClose() {
    super.onInit();
    emailController.dispose();
  }

  Future<void> submitVerifyEmailButton() async {
    if (!(verifyEmailFormKey.currentState?.validate() ?? false)) return;
    EasyLoading.show(status: AppLocalization.loading);
    // final isSend = await sendEmailCode();
    final isSend = await checkEmail();
    if (isSend) {
      Get.to(() => ValidateScreen(
            message: AppLocalization.pleaseEnterVerifyEmailCode,
            resendCodeFunction: checkEmail,
            verifyCodeFunction: verifyEmailCode,
          ));
    }
    EasyLoading.dismiss();
  }

  Future<bool> sendEmailCode() async {
    final SendEmailVerificationCodeUseCase sendEmailCodeUS = di.getIt();
    return (await sendEmailCodeUS.call(emailController.text)).fold(
      (failure) {
        AppUtil.hanldeAndShowFailure(failure);
        return false;
      },
      (success) {
        AppUtil.showMessage(success.message, Colors.greenAccent);
        return true;
      },
    );
  }

  /// function to check the email if not used before and send code to it
  Future<bool> checkEmail() async {
    CheckEmailUseCase checkEmail = di.getIt();
    CheckEmailRequest request = CheckEmailRequest(
      email: emailController.text,
      userName: SharedPref.getCurrentUserBasicData()?['name'],
    );

    return (await checkEmail.call(request)).fold(
      (failure) {
        AppUtil.hanldeAndShowFailure(failure);
        return false;
      },
      (success) {
        AppUtil.showMessage(success.message, Colors.green);
        return true;
      },
    );
  }

  /// function use to send email verification code request to api
  Future<void> verifyEmailCode(String otpCode) async {
    final ValidateEmailCodeUseCase verifyEmailUS = di.getIt();
    final result = verifyEmailUS.call(
      ValidateEmailCodeRequest(email: emailController.text, code: otpCode),
    );
    (await result).fold(
      (failure) {
        AppUtil.hanldeAndShowFailure(failure);
      },
      (success) {
        printError(info: "<<<<<<<<<<finish verify");
        changeEmail(otpCode);
      },
    );
  }

  /// function use to change the email after verify it 
  Future<void> changeEmail(String otpCode) async {
    AddOrChangeEmailUseCase changeEmialUC = di.getIt();
    final result = changeEmialUC.call(AddOrChangeEmailRequest(
      newEmail: emailController.text,
      emailVerificationCode: otpCode,
    ));

    (await result).fold(
      (failure) {
        AppUtil.hanldeAndShowFailure(failure);
      },
      (success) {
        AppUtil.showMessage(success.message, Colors.green);
        final user = SharedPref.getCurrentUserData();
        user!.email = emailController.text;
        SharedPref.setCurrentUserData(user as UserModel);
        Get.off(() => SuccessScreen(
              message: AppLocalization.successChangePassword,
              buttonText: AppLocalization.back,
              onClick: () {
                Get.back();
                Get.back();
                Get.back();
              },
            ));
      },
    );
  }
}
