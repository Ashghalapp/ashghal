
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../../core/config/app_routes.dart';

import 'successresetpassword_controller.dart';

class ResetPasswordController extends GetxController {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  GlobalKey<FormState> resetPasswordFormKey = GlobalKey();
  bool isVisible = true;
  bool isConfirmVisible = true;

  checkResetPassword() async {
    // String otpCode = Get.arguments['otpCode'];
    // String email = Get.arguments['email'];
    // debugPrint('====================${otpCode + email}');
    // final valid = resetPasswordFormKey.currentState?.validate() ?? false;
    // if (valid) {
    //   resetPasswordFormKey.currentState?.save();
    //   final hasInternet = await AppUtil.checkInternet();
    //   if (hasInternet) {
    //     try {
    //       EasyLoading.show(status: 'loading');

    //      ResetPasswordRequest resetPasswordRequest=ResetPasswordRequest.withEmail(
    //         email: email,
    //         code: otpCode,
    //         newPassword: passwordController.text,
    //       );

    //       EasyLoading.dismiss();

    //       if (response.status) {
    //         debugPrint(
    //             '>>>>>>>>>>> The response data from restpwd is :${response.data}');
    //         debugPrint(
    //             '>>>>>>>>>>> The response message  from restpwd  is :${response.message}');
    //         debugPrint(
    //             '>>>>>>>>>>> The response code  from restpwd  is :${response.code}');

    //         showMessage(response.message, isSuccess: true);
    //         goToSuccessResetPassword();
    //       } else {
    //         debugPrint(
    //             '>>>>>>>>>>> The Error message from Reset pwd :${response.message}');
    //         handleError(response);
    //       }
    //     } catch (e) {
    //       EasyLoading.dismiss();
    //       handleError(null);
    //       debugPrint('Error: $e');
    //     }
    //   } else {
    //     showMessage('No internet connection');
    //   }
    // }
  }

 

  ///دالة لمعالجة الاخطاء
  // void handleError(ApiResponseModel? response) {
  //   if (response == null) {
  //     showMessage('Failed to Rest Password');
  //     return;
  //   }
  //   switch (response.code) {
  //     case 'S0011':
  //       // showMessage('" You cann\'t reset password, becuase your code is not verified before. Try verify the code, or send a valid code, or ask for a new code.');
  //       showMessage(response.message);
  //       break;

  //     case 'E00013':
  //       if (response.errors != null &&
  //           response.errors is Map<String, dynamic>) {
  //         // final errors = response.errors as Map<String, dynamic>;
  //         // Handle field errors here if needed
  //         if (response.errors != null &&
  //             response.errors is Map<String, dynamic>) {
  //           Map<String, dynamic>? errors = response.errors;

  //           if (errors!.containsKey('email')) {
  //             showMessage(
  //               errors['email'][0],
  //             );
  //           }

  //           if (errors.containsKey('otp_code')) {
  //             showMessage(
  //               errors['otp_code'][0],
  //             );
  //           }
  //           // Handle other fields' errors as needed
  //         } else {
  //           showMessage(response.message);
  //         }
  //       }
  //   }
  // }

  goToSuccessResetPassword() {
    Get.lazyPut(() => SuccessResetPasswordControllerImp());
    Get.offAllNamed(AppRoutes.succesResetPassword);
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

  changVisible() {
    isVisible = !isVisible;
    update();
  }

  changConfirmVisible() {
    isConfirmVisible = !isConfirmVisible;
    update();
  }
}
