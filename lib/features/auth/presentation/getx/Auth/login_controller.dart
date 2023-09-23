import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../../config/app_routes.dart';
import '../../../../../core/localization/localization_strings.dart';
import '../../../../../core/services/dependency_injection.dart' as di;
import '../../../domain/Requsets/login_request.dart';
import '../../../domain/use_cases/login_uc.dart';

class LoginController extends GetxController {
  bool isVisible = true;
  bool isLoading = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    emailController.text = "hezbr2@gmail.com";
    passwordController.text = "123456";
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  getData() async {
    // CancelToken c= CancelToken(); 
    try {
      Dio d = Dio(BaseOptions(
          method: 'get',
          // persistentConnection: false,
          // connectTimeout: Duration(seconds: 15),
          // receiveDataWhenStatusError: false,
          // followRedirects: false,
          contentType: "Application/json"));
      d.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
      var result = await d.get(
        "https://10.0.2.2:8000/user/get",
      ).timeout(const Duration(seconds: 10));
      // var result = await d.get(
      //   "https://10.0.2.2:8000/user/get",
      // ).timeout(Duration(seconds: 10));
    } on DioExceptionType catch(e){
      print("eeeeeeeeeeeeeeee$e");
      throw Exception("eEEEEEEEEEEEEEEEEEEEEx");
    } 
    on DioException catch (e) {
      print(">>>>>>>>>>>>>$e");
      throw Exception("eEEEEEEEEEEEEEEEEEEEEx");
    } catch (e) {
      print("<<<<<<<<<<<<<<<$e>>>>>>>>>>>>>>>");
      // throw Exception("eEEEEEEEEEEEEEEEEEEEEx$e");
    }
  }

  /// تسجيل الدخول
  void login() async {
    // await getData();
    // return;
    if (!(loginFormKey.currentState?.validate() ?? false)) return;
    Get.focusScope!.unfocus();

    EasyLoading.show(status: LocalizationString.loading);
    final loginRequest = LoginRequest.withEmail(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    print(loginRequest.toJson());

    LoginUseCase loginUseCase = di.getIt();
    (await loginUseCase.call(loginRequest)).fold(
      (failure) {
        AppUtil.hanldeAndShowFailure(failure);
      },
      (user) {
        AppUtil.showMessage(
            LocalizationString.successloggedIn.tr, Colors.green);
        SharedPref.setUserLoggedIn(true);
        // go to home screen
        Get.offAllNamed(AppRoutes.testScreen);
      },
    );
    EasyLoading.dismiss();
  }

  changVisible() {
    isVisible = !isVisible;
    update();
  }

  changLoading() {
    isLoading = !isLoading;
    update();
  }
}
