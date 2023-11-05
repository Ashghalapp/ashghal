import 'package:ashghal_app_frontend/app_live_cycle_observer.dart';
import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/config/binding_all_controllers.dart';
import 'package:ashghal_app_frontend/config/theme_controller.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';

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
  AppUtil.loadCategories();

  // (await SharedPreferences.getInstance()).clear();
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
    ..backgroundColor =
        AppColors.appColorPrimary // Darker semi-transparent background
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
    ThemeController themeController = Get.find();
    return AppLifeCycleManager(
        child: GetMaterialApp(
      darkTheme: AppTheme.darkTheme,
      builder: EasyLoading.init(),
      onInit: () {},
      title: 'Ashghal App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      locale: controller.initialLang,
      translations: MyTranslation(),
      initialBinding: BindingAllControllers(),
      // theme: ThemeData(
      //   primaryColor: Colors.blue,
      //   useMaterial3: true,
      // ),

      // initialRoute: AppRoutes.singUpScreenJob,
      // initialRoute: AppRoutes.languageScreen,
      // // initialRoute: HomeScreen(),
      // home: ProfileAccountHeaderWidget(user: User(id: 1, name: "name", birthDate: DateTime.now(), gender: Gender.male, isBlocked: true, createdAt: DateTime.now(), updatededAt: DateTime.now(), followersUsers: [], followingUsers: [], followersRequestsWait: [], followRequestsSent: []),),
      // home: CommentCardWidget(comment: CommentController().commentsListToTry[0]),
      // initialRoute: AppRoutes.singUpJobScreen,
      // initialRoute: AppRoutes.chooseUserTypeScreen,
      // initialRoute: AppRoutes.mainScreen-

      // home: SettingScreen(user: SharedPref.getCurrentUserData()),
      initialRoute: AppRoutes.splashScreen,
      // home: SignUpScreen(),
      // initialRoute: AppRoutes.mainScreen,
      // initialRoute: AppRoutes.logIn,
      // home: Tester(),
      // home: TestDownloading(),
      // home: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Get.to(() => ChatScreen());
      //     },
      //     child: const Text("Open Chat"),
      //   ),
      // ),
      // initialRoute: '/tester',
      // initialRoute: AppRoutes.testScreen,
      getPages: routes,
      themeMode: themeController.themeMode.value,
    ));
  }
}
