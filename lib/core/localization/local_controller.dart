import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
// import '../../config/app_theme.dart';
import '../helper/shared_preference.dart';

class AppLocallcontroller extends GetxController {
  // Locale? language =Locale('ar');
  // Locale? language;

  Locale initialLang =
      (SharedPref.getLanguage() == null || SharedPref.getLanguage() == "sys")
          ? Get.deviceLocale ?? const Locale('en')
          : Locale(SharedPref.getLanguage()!);

  void changeLanguage(String langCode) {
    AppPrint.printData("$langCode");
    Locale locale;
    if (langCode == 'sys') {
      locale = Get.deviceLocale ?? const Locale('en');
    } else {
      locale = Locale(langCode);
    }

    SharedPref.setLanguage(langCode);
    language.value = langCode;
    Get.updateLocale(locale);
    AppPrint.printData("${SharedPref.getLanguage()}");
    language.refresh();
  }

  Rx<String> language =
      (SharedPref.getLanguage() != null || SharedPref.getLanguage() != "sys")
          ? SharedPref.getLanguage()?.obs ?? 'sys'.obs
          : "sys".obs;

  // ((SharedPref.getLanguage() == null || SharedPref.getLanguage() == "sys")
  //         ? Get.deviceLocale ?? const Locale('en')
  //         : Locale(SharedPref.getLanguage()!))
  //     .languageCode
  //     .obs;
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

