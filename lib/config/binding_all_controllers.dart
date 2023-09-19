import 'package:ashghal_app_frontend/features/auth/presentation/getx/Auth/login_controller.dart';
// import 'package:ashghal_app_frontend/features/auth/presentation/getx/forgetpwd/forgetpassword_controller.dart';
import 'package:ashghal_app_frontend/features/auth/presentation/getx/forgetpwd/resetpassword_controller.dart';
import 'package:ashghal_app_frontend/features/auth/presentation/getx/forgetpwd/verficationresetpassword_controller.dart';
import 'package:ashghal_app_frontend/features/auth/presentation/getx/Auth/singup_controller.dart';
import 'package:ashghal_app_frontend/features/auth/presentation/getx/Auth/successsignup_controller.dart';
import 'package:ashghal_app_frontend/features/auth/presentation/getx/Auth/verficationsignup_controller.dart';
import 'package:ashghal_app_frontend/features/auth/presentation/screens/forgetpassord/successresetpassword.dart';
import 'package:get/get.dart';

import '../features/auth/presentation/getx/forgetpwd/forgetpassword_controller.dart';

class BindingAllControllers extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(), fenix: true);
    // Get.lazyPut(() => ForgetPasswordController(), fenix: true);
    Get.lazyPut(() => ResetPasswordController(), fenix: true);
    Get.lazyPut(() => VerficationResetPasswordController(), fenix: true);
    Get.lazyPut(() => const SuccesResetPassword(), fenix: true);
    Get.lazyPut(() => ForgetPasswordController(), fenix: true);

    Get.lazyPut(() => SignUpController(), fenix: true);
    // Get.lazyPut(() => VerficationSignUpController(), fenix: true);
    Get.lazyPut(() => SuccessSignUpControllerImp(), fenix: true);
  }
}