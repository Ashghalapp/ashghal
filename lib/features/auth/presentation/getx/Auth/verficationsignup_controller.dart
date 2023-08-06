
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class VerficationSignUpController extends GetxController {

  
  Future verifyCode(String verficationCode) async {
    try {
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
    } catch (e) {      
      // print("==========Error form verifyCode in controller: ${e.toString()}");
      // if (e is http.ClientException) {
      //   throw ApiError('Request failed: ${e.message}', '');
      // } else {
      //   throw ApiError('An error occurred during the request: $e', '');
      // }
    }
  }

  Future resendVerificationCode() async {
    try{
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
    } catch (e) {      
      // print("==========Error form resendVerificationCode in controller: ${e.toString()}");
      // if (e is http.ClientException) {
      //   throw ApiError('Request failed: ${e.message}', '');
      // } else {
      //   throw ApiError('An error occurred during the request: $e', '');
      // }
    }
  }
}
