import 'package:ashghal_app_frontend/app_live_cycle_controller.dart';
import 'package:ashghal_app_frontend/config/app_theme.dart';
import 'package:ashghal_app_frontend/core/localization/local_controller.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';

import 'package:ashghal_app_frontend/core_api/pusher_service.dart';
import 'package:ashghal_app_frontend/core_api/services/image_checker_cacher.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/streames_manager.dart';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dependency_injection.dart';

class AppServices extends GetxService {
  late SharedPreferences prefs;
  static StreamsManager appStreamsManager = StreamsManager();
  // late ThemeData apptheme;
  // static late ThemeMode themeMode;
  static late List<CameraDescription> cameras;
  static late PusherService pusher;
  static late NetworkInfoImpl networkInfo;

  // late SharedPreferences sharedPref;
  Future<AppServices> init() async {
    prefs = await SharedPreferences.getInstance();

    // prefs.setString('authKey', "1|lAaMrRzYbX5iVFgocDYMLQK2aKFBwdq3mZUYvD8U6510413a");
    // prefs.setString("current_user_data", jsonEncode({'id': '1', 'name': 'hezbr al-humaidi'}));

    // Get.lazyPut(() => OnBoardingControllerImp());
    Get.lazyPut(() => AppLocallcontroller());
     Get.lazyPut(()=>AppLifeCycleController());
    cameras = await availableCameras();

    pusher = PusherService();

    // await pusher.initializePusher();

    networkInfo = NetworkInfoImpl();

    networkInfo.onStatusChanged.listen((isConnected) async {
      if (isConnected) {
        print("On connection Pusher Initialized");
        await pusher.initializePusher();
      } else {
        await pusher.disconnect();
      }
    });

    setupDependencies();
    // ThemeMode theme = ThemeMode.system;

    // apptheme = AppTheme.lightTheme;
    // print("${theme == ThemeMode.light ? 'light' : 'dark'}");
    // themeMode = theme == ThemeMode.light ? ThemeMode.light : ThemeMode.dark;
    // print(themeMode.toString());
    return this;
  }
}

initialServices() async {
  await Get.putAsync(() => AppServices().init());
}
