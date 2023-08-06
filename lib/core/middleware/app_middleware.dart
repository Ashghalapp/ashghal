
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/app_routes.dart';
import '../core/helper/shared_preference.dart';
import '../services/app_services.dart';

class AppMiddleware extends GetMiddleware {


  AppServices myServices = Get.find();
  @override
  RouteSettings? redirect(String? route) {
    debugPrint('Redirect middleware executed for route: $route');
  
    debugPrint(myServices.prefs.getString('language'));
    if (myServices.prefs.getString('language') == null) {
      return const RouteSettings(name: AppRoutes.languageScreen);
    }
    if (SharedPrefs().getintroductionScreenSeen()) {
      if (SharedPrefs().isUserLoggedIn()) {
        return const RouteSettings(name: AppRoutes.mainScreen);
      }
      return const RouteSettings(name: AppRoutes.logIn);
    }
    if (!SharedPrefs().getintroductionScreenSeen()) {
      return const RouteSettings(name: AppRoutes.onBoarding);
    }

    return null;
  }

  
}
