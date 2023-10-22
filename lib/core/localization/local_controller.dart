import 'package:flutter/material.dart';

import 'package:get/get.dart';
// import '../../config/app_theme.dart';
import '../helper/shared_preference.dart';

class AppLocallcontroller extends GetxController {
  // Locale? language =Locale('ar');
  Locale? language;

  // ThemeData appTheme = enTheme;

  changLang(String langCode) {
    Locale local = Locale(langCode);
    SharedPref.setLanguage(langCode);

    // appTheme = langCode == "ar" ? arTheme : enTheme;
    // Get.changeTheme(appTheme);
    Get.updateLocale(local);
  }

  @override
  void onInit() {
    appLang();

    super.onInit();
  }

  appLang() async {
    if (SharedPref.getLanguage() == "ar") {
      language = const Locale("ar");
      // appTheme == arTheme;
    } else if (SharedPref.getLanguage() == "en") {
      language = const Locale("en");
      // appTheme = enTheme;
    } else {
      // appTheme = enTheme;
      language = Locale(Get.deviceLocale!.languageCode);
    }
  }
}
