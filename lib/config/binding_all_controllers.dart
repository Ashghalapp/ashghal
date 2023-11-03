import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/settings/change_email_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/account/current_user_account_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/settings/settings_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/settings/show_edit_profile_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/settings/show_edit_provider_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/Auth/login_controller.dart';
// import 'package:ashghal_app_frontend/features/auth/presentation/getx/forgetpwd/forgetpassword_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/forgetpwd/resetpassword_controller.dart';

import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/validate_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/add_update_post_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/post_controller.dart';
import 'package:ashghal_app_frontend/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/auth_and_user/presentation/getx/Auth/singup_controller.dart';
import '../features/auth_and_user/presentation/getx/forgetpwd/forgetpassword_controller.dart';
import '../features/onboarding/presentation/getx/onboarding_controller.dart';

class BindingAllControllers extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => LoginController(),
      fenix: true,
    );
    // Get.lazyPut(() => SuccessResetPasswordControllerImp(), fenix: true);
    Get.lazyPut(() => ResetPasswordController(), fenix: true);
    // Get.lazyPut(() => ValidateResetPasswordController(), fenix: true);
    Get.lazyPut(() => ForgetPasswordController(), fenix: true);
    Get.lazyPut(() => ValidateController(), fenix: true);

    Get.lazyPut(() => SignUpController(), fenix: true);
    // Get.lazyPut(() => VerficationSignUpController(), fenix: true);
    // Get.lazyPut(() => SuccessSignUpControllerImp(), fenix: true);
    Get.lazyPut(() => OnBoardingController(), fenix: true);

    /////////////////////////////////////
    Get.lazyPut(() => PostController(), fenix: true);
    Get.lazyPut(() => AddUpdatePostController(), fenix: true);
    Get.lazyPut(() => CurrentUserAccountController(), fenix: true);
    Get.lazyPut(() => ShowEditProfileController(), fenix: true);
    Get.lazyPut(() => ShowEditProviderController(), fenix: true);
    Get.lazyPut(() => ChangeEmailController(), fenix: true);

    Get.lazyPut(() => AppSearchController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
  }
}
