// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPref {
//   static Future<SharedPreferences> _init() async {
//     return await SharedPreferences.getInstance();
//   }

//   static SharedPreferences? _sharedPrefs;
//   static Future<SharedPreferences> get _prefs async {
//     return _sharedPrefs ??= await _init();
//   }

//   static Future<String?> getUserToken() async{
//     return await getString('token');
//   }

//   static Future<bool> setString(String key, String value) async{
//     return await (await _prefs).setString(key, value);
//   }

//   static  Future<String?>? getString(String key) async{
//     return (await _prefs).getString(key);
//   }
//       static  Future<bool> setLanguage(String lang) async {

//    return await (await _prefs).setString('language', lang);
//   }

//   static Future<String> getLanguage() async {

//    return (await _prefs).getString('language') ?? 'en';
//   }

//   static Future<bool> getintroductionScreenSeen() async {
//     return (await _prefs).getBool('introductionScreenSeen')??false;
//   }
//   static Future<bool> setintroductionScreenSeen() async {
//     return (await _prefs).setBool('introductionScreenSeen', true);
//   }

//   static Future<bool> setUserLoggedIn() async {
//     return await (await _prefs).setBool('isLoggedIn', true);
//   }
//   static Future<bool> isUserLoggedIn() async {}
// }


import 'package:ashghal_app_frontend/core/core/services/app_services.dart';
import 'package:get/get.dart';

class SharedPrefs {
  AppServices appServices = Get.find();

   void setintroductionScreenSeen() {
    appServices.prefs.setBool('introductionScreenSeen', true);
  }

   bool getintroductionScreenSeen() {
    return appServices.prefs.getBool('introductionScreenSeen') ?? false;
  }

   bool isDarkMode() {
    return appServices.prefs.get('darkMode') as bool? ?? true;
  }

   setDarkMode(bool value) {
    appServices.prefs.setBool('darkMode', value);
  }

   void setUserLoggedIn(bool loggedIn) {
    appServices.prefs.setBool('isLoggedIn', loggedIn);
  }

   void setUserLoggedInAsGuest(bool isGuest) {
    appServices.prefs.setBool('isGuest', isGuest);
  }

   bool isUserLoggedIn() {
    return appServices.prefs.getBool('isLoggedIn') ?? false;
  }

   setAuthorizationKey(String? authKey) {
    appServices.prefs.setString('authKey', authKey!);
  }

   String? getAuthorizationKey() {
    return appServices.prefs.get('authKey') as String?;
  }

   void clearPreferences() {
    setUserLoggedIn(false);
    appServices.prefs.remove('authKey');

    appServices.prefs.clear();
  }

   void setLanguage(String lang) {
    appServices.prefs.setString('language', lang);
  }

   String getLanguage() {
    return appServices.prefs.get('language') as String? ?? 'en';
  }
}
