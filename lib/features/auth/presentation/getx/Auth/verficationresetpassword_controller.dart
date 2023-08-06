import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../../core/constant/app_routes.dart';

import 'resetpassword_controller.dart';

class VerficationResetPasswordController extends GetxController {
  late String verficationCode;
  RxInt remainingSeconds = 60
      .obs; // Set the desired time interval in seconds (1 minute in this case)

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

  void resendCode() {
    // String email = Get.arguments['email'];
    // print(email);

    // AppUtil.checkInternet().then((hasInternet) async {
    //   EasyLoading.show(status: LocalizationString.loading);
    //   if (hasInternet) {
    //     await ApiController()
    //         .resendForgetPasswordCode(
    //       email: email,
    //     )
    //         .then((response) {
    //       EasyLoading.dismiss();
    //       debugPrint(
    //           '>>>>>>>>>>> The response message from resend code :${response.message}');
    //       debugPrint(
    //           '>>>>>>>>>>> The response status from resend code :${response.status}');
    //       if (response.status) {
    //         showMessage(response.message, isSuccess: true);
    //         remainingSeconds.value = 60; // Reset the timer to the initial value
    //         startTimer();
    //         update();
    //       } else {
    //         Map<String, dynamic>? errors = response.errors;

    //         if (response.errors != null &&
    //             response.errors is Map<String, dynamic>) {
    //           if (errors!.containsKey('email')) {
    //             showMessage(
    //               errors['email'][0],
    //             );
    //           }

    //           // Handle other fields' errors as needed
    //         } else {}
    //       }
    //     }).catchError((error) {
    //       EasyLoading.dismiss();
    //       debugPrint('Error: $error');
    //       showMessage(
    //         'An error occurred during the request.',
    //       );
    //     });
    //   } else {
    //     EasyLoading.dismiss();
    //     showMessage(
    //       'No internet connection',
    //     );
    //   }
    // });
  }

  checkCode(String otpCode) {
    // String email = Get.arguments['email'];
    // print(email);
    // print(otpCode);
    // AppUtil.checkInternet().then((hasInternet) async {
    //   EasyLoading.show(status: LocalizationString.loading);
    //   if (hasInternet) {
    //     await ApiController()
    //         .verifyResetPasswordCode(email: email, otpCode: otpCode)
    //         .then((response) {
    //       EasyLoading.dismiss();
    //       debugPrint(
    //           '>>>>>>>>>>> The response message from check opt :${response.message}');
    //       debugPrint(
    //           '>>>>>>>>>>> The response status from check opt :${response.status}');
    //       if (response.status) {
    //         showMessage(response.message, isSuccess: true);
    //         goToRestPassword(otpCode, email);
    //       } else {
    //         Map<String, dynamic>? errors = response.errors;
    //         debugPrint(
    //             '>>>>>>>>>>> The response errors from check opt :${response.errors}');
    //         if (response.errors != null &&
    //             response.errors is Map<String, dynamic>) {
    //           if (errors!.containsKey('email')) {
    //             showMessage(
    //               errors['email'][0],
    //             );
    //           }
    //           // Handle 'otp_code' errors
    //           if (errors.containsKey('otp_code')) {
    //             showMessage(
    //               errors['otp_code'][0],
    //             );
    //           }
    //           // Handle other fields' errors as needed
    //         } else {
    //           // if (response.message.contains('OTP is not valid')) {
    //           showMessage('OTP is not valid');
    //           // }else if(response.message.contains('OTP does not exist')){
    //           //     showMessage(
    //           //     'OTP does not exist',
    //           //   );
    //           // }
    //           // if (response.code == 'E00013') {
    //           //   showMessage(
    //           //     'Constriants violation, The given data is invalid.',
    //           //   );
    //           // }
    //         }
    //       }
    //     }).catchError((error) {
    //       EasyLoading.dismiss();
    //       debugPrint('Error: $error');
    //       showMessage(
    //         'An error occurred during the request.',
    //       );
    //     });
    //   } else {
    //     EasyLoading.dismiss();
    //     showMessage(
    //       'No internet connection',
    //     );
    //   }
    // });
  }

  // showMessage(String message, {bool? isSuccess}) {
  //   Get.snackbar(
  //     isSuccess == true ? LocalizationString.success : LocalizationString.error,
  //     message,
  //     backgroundColor: isSuccess == true ? Colors.green : Colors.red,
  //     colorText: Colors.white,
  //     duration: const Duration(seconds: 3),
  //   );
  // }

  goToRestPassword(String otpCode, String email) {
    Get.lazyPut(() => ResetPasswordController());
    Get.offNamed(AppRoutes.resetPassword,
        arguments: {'otpCode': otpCode, 'email': email});
  }
}
