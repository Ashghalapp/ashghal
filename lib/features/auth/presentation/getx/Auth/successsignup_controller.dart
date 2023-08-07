import 'package:get/get.dart';
import '../../../../../config/app_routes.dart';
import 'login_controller.dart';



class SuccessSignUpControllerImp extends GetxController {
  goToLogIn() {
    Get.lazyPut(() => LoginController());
    Get.offNamed(AppRoutes.logIn);
  }
}
