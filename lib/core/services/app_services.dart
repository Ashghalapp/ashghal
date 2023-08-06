import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppServices extends GetxService {
  late SharedPreferences prefs;

  // late SharedPreferences sharedPref;
  Future<AppServices> init() async {
    prefs = await SharedPreferences.getInstance();
    // Get.lazyPut(() => OnBoardingControllerImp());
    // Get.lazyPut(() => MyLocalController());
// Get.lazyPut(() => SignUpController());

    return this;
  }
}

initialServices() async {
  await Get.putAsync(() => AppServices().init());
}
