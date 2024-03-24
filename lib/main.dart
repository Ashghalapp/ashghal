import 'package:ashghal_app_frontend/app_live_cycle_observer.dart';
import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/config/binding_all_controllers.dart';
import 'package:ashghal_app_frontend/config/theme_controller.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/page_size_transition.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) => runApp(const MyApp()));
  // runApp(const MyApp());
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// enum AnimationState { enterPage, exitPage }

// AnimationState animationState = AnimationState.enterPage;
// late AnimationController animationController;

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // animationController = AnimationController(
    //   duration: const Duration(milliseconds: 1400),
    //   reverseDuration: const Duration(milliseconds: 500),
    //   vsync: this,
    // );
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  // @override
  // Future<bool> didPopRoute() async {
  //   // animationState = AnimationState.exitPage;
  //   // printInfo(info: animationController.status.toString());
  //   printInfo(info: "pooooooooooooooooooooop");
  //   // if (animationController.status == AnimationStatus.forward ||
  //   //     animationController.status == AnimationStatus.dismissed) {
  //   printInfo(info: "cooooooooooom");
  //   // animationState = AnimationState.exitPage;
  //   // await animationController.reverse();
  //   // animationState = AnimationState.exitPage;
  //   // animationController.stop();
  //   // animationController.forward();
  //   // printInfo(info: animationController.status.toString());
  //   // animationState = AnimationState.exitPage;
  //   // }
  //   return Future.value(false);
  // }
  // AnimationController animationController = AnimationController(
  //     duration: const Duration(milliseconds: 1200),
  //     // reverseDuration: const Duration(milliseconds: 400),
  //     vsync: this,
  //   )..forward();

  //   @override
  // Future<bool> didPopRoute(Route<dynamic> route, Route<dynamic>? previousRoute) {
  //   super.didPop(route, previousRoute);
  //   // التحقق من إغلاق الشاشة المستهدفة
  //   if (previousRoute?.settings.name == "YourTargetScreen") {
  //     // قم بتنفيذ reverse() عند إغلاق الشاشة
  //     // yourAnimationController.reverse();
  //   }

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey mainKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    AppLocallcontroller controller = Get.find();
    ThemeController themeController = Get.find();

    return AppLifeCycleManager(
      child: GetMaterialApp(
        key: mainKey,
        darkTheme: AppTheme.darkTheme,
        builder: EasyLoading.init(),
        onInit: () {},
        title: 'Ashghal App',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        locale: controller.initialLang,
        translations: MyTranslation(),
        initialBinding: BindingAllControllers(),
        initialRoute: AppRoutes.splashScreen,
        getPages: routes,
        themeMode: themeController.themeMode.value,
        customTransition: PageSizeTransition3(),
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
        
        // home: SignUpScreen(),
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
        
        // checkerboardOffscreenLayers: true,
        // navigatorKey: navigatorKey,
        // transitionDuration: const Duration(milliseconds: 500),
        // defaultTransition: Transition.downToUp,
      ),
    );
  }
}
