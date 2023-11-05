import 'package:ashghal_app_frontend/core/middleware/app_middleware.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/address_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/auth/signup_provider_data_screen.dart';
import 'package:ashghal_app_frontend/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:ashghal_app_frontend/features/onboarding/splash_screen.dart';
import 'package:ashghal_app_frontend/main_screen.dart';
import 'package:get/get.dart';

import '../features/auth_and_user/presentation/screens/auth/chooseusertype.dart';
import '../features/auth_and_user/presentation/screens/auth/login_screen.dart';
import '../features/auth_and_user/presentation/screens/auth/signup_screen.dart';
import '../features/auth_and_user/presentation/screens/forgetpassword/forgetpassword_screen.dart';
import '../features/auth_and_user/presentation/screens/forgetpassword/resetpassword_screen.dart';
import '../features/auth_and_user/presentation/screens/test_screen.dart';
import 'app_routes.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
    name: AppRoutes.splashScreen,
    page: () => const SplashScreen(),
    // middlewares: [
    //   AppMiddleware(),
    // ],
  ),
 GetPage(
    name: AppRoutes.onBoarding,
    page: () =>   const OnBoardingScreen(),

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
    page: () => MainScreen(),
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

  ),
  GetPage(
    name: AppRoutes.signUp,
    page: () => SignUpScreen(),
  ),
  GetPage(
    name: AppRoutes.forgetPassword,
    page: () => const ForgetPassword(),
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
