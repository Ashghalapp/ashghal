
import 'package:ashghal/core/constant/app_theme.dart';
import 'package:ashghal/core/helper/shared_preference.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';



class MyLocalController extends GetxController {
  Locale? language;


  ThemeData appTheme = enTheme;

  changLang(String langCode) {
    Locale local = Locale(langCode);
    SharedPrefs().setLanguage(langCode);

    appTheme = langCode == "ar" ? arTheme : enTheme;
    Get.changeTheme(appTheme);
    Get.updateLocale(local);
  }

  @override
  void onInit() {
    appLang();

    super.onInit();
  }

  appLang() async {
    if ( SharedPrefs().getLanguage() == "ar") {
      language = const Locale("ar");
      appTheme == arTheme;
    } else if ( SharedPrefs().getLanguage() == "en") {
      language = const Locale("en");
      appTheme = enTheme;
    } else {
      appTheme = enTheme;
      language = Locale(Get.deviceLocale!.languageCode);
    }
  }
}
