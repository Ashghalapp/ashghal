import 'package:get/get.dart';

import '../services/app_services.dart';

class SharedPref {
  static final AppServices _appServices = Get.find();

  static void setintroductionScreenSeen() {
    _appServices.prefs.setBool('introductionScreenSeen', true);
  }

  static bool getintroductionScreenSeen() {
    return _appServices.prefs.getBool('introductionScreenSeen') ?? false;
  }

  static bool isDarkMode() {
    return _appServices.prefs.get('darkMode') as bool? ?? true;
  }

  static setDarkMode(bool value) {
    _appServices.prefs.setBool('darkMode', value);
  }

  static void setUserLoggedIn(bool loggedIn) {
    _appServices.prefs.setBool('isLoggedIn', loggedIn);
  }

  static void setUserLoggedInAsGuest(bool isGuest) {
    _appServices.prefs.setBool('isGuest', isGuest);
  }

  static bool isUserLoggedIn() {
    return _appServices.prefs.getBool('isLoggedIn') ?? false;
  }

  static setUserToken(String? userToken) {
    _appServices.prefs.setString('authKey', userToken!);
  }

  static String? getUserToken() {
    return _appServices.prefs.get('authKey') as String?;
  }

  static void clearPreferences() {
    setUserLoggedIn(false);
    _appServices.prefs.remove('authKey');

    _appServices.prefs.clear();
  }

  static void setLanguage(String lang) {
    _appServices.prefs.setString('language', lang);
  }

  static String getLanguage() {
    return _appServices.prefs.get('language') as String? ?? 'en';
  }

  static Future<bool> setString(String key, String value) {
    return _appServices.prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _appServices.prefs.getString(key);
  }
}
