import 'dart:convert';

import 'package:ashghal_app_frontend/app_library/public_entities/app_category.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/app_services.dart';

class SharedPref {
  static const String _themeKey = "appThemeMode";
  static const String _categoriesKey = "categories";
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

  static setThemeMode(ThemeMode themeMode) {
    _appServices.prefs.setString(_themeKey, themeMode.name);
  }

  static ThemeMode getThemeMode() {
    return ThemeMode.values
        .byName(_appServices.prefs.getString(_themeKey) ?? 'system');
  }

  static void setUserLoggedIn(bool loggedIn) {
    _appServices.prefs.setBool('isLoggedIn', loggedIn);
  }

  static void setUserLoggedInAsGuest(bool isGuest) {
    _appServices.prefs.setBool('isGuest', isGuest);
  }
   static bool isUserLoggedInAsGuest() {
    return _appServices.prefs.getBool('isGuest') ?? false;
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

  static Map<String, dynamic>? getCurrentUserBasicData() {
    String? data = SharedPref.getString("current_user_basic_data");
    if (data != null) {
      return jsonDecode(data);
    } 
    // else {
    //   // AppUtil.showMessage(
    //   //     AppLocalization.thereIsSomethingError, Get.theme.colorScheme.error);
    //   Get.offAllNamed(AppRoutes.logIn);
    //   return {'id': 0, 'name': "name", 'image_url': ""};
    // }
    return null;
  }

  static setCurrentUserData(UserModel user) {
    SharedPref.setString("current_user_data", jsonEncode(user.toJson()));
    setCurrentUserBasicData(
      {'id': user.id, 'name': user.name, 'image_url': user.imageUrl},
    );
  }

  static User? getCurrentUserData() {
    try {
      String? data = SharedPref.getString("current_user_data");
      if (data != null) {
        var user = UserModel.fromJson(jsonDecode(data));
        print("<<<<<<<Current cashed user data ${user.toString()}>>>>>>>>");
        return user;
      }
    } catch (e) {
      AppUtil.buildDialog("Error", e.toString(), () {});
    }
    // AppUtil.showMessage(
    //     AppLocalization.thereIsSomethingError, Get.theme.colorScheme.error);
    // Get.offAllNamed(AppRoutes.logIn);
    // return AppFunctions.fakeUserData;
    return null;
  }

  static setCategories(List<AppCategory> categories){
    setString(_categoriesKey, jsonEncode(categories.map((e) => e.toJson()).toList()));
  }

  static List<AppCategory>? getCategories(){
    final stringData = getString(_categoriesKey);
    if (stringData != null){
      final jsonData= (jsonDecode(stringData) as List).cast<Map<String, dynamic>>();
      print("<<<<<<<<<<<<<<categories: $jsonData>>>>>>>>>>>>>>");
      return AppCategory.fromJsonList(jsonData);
    }
    return null;
  }
}
