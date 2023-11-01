import 'package:get/get.dart';
import '../../../../../config/app_routes.dart';
import 'singup_controller.dart';

class ChooseUserTypeController extends GetxController {
  var isProviderSelected = false.obs;
  var isClientSelected = false.obs;

  void toggleProvider() {
   isProviderSelected.value =! isProviderSelected.value ;
    if ( isClientSelected.value ) {
       isClientSelected.value =! isClientSelected.value ;
   }
  }
  void toggleClient() {
   isClientSelected.value =! isClientSelected.value ;
   if ( isProviderSelected.value) {
        isProviderSelected.value =! isProviderSelected.value ;
   }
  }


  goToNextSignUp(bool isProvider) {
    Get.lazyPut(() => SignUpController());
    Get.toNamed(AppRoutes.signUp, arguments: {'isPorvider': isProvider});
  }
}
