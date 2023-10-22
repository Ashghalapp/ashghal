import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../core/localization/app_localization.dart';
import '../../auth/domain/Requsets/reset_password_request.dart';


// TextEditingController? Email;
class RestartEmailController extends GetxController {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
// TextEditingController Email = TextEditingController();

  GlobalKey<FormState> resetPasswordFormKey = GlobalKey();
  bool isVisible = true;
  bool isConfirmVisible = true;
  TextEditingController Email = TextEditingController();
  String Password = '123';
  Rx<bool> Flage = false.obs;
  void check_email(String password) {
    if (password == Password) {
      Flage.value = true;
    } else {
      Flage.value = false;
      Get.snackbar("erorr", "كلمة السر غير صحيحه ");
    }
  }

  @override
  void onInit() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> checkResetPassword() async {
    String code = Get.arguments['otpCode'];
    String email = Get.arguments['email'];

    if (!(resetPasswordFormKey.currentState?.validate() ?? false)) return;
    Get.focusScope!.unfocus();

    EasyLoading.show(status: AppLocalization.loading);
    final resetPasswordRequest = ResetPasswordRequest.withEmail(
      email: email,
      code: code,
      newPassword: passwordController.text.trim(),
    );
    // RestartEmailController
    //   ResetPasswordUseCase resetPasswordUseCase = di.getIt();
    //   final result = await resetPasswordUseCase(resetPasswordRequest);
    //   result.fold(
    //     (failure) {
    //       AppUtil.hanldeAndShowFailure(failure,
    //           prefixText: 'Reset Password failed:');
    //     },
    //     (success) {
    //       AppUtil.showMessage(AppLocalization.success, Colors.greenAccent);
    //       // go to successResetPassword screen
    //       Get.offAll(() =>
    //           const SuccesResetPassword(message: "Successfully reset password"));
    //     },
    //   );
    //   EasyLoading.dismiss();
    // }

    changVisible() {
      isVisible = !isVisible;
      update();
    }

    changConfirmVisible() {
      isConfirmVisible = !isConfirmVisible;
      update();
    }
  }
}
