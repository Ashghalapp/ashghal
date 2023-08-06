import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/verify_email_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/resend_email_verification_code.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/services/dependency_injection.dart' as di;

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
    // try {
      // String userToken = await SharedPrefs().getAuthorizationKey() ?? "";
      // if (userToken != "") {
      //   ApiResponseModel response= await ApiController()
      //       .verifyEmail(userToken: userToken, otpCode: verficationCode);
      //   if (response.status) {
      //     showSnackBar("", "Successfull registered and verified email");
      //     Get.offNamed(AppRoutes.succesSignUp);
      //   } else {
      //     showSnackBar("Error", response.message);
      //   }
      // } else {
      //   showSnackBar("Error", "There is something error.. Try later.");
      // }
    // } catch (e) {      
      // print("==========Error form verifyCode in controller: ${e.toString()}");
      // if (e is http.ClientException) {
      //   throw ApiError('Request failed: ${e.message}', '');
      // } else {
      //   throw ApiError('An error occurred during the request: $e', '');
      // }
    // }
  }

  Future resendVerificationCode() async {
    ResendEmailVerificationCodeUseCase resendEmailVerifyCode = di.getIt();
    (await resendEmailVerifyCode.call()).fold((failure) {
      AppUtil.showMessage(failure.message, Get.theme.colorScheme.error);
    }, (success) {
      AppUtil.showMessage(success.message, Colors.green);
      Get.offNamed(AppRoutes.succesSignUp);
    });
    // try{
      // String userToken = await SharedPrefs().getAuthorizationKey() ?? "";
      // if (userToken != "") {
      //   showSnackBar("", "Resending code...");
      //   ApiResponseModel response= await ApiController().resendVerificationCode(userToken: userToken);
      //   if (response.status) {
      //     showSnackBar("", response.message);
      //   } else {
      //     showSnackBar("Error", response.message);
      //   }
      // } else {
      //   showSnackBar("Error", "There is something error.. Try later.");
      // }
    // } catch (e) {      
      // print("==========Error form resendVerificationCode in controller: ${e.toString()}");
      // if (e is http.ClientException) {
      //   throw ApiError('Request failed: ${e.message}', '');
      // } else {
      //   throw ApiError('An error occurred during the request: $e', '');
      // }
    // }
  }
}
