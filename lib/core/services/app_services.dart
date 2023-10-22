import 'package:ashghal_app_frontend/config/app_theme.dart';
import 'package:ashghal_app_frontend/core/localization/local_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dependency_injection.dart';

class AppServices extends GetxService {
  late SharedPreferences prefs;
 late ThemeData apptheme ;
  // late SharedPreferences sharedPref;
  Future<AppServices> init() async {
    prefs = await SharedPreferences.getInstance();

    // prefs.setString('authKey', "1|lAaMrRzYbX5iVFgocDYMLQK2aKFBwdq3mZUYvD8U6510413a");
    // prefs.setString("current_user_data", jsonEncode({'id': '1', 'name': 'hezbr al-humaidi'}));

    // Get.lazyPut(() => OnBoardingControllerImp());
    Get.lazyPut(() => AppLocallcontroller());
    // Get.lazyPut(() => SignUpController());
    // Get.lazyPut(() => LoginController());
    setupDependencies();
     apptheme = AppTheme.lightTheme;
    return this;
  }
}

initialServices() async {
  await Get.putAsync(() => AppServices().init());
}
