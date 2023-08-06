import 'package:ashghal_app_frontend/features/auth/presentation/getx/login_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/getx/singup_controller.dart';
import '../localization/local_controller.dart';
import 'dependency_injection.dart';

class AppServices extends GetxService {
  late SharedPreferences prefs;

  // late SharedPreferences sharedPref;
  Future<AppServices> init() async {
    prefs = await SharedPreferences.getInstance();
    // Get.lazyPut(() => OnBoardingControllerImp());
    Get.lazyPut(() => MyLocalController());
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => LoginController());
    setupDependencies();

    return this;
  }
}

initialServices() async {
  await Get.putAsync(() => AppServices().init());
}
