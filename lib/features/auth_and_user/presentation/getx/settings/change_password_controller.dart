import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/change_password_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../../../../../core/services/dependency_injection.dart' as di;

import '../../../../../../../../core/localization/app_localization.dart';
import '../../../../../../../../core/util/app_util.dart';
// import '../../screens/success_screen.dart';

class ChangePasswordController extends GetxController {
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  GlobalKey<FormState> changePasswordFormKey = GlobalKey();
  // Rx<String?> errorPassword = Rx(null);
  RxBool isPasswordVisible = true.obs;
  RxBool isNewPasswordVisible = true.obs;

  @override
  void onInit() {
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void changPasswordVisible() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void changNewPasswordVisible() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  Future<void> submitChangePasswordButton() async {
    Get.focusScope?.unfocus();
    if (!(changePasswordFormKey.currentState?.validate() ?? false)) return;

    EasyLoading.show(status: AppLocalization.loading);
    ChangePasswordUseCase changePasswordUC = di.getIt();
    final result = changePasswordUC.call(
      confirmPasswordController.text,
    );

    // errorPassword.value = null;
    (await result).fold((failure) {
      if (failure.code == "E1024") {
        // errorPassword.value = failure.message;
      } else {
        AppUtil.hanldeAndShowFailure(failure);
      }
    }, (success) {
      AppUtil.showMessage(success.message, Colors.green);
      Get.off(() => SuccessScreen(
            message: AppLocalization.successChangePassword,
            buttonText: AppLocalization.back,
            onClick: () => Get.back(),
          ));
    });
    EasyLoading.dismiss();
  }
}
