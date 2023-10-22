
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_routes.dart';
import '../helper/shared_preference.dart';
import '../services/app_services.dart';

class AppMiddleware extends GetMiddleware {


  AppServices myServices = Get.find();
  @override
  RouteSettings? redirect(String? route) {
    debugPrint('Redirect middleware executed for route: $route');
  
    debugPrint(myServices.prefs.getString('language'));
    // if (myServices.prefs.getString('language') == null) {
    //   return const RouteSettings(name: AppRoutes.languageScreen);
    // }

    // if (SharedPref.getintroductionScreenSeen()) {
      // printError(info: "hhhhhhhhhhhhhhhhhh${SharedPref.isUserLoggedIn()}");
      if (SharedPref.isUserLoggedIn()) {
        return const RouteSettings(name: AppRoutes.mainScreen);
      } else{
      // return const RouteSettings(name: AppRoutes.logIn);
      
      }
    // }
     printError(info: "mmmmmmmmmmmm${SharedPref.isUserLoggedIn()}");
    // if (!SharedPref.getintroductionScreenSeen()) {
    //   return const RouteSettings(name: AppRoutes.onBoarding);
    // }

    return null;
  }

  
}
