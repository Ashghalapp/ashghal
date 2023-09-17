import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../../config/app_routes.dart';
import '../../../../../core/localization/localization_strings.dart';
import '../../../../../core/services/dependency_injection.dart' as di;
import '../../../domain/Requsets/login_request.dart';
import '../../../domain/use_cases/login.dart';



class LoginController extends GetxController {
  bool isVisible = true;
  bool isLoading = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  ///تسجيل الدخول
  void login() async {
    final valid = loginFormKey.currentState?.validate() ?? false;
    if (valid) {
      EasyLoading.show(status: LocalizationString.loading);
      final loginRequest = LoginRequest.withEmail(
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
      );

      LoginUseCase loginUseCase = di.getIt<LoginUseCase>();

      final result = await loginUseCase(loginRequest);

      result.fold(
        (failure) {
          EasyLoading.dismiss();
          AppUtil.showMessage('Login failed:  ${failure.message}', Colors.red);
        },
        (user) {
          SharedPref.setUserLoggedIn(true);
          EasyLoading.dismiss();
          goToHomeScreen();
        },
      );
    }
  }

  ///
  // goToSignUp() {
  //   Get.lazyPut(() => SignUpController());
  //   Get.offNamed(AppRoutes.signUp);
  // }

  // goToForgetpassword() {
  //   Get.lazyPut(() => ForgetPasswordController());
  //   Get.toNamed(AppRoutes.forgetPassword);
  // }

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  changVisible() {
    isVisible = !isVisible;
    update();
  }

  goToHomeScreen() {
    // Get.lazyPut<MainScreenControllerImp>(() => MainScreenControllerImp());
    Get.toNamed(AppRoutes.testScreen);
    // // changLoading();
    //     print('home screen $isLoading');
  }

  changLoading() {
    isLoading = !isLoading;
    update();
  }

  // goToChooseTypeUser() {
  //   // Get.lazyPut(() => ChooseUserTypeControllerImp());
  //   Get.offNamed(AppRoutes.chooseUserTypeScreen);
  // }

  // enterAsGuest() {
  //   // SharedPrefs().setUserLoggedInAsGuest(true);
  //   // SharedPrefs().setUserLoggedIn(true);

  //   // Get.lazyPut(() => MainScreenController());
  //   Get.offNamed(AppRoutes.mainScreen);
  // }
}
