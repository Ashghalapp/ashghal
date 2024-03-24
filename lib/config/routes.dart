import 'package:ashghal_app_frontend/core/widget/page_size_transition.dart';
import 'package:ashghal_app_frontend/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:ashghal_app_frontend/features/onboarding/splash_screen.dart';
import 'package:ashghal_app_frontend/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/auth_and_user/presentation/screens/auth/chooseusertype.dart';
import '../features/auth_and_user/presentation/screens/auth/login_screen.dart';
import '../features/auth_and_user/presentation/screens/auth/signup_screen.dart';
import '../features/auth_and_user/presentation/screens/forgetpassword/forgetpassword_screen.dart';
import '../features/auth_and_user/presentation/screens/forgetpassword/resetpassword_screen.dart';

import 'app_routes.dart';

// List<GetPageRoute> routesP = [
//   GetPageRoute(
//     routeName: AppRoutes.chooseUserTypeScreen,
//     // page: () => PageSizeTransition(ThirdPage()),
// // settings: PageSizeTransition()
//   ),
// ];
List<GetPage<dynamic>>? routes = [
  GetPage(
    name: AppRoutes.splashScreen,
    page: () => const SplashScreen(),
    customTransition: PageSizeTransition2(),
    // middlewares: [
    //   AppMiddleware(),
    // ],
  ),
  GetPage(
    name: AppRoutes.onBoarding,
    page: () => const OnBoardingScreen(),
    customTransition: PageSizeTransition2(),
  ),

  // GetPage(
  //   name: AppRoutes.mainScreen,
  //   page: () => const MainScreen(),
  // ),
  // GetPage(
  //   name: AppRoutes.homeScreen,
  //   page: () =>  HomeScreen(),
  // ),
  // GetPage(
  //   name: AppRoutes.testScreen,
  //   page: () => const TestScreen(),
  // ),
  GetPage(
    name: AppRoutes.mainScreen,
    page: () => const MainScreen(),
    customTransition: PageSizeTransition2(),
  ),
  // GetPage(
  // name: AppRoutes.addLocationScreen,
  // page: () =>  AddressScreen(),
  // ),
  // GetPage(
  //   name: AppRoutes.addDetailsScreen,
  //   page: () => const add(),
  // ),
  // GetPage(
  //   name: AppRoutes.viewLocationScreen,
  //   page: () => const ViewLocationScreen(),
  // ),
  // GetPage(
  //   name: AppRoutes.profileScreen,
  //   page: () => const ProfileScreen()
  // ),
  GetPage(
    name: AppRoutes.chooseUserTypeScreen,
    page: () => const ChooseUserTypeScreen(),
    // customTransition: PageSizeTransition3(null),
    // customTransition: PageSizeTransition2(
    //   customTransitionDuration: Duration(milliseconds: 1200),
    //   customReverseTransitionDuration: Duration(milliseconds: 300),
    // ),
    // transitionDuration: Duration(milliseconds: 1000),

    // transitionDuration: const Duration(milliseconds: 1200),
    // // alignment: Alignment.topRight,
    // transition: Transition.downToUp,
    // curve: Curves.fastEaseInToSlowEaseOut,
  ),
  // GetPage(
  //   name: AppRoutes.singUpJobScreen,
  //   // page: () => const SignUpProviderDataScreen(),
  // ),
  // GetPage(
  //   name: AppRoutes.singUpScreenLocation,
  //   page: () =>  const SignUpScreenLocation(),
  // ),
  // GetPage(
  //   name: AppRoutes.singUpScreenEmail,
  //   page: () => const SingUpScreenEmail(),
  // ),
  // GetPage(
  //   name: AppRoutes.languageScreen,
  //   page: () => const LanguageScreen(),
  // ),

  // GetPage(
  //   name: AppRoutes.onBoarding,
  //   page: () => const OnboardingScreen(),
  // ),
  GetPage(
    name: AppRoutes.logIn,
    page: () => const LoginScreen(),
    customTransition: PageSizeTransition2(),
  ),

  GetPage(
    name: AppRoutes.signUp,
    page: () => SignUpScreen(),
    // customTransition: PageSizeTransition2(),
    // transitionDuration: const Duration(milliseconds: 1000),
    // alignment: Alignment.bottomCenter,
    // curve: Curves.fastLinearToSlowEaseIn,
  ),

  GetPage(
    name: AppRoutes.forgetPassword,
    page: () => const ForgetPassword(),
    customTransition: PageSizeTransition2(),
  ),
  // GetPage(
  //   name: AppRoutes.validateScreen,
  //   page: () =>  ValidateScreen(),
  // ),
  // GetPage(
  //   name: AppRoutes.verficationResetPassword,
  //   page: () => const VerficationResetpasswordScreen(),
  // ),
  // GetPage(
  //   name: AppRoutes.verficationSignUp,
  //   page: () => const VerficationSignUpScreen(),
  // ),
  GetPage(
    name: AppRoutes.resetPassword,
    page: () => const ResetPasswordScreen(),
    customTransition: PageSizeTransition2(),
  ),
  // GetPage(
  //   name: AppRoutes.succesSignUp,
  //   page: () => const SuccesSignUp(),
  // ),
  // GetPage(
  //   name: AppRoutes.postScreen,
  //   page: () =>  PostsScreen(),
  // ),
  // GetPage(name: '/tester', page: () => Tester())
];

// final animation = CurvedAnimation(parent: parent, curve: curve)
