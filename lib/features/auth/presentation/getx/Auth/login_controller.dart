import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../../config/app_routes.dart';
import '../../../../../core/localization/app_localization.dart';
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
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// تسجيل الدخول
  void login() async {
    if (!(loginFormKey.currentState?.validate() ?? false)) return;
    Get.focusScope!.unfocus();

    EasyLoading.show(status: AppLocalization.loading);
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
            AppLocalization.successloggedIn.tr, Colors.green);
        SharedPref.setUserLoggedIn(true);
        // go to home screen
        Get.offAllNamed(AppRoutes.mainScreen);
      },
    );
    EasyLoading.dismiss();
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

  changVisible() {
    isVisible = !isVisible;
    update();
  }

  // goToHomeScreen() {
  //   // Get.lazyPut<MainScreenControllerImp>(() => MainScreenControllerImp());
  //   Get.toNamed(AppRoutes.testScreen);
  //   // // changLoading();
  //   //     print('home screen $isLoading');
  // }

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
