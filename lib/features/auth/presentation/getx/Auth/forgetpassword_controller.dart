
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../../core/constant/app_routes.dart';
import '../../../../../core/util/app_util.dart';
import 'verficationresetpassword_controller.dart';



class ForgetPasswordController extends GetxController {
  late TextEditingController emailController;
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey();

  checkEmail() async {
    final valid = forgetPasswordFormKey.currentState?.validate() ?? false;
    if (valid) {
      forgetPasswordFormKey.currentState?.save();
      final hasInternet = await AppUtil.checkInternet();
      if (hasInternet) {
     
    }
  }
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
