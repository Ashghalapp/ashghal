import 'package:flutter/material.dart';

import 'package:get/get.dart';
// import '../../config/app_theme.dart';
import '../helper/shared_preference.dart';

class AppLocallcontroller extends GetxController {
  // Locale? language =Locale('ar');
  // Locale? language;

  Locale initialLang = SharedPref.getLanguage() == null
      ? Get.deviceLocale ?? const Locale('en')
      : Locale(SharedPref.getLanguage()!);

  void changeLanguage(String langCode) {
    Locale locale = Locale(langCode);
    SharedPref.setLanguage(langCode);
    Get.updateLocale(locale);
  }

  static String get language {
    return (SharedPref.getLanguage() == null
            ? Get.deviceLocale ?? const Locale('en')
            : Locale(SharedPref.getLanguage()!))
        .languageCode;
  }

  // // ThemeData appTheme = enTheme;

  // changLang(String langCode) {
  //   Locale local = Locale(langCode);
  //   SharedPref.setLanguage(langCode);

  //   // appTheme = langCode == "ar" ? arTheme : enTheme;
  //   // Get.changeTheme(appTheme);
  //   Get.updateLocale(local);
  // }

  // @override
  // void onInit() {
  //   appLang();

  //   super.onInit();
  // }

  // appLang() async {
  //   if (SharedPref.getLanguage() == "ar") {
  //     language = const Locale("ar");
  //     // appTheme == arTheme;
  //   } else if (SharedPref.getLanguage() == "en") {
  //     language = const Locale("en");
  //     // appTheme = enTheme;
  //   } else {
  //     // appTheme = enTheme;
  //     language = Locale(Get.deviceLocale!.languageCode);
  //   }
  // }
}
