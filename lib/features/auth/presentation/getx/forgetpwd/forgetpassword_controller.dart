import 'package:ashghal_app_frontend/core/localization/localization_strings.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/reset_password_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/forget_password_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';

import '../../../../../config/app_routes.dart';

import '../../../../../core/util/app_util.dart';
import 'verficationresetpassword_controller.dart';
import '../../../../../core/services/dependency_injection.dart' as di;

class ForgetPasswordController extends GetxController {
  late TextEditingController emailController;
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey();

  checkEmail() async {
    if (!(forgetPasswordFormKey.currentState?.validate() ?? false)) return;
    EasyLoading.show(status: LocalizationString.loading);
    final forgetPasswordRequest =
        ForgetPasswordRequest.withEmail(email: emailController.text.trim());
    ForgetPasswordUseCase forgetPasswordUseCase =
        di.getIt<ForgetPasswordUseCase>();
    final result = await forgetPasswordUseCase(forgetPasswordRequest);

    result.fold(
      (failure) {        
        AppUtil.hanldeAndShowFailure(failure, prefixText: 'verify failed');
      },
      (success) {
        goToVerficationResetPassword(emailController.text);
      },
    );
    EasyLoading.dismiss();
  }

  goToVerficationResetPassword(String email) {
    Get.lazyPut(() => VerficationResetPasswordController());
    Get.offNamed(AppRoutes.verficationResetPassword,
        arguments: {'email': email});
  }

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
}
