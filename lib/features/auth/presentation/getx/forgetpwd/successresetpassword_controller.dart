import 'package:get/get.dart';



import '../../../../../config/app_routes.dart';

import '../Auth/login_controller.dart';

abstract class SuccessResetPasswordController extends GetxController {
  goToLogIn();
}

class SuccessResetPasswordControllerImp extends SuccessResetPasswordController {
  @override
  goToLogIn() {
    Get.lazyPut(() => LoginController());
    Get.offNamed(AppRoutes.logIn);
  }
}
