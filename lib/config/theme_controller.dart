

import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    
    super.onInit();
    themeMode.value = SharedPref.getThemeMode();
    Get.changeThemeMode(themeMode.value);
  }

  void changeTheme(ThemeMode themeMode){
    SharedPref.setThemeMode(themeMode);
    Get.changeThemeMode(themeMode);
    printError(info: "<<<<${themeMode.name}");
  }
}
