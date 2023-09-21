import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/reset_password_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/forget_password_uc.dart';
import 'package:ashghal_app_frontend/features/auth/presentation/screens/validate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';

import '../../../../../config/app_routes.dart';

import '../../../../../core/util/app_util.dart';
import '../../../domain/use_cases/verify_reset_password_code_uc.dart';
import '../../../../../core/services/dependency_injection.dart' as di;

class ForgetPasswordController extends GetxController {
  late TextEditingController emailController;
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey();

  @override
  void onInit() {
    emailController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> checkEmail() async {
    if (!(forgetPasswordFormKey.currentState?.validate() ?? false)) return;
    Get.focusScope?.unfocus();
    EasyLoading.show(status: AppLocalization.loading);
    final forgetPasswordRequest =
        ForgetPasswordRequest.withEmail(email: emailController.text.trim());
    ForgetPasswordUseCase forgetPasswordUseCase =
        di.getIt<ForgetPasswordUseCase>();
    final result = await forgetPasswordUseCase(forgetPasswordRequest);

    result.fold(
      (failure) {
        AppUtil.hanldeAndShowFailure(failure, prefixText: 'verify failed: ');
      },
      (success) {
        // go to verfication reset password screen
        // Get.offNamed(AppRoutes.verficationResetPassword,
        //     arguments: {'email': emailController.text});
        Get.to(
          () => ValidateScreen(
            message: "Please enter the code sent to your email to change your password".tr,
              resendCodeFunction: resendResetPasswordCode,
              submitCodeFunction: verifyResetPasswordCode),
          arguments: {'email': emailController.text},
        );
      },
    );
    EasyLoading.dismiss();
  }

  Future<bool> resendResetPasswordCode() async {
    String email = Get.arguments['email'];

    EasyLoading.show(status: AppLocalization.loading);
    final request = ForgetPasswordRequest.withEmail(
      email: email,
    );
    ForgetPasswordUseCase resendForgetPassCode = di.getIt();
    final result = await resendForgetPassCode(request);

    bool isResent = false;
    result.fold((failure) {
      AppUtil.hanldeAndShowFailure(failure, prefixText: 'Resend Code failed:');
      isResent = false;
    }, (success) {
      AppUtil.showMessage(AppLocalization.success, Colors.greenAccent);
      isResent = true;
    });
    EasyLoading.dismiss();
    return isResent;
  }

  Future<void> verifyResetPasswordCode(String code) async {
    String email = Get.arguments['email'];

    EasyLoading.show(status: AppLocalization.loading);
    final validateResetPassRequest =
        ValidateResetPasswordCodeRequest.withEmail(email: email, code: code);
    ValidateResetPasswordByEmailCode validateResetPassUC = di.getIt();
    final result = await validateResetPassUC(validateResetPassRequest);

    result.fold(
      (failure) {
        AppUtil.hanldeAndShowFailure(failure,
            prefixText: 'verify Code failed:');
      },
      (success) {
        AppUtil.showMessage(AppLocalization.success, Colors.greenAccent);
        // goToRestPassword(code, email);
        Get.offNamed(AppRoutes.resetPassword,
            arguments: {'otpCode': code, 'email': email});
      },
    );
    EasyLoading.dismiss();
  }
}
