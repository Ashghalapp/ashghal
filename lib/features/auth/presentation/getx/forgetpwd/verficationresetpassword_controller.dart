import 'dart:async';

import 'package:ashghal_app_frontend/features/auth/domain/Requsets/reset_password_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/forget_password_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/verify_reset_password_code_uc.dart';
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
    final request = ForgetPasswordRequest.withEmail(
      email: email,
    );
    ForgetPasswordUseCase resendForgetPassCode = di.getIt();
    final result = await resendForgetPassCode(request);

    result.fold(
      (failure) {        
        AppUtil.hanldeAndShowFailure(failure, prefixText: 'Resend Code failed:');
      },
      (success) {
        AppUtil.showMessage(LocalizationString.success, Colors.greenAccent);
        remainingSeconds.value = 60; // Reset the timer to the initial value
        startTimer();
        update();
      },
    );
    EasyLoading.dismiss();
  }

  Future<void> checkCode(String code) async {
    String email = Get.arguments['email'];

    EasyLoading.show(status: LocalizationString.loading);
    final validateResetPassRequest =
        ValidateResetPasswordCodeRequest.withEmail(email: email, code: code);
    ValidateResetPasswordByEmailCode validateResetPassUC = di.getIt();
    final result =
        await validateResetPassUC(validateResetPassRequest);

    result.fold(
      (failure) {       
        AppUtil.hanldeAndShowFailure(failure, prefixText: 'verify Code failed:');
      },
      (success) {
        AppUtil.showMessage(LocalizationString.success, Colors.greenAccent);
        goToRestPassword(code, email);
      },
    );
     EasyLoading.dismiss();
  }

  goToRestPassword(String otpCode, String email) {
    Get.lazyPut(() => ResetPasswordController());
    Get.offNamed(AppRoutes.resetPassword,
        arguments: {'otpCode': otpCode, 'email': email});
  }
}
