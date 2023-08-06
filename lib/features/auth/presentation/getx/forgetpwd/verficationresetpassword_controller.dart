import 'dart:async';

import 'package:ashghal_app_frontend/features/auth/domain/Requsets/reset_password_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/resend_forget_password_code.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/verify_reset_password_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../../core/services/dependency_injection.dart' as di;
import '../../../../../config/app_routes.dart';

import '../../../../../core/localization/localization_strings.dart';
import '../../../../../core/util/app_util.dart';
import 'resetpassword_controller.dart';

class VerficationResetPasswordController extends GetxController {
  late String verficationCode;
  RxInt remainingSeconds = 60.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds.value--;

      if (remainingSeconds.value <= 0) {
        _timer?.cancel();
        update();
      }
    });
  }

  void resendCode() async {
    String email = Get.arguments['email'];

    EasyLoading.show(status: LocalizationString.loading);
    final resendForgetPasswordCodeRequest = ForgetPasswordRequest.withEmail(
      email: email,
    );
    ResendForgetPasswordCodeUseCase resendForgetPasswordCodeUseCase =
        di.getIt<ResendForgetPasswordCodeUseCase>();
    final result =
        await resendForgetPasswordCodeUseCase(resendForgetPasswordCodeRequest);

    result.fold(
      (failure) {
        EasyLoading.dismiss();
        AppUtil.showMessage(
            'Resnd Code failed:  ${failure.message}', Colors.red);
      },
      (success) {
        AppUtil.showMessage(LocalizationString.success, Colors.greenAccent);
        remainingSeconds.value = 60; // Reset the timer to the initial value
        startTimer();
        update();
        EasyLoading.dismiss();
      },
    );
  }

  checkCode(String code) async {
    String email = Get.arguments['email'];

    EasyLoading.show(status: LocalizationString.loading);
    final verifyResetPasswordCodeRequest =
        VerifyResetPasswordCodeRequest.withEmail(email: email, code: code);
    VerifyResetPasswordCodeUseCase verifyResetPasswordCodeUseCase =
        di.getIt<VerifyResetPasswordCodeUseCase>();
    final result =
        await verifyResetPasswordCodeUseCase(verifyResetPasswordCodeRequest);

    result.fold(
      (failure) {
        EasyLoading.dismiss();
        AppUtil.showMessage(
            'verify Code failed:  ${failure.message}', Colors.red);
      },
      (success) {
          AppUtil.showMessage(LocalizationString.success, Colors.greenAccent);
        goToRestPassword(code, email);
        EasyLoading.dismiss();
      },
    );
  }

  goToRestPassword(String otpCode, String email) {
    Get.lazyPut(() => ResetPasswordController());
    Get.offNamed(AppRoutes.resetPassword,
        arguments: {'otpCode': otpCode, 'email': email});
  }
}
