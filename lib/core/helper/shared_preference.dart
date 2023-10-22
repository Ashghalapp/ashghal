import 'dart:convert';

import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/app_functions.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/auth/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';
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

  static setUserId(int id) {
    _appServices.prefs.setInt('userId', id);
  }

  static int? get currentUserId => _appServices.prefs.get('userId') as int?;
  // static int? get currentUserId => 11;

  static setUserName(String name) {
    _appServices.prefs.setString('userName', name);
  }

  static String? get currentUserName =>
      _appServices.prefs.get('userName') as String?;

  static setUserEmail(String? email) {
    if (email != null) {
      _appServices.prefs.setString('userEmail', email);
    }
  }

  static String? get currentUserEmail =>
      _appServices.prefs.get('userEmail') as String?;

  static setUserPhone(String? phone) {
    if (phone != null) {
      _appServices.prefs.setString('userPhone', phone);
    }
  }

  static String? get currentUserPhone =>
      _appServices.prefs.get('userPhone') as String?;

  static setUserImageUrl(String? url) {
    if (url != null) {
      _appServices.prefs.setString('userImageUrl', url);
    }
  }

  static String? get currentUserImageUrl =>
      _appServices.prefs.get('userImageUrl') as String?;

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

  static setCurrentUserBasicData(Map<String, dynamic> json) {
    SharedPref.setString("current_user_basic_data", jsonEncode(json));
  }

  static Map<String, dynamic> getCurrentUserBasicData() {
    String? data = SharedPref.getString("current_user_basic_data");
    if (data != null) return jsonDecode(data);
   else {
      AppUtil.showMessage(
          AppLocalization.thereIsSomethingError, Get.theme.colorScheme.error);
      Get.offAllNamed(AppRoutes.logIn);
      return {'id': 0, 'name': "name", 'image_url': ""};
    }
  }

  static setCurrentUserData(UserModel user) {
    SharedPref.setString("current_user_data", jsonEncode(user.toJson()));
    setCurrentUserBasicData(
      {'id': user.id, 'name': user.name, 'image_url': user.imageUrl},
    );
  }

  static User getCurrentUserData() {
    String? data = SharedPref.getString("current_user_data");
    if (data != null) {
      // print("<<<<<<<<<<<<<<<<<<<$data)}>>>>>>>>>>>>>>>>>>>"); 
      print("<<<<<<<<<<<<<<<<<<<${jsonDecode(data)}>>>>>>>>>>>>>>>>>>>"); 
      var user = UserModel.fromJson(jsonDecode(data));
      print("<<<<<<<<<<<<<<<<<<<$user>>>>>>>>>>>>>>>>>>>");
      return user;
    } else {
      AppUtil.showMessage(
          AppLocalization.thereIsSomethingError, Get.theme.colorScheme.error);
      Get.offAllNamed(AppRoutes.logIn);
      return AppFunctions.fakeUserData;
    }
  }
}
