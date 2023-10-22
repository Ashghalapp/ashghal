// import 'package:ashghal_app_frontend/config/binding_all_controllers.dart';
// import 'package:ashghal_app_frontend/config/chat_theme.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_screen.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await initialServices();
// //   runApp(const MyApp());
// //   configLoading();
// // }

// // void configLoading() {
// //   EasyLoading.instance
// //     ..indicatorType =
// //         EasyLoadingIndicatorType.threeBounce // Modern indicator type
// //     ..maskType = EasyLoadingMaskType.black // Add a dark background mask
// //     ..loadingStyle = EasyLoadingStyle.custom // Use custom loading style
// //     ..indicatorSize = 60.0 // Increase the size of the indicator
// //     ..radius = 10.0
// //     ..progressColor = Colors.white // Color for progress indicator if applicable
// //     ..backgroundColor =
// //         AppColors.appColorPrimary // Darker semi-transparent background
// //     ..indicatorColor = Colors.white // Color of the loading indicator
// //     ..textColor = Colors.white // Color of the loading text
// //     ..textStyle = const TextStyle(fontSize: 16, color: Colors.white)
// //     // ..userInteractions = true
// //     ..dismissOnTap = false;
// //   // ..customAnimation = CustomAnimation();
// // }

// class ChatMainScreen extends StatelessWidget {
//   const ChatMainScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       darkTheme: ChatTheme.dark,
//       theme: ChatTheme.light,
//       // themeMode: ThemeMode.system,
//       debugShowCheckedModeBanner: false,
//       home: ChatScreen(),
//       // locale: controller.language,
//       // translations: MyTranslation(),
//       // initialBinding: BindingAllControllers(),
//       // theme: ThemeData(
//       //   primaryColor: Colors.blue,
//       //   useMaterial3: true,
//       // ),

//       // initialBinding: InitialBinding(),
//       // initialRoute: AppRoutes.singUpScreenJob,
//       // initialRoute: AppRoutes.languageScreen,
//       // initialRoute: HomeScreen(),
//       // initialRoute: AppRoutes.singUpJobScreen,
//       // initialRoute: AppRoutes.chooseUserTypeScreen,
//       // initialRoute: AppRoutes.mainScreen-
//       // initialRoute: AppRoutes.logIn,
//       // initialRoute: AppRoutes.mainScreen,
//       // home: TestDownloading(),
//       // home: Center(
//       //   child: ElevatedButton(
//       //     onPressed: () {
//       //       Get.to(() => ChatScreen());
//       //     },
//       //     child: const Text("Open Chat"),
//       //   ),
//       // ),
//       // initialRoute: '/tester',
//       // initialRoute: AppRoutes.testScreen,
//       // getPages: routes,
//     );
//   }
// }
