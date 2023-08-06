// import 'package:ashghal/test_screen.dart';
// import 'package:ashghal/view/screen/post/post_screen.dart';
// import 'package:get/get.dart';

// import 'core/constant/app_routes.dart';
// import 'core/middleware/app_middleware.dart';
// import 'view/screen/auth/sign_in_google.dart';
// import 'view/screen/auth/chooseusertype_screen.dart';
// import 'view/screen/auth/login_screen.dart';
// import 'view/screen/auth/signup_screen.dart';
// import 'view/screen/auth/verficationsignup_screen.dart';
// import 'view/screen/forgetpassword/forgetpassword_screen.dart';
// import 'view/screen/forgetpassword/resetpassword_screen.dart';
// import 'view/screen/forgetpassword/successresetpassword.dart';

// import 'view/screen/auth/successignup_screen.dart';
// import 'view/screen/forgetpassword/verficationresetpassword_screen.dart';
// import 'view/screen/home_screen.dart';
// import 'view/screen/language_screen.dart';
// import 'view/screen/location/add_location_screen.dart';
// import 'view/screen/location/view_location_screen.dart';
// import 'view/screen/main_screen.dart';
// import 'view/screen/onboarding_screen.dart';
// import 'view/test/test_screen.dart';

import 'package:ashghal_app_frontend/features/auth/presentation/screens/auth/verficationsignup_screen.dart';
import 'package:get/get.dart';

import '../../features/auth/presentation/screens/auth/chooseusertype.dart';
import '../../features/auth/presentation/screens/auth/signup_screen.dart';
import '../../features/auth/presentation/screens/auth/successignup_screen.dart';
import 'app_routes.dart';

List<GetPage<dynamic>>? routes = [
  // GetPage(
  //   name: '/',
  //   page: () => const LanguageScreen(),
  //   middlewares: [
  //     AppMiddleware(),
  //   ],
  // ),
  // GetPage(
  //   name: '/SignInGoogle',
  //   page: () => SignInGoogle(),
  // ),

  // GetPage(
  //   name: AppRoutes.mainScreen,
  //   page: () => const MainScreen(),
  // ),
  // GetPage(
  //   name: AppRoutes.homeScreen,
  //   page: () => const HomeScreen(),
  // ),
  // GetPage(
  //   name: AppRoutes.testScreen,
  //   page: () => const TestScreen(),
  // ),
  // GetPage(
  //   name: AppRoutes.addLocationScreen,
  //   page: () => const AddLocationScreen(),
  // ),
  // GetPage(
  //   name: AppRoutes.addDetailsScreen,
  //   page: () => const add(),
  // ),
  // GetPage(
  //   name: AppRoutes.viewLocationScreen,
  //   page: () => const ViewLocationScreen(),
  // ),
  GetPage(
    name: AppRoutes.chooseUserTypeScreen,
    page: () => const ChooseUserTypeScreen(),
  ),
  GetPage(
    name: AppRoutes.singUpScreenJob,
    page: () => const SingUpScreenJob(),
  ),
  // GetPage(
  //   name: AppRoutes.singUpScreenLocation,
  //   page: () => const SignUpScreenLocation(),
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
  // GetPage(
  //   name: AppRoutes.logIn,
  //   page: () => const LoginScreen(),
  // ),
  GetPage(
    name: AppRoutes.signUp,
    page: () => SignUpScreen(),
  ),
  // GetPage(
  //   name: AppRoutes.forgetPassword,
  //   page: () => const ForgetPassword(),
  // ),
  // GetPage(
  //   name: AppRoutes.verficationResetPassword,
  //   page: () => const VerficationResetpasswordScreen(),
  // ),
  GetPage(
    name: AppRoutes.verficationSignUp,
    page: () => const VerficationSignUpScreen(),
  ),
  // GetPage(
  //   name: AppRoutes.resetPassword,
  //   page: () => const ResetPasswordScreen(
  //     token: '',
  //   ),
  // ),
  GetPage(
    name: AppRoutes.succesSignUp,
    page: () => const SuccesSignUp(),
  ),
  // GetPage(
  //   name: AppRoutes.succesResetPassword,
  //   page: () => const SuccesResetPassword(),
  // ),
  // GetPage(
  //   name: AppRoutes.postScreen,
  //   page: () => PostsScreen(),
  // ),
  // GetPage(name: '/tester', page: () => Tester())
];
