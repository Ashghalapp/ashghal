import 'package:ashghal_app_frontend/config/binding_all_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'config/app_routes.dart';
import 'config/app_theme.dart';
import 'config/routes.dart';
import 'core/localization/local_controller.dart';
import 'core/localization/translation.dart';
import 'core/services/app_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialServices();
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType =
        EasyLoadingIndicatorType.threeBounce // Modern indicator type
    ..maskType = EasyLoadingMaskType.black // Add a dark background mask
    ..loadingStyle = EasyLoadingStyle.custom // Use custom loading style
    ..indicatorSize = 60.0 // Increase the size of the indicator
    ..radius = 10.0
    ..progressColor = Colors.white // Color for progress indicator if applicable
    ..backgroundColor = Colors.transparent // Darker semi-transparent background
    ..indicatorColor = Colors.white // Color of the loading indicator
    ..textColor = Colors.white // Color of the loading text
    ..textStyle = const TextStyle(fontSize: 16, color: Colors.white)
    // ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocallcontroller controller = Get.find();
    return GetMaterialApp(
      darkTheme: AppTheme.darkTheme,
      builder: EasyLoading.init(),
      onInit: () {},
      title: 'Ashghal App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      locale: controller.language,
      translations: MyTranslation(),
      initialBinding: BindingAllControllers(),
      // initialBinding: InitialBinding(),
      // initialRoute: AppRoutes.singUpScreenJob,
      // initialRoute: AppRoutes.languageScreen,
      // initialRoute: AppRoutes.mainScreen,
      // initialRoute: AppRoutes.logIn,
      initialRoute: AppRoutes.mainScreen,
      // home: ValidateScreen(),
      // initialRoute: '/tester',
      // initialRoute: AppRoutes.testScreen,
      getPages: routes,
    );
  }
}
