

import 'package:get/get.dart';

import '../features/auth/presentation/screens/auth/chooseusertype.dart';
import '../features/auth/presentation/screens/auth/login_screen.dart';
import '../features/auth/presentation/screens/auth/signup_screen.dart';
import '../features/auth/presentation/screens/auth/successignup_screen.dart';
import '../features/auth/presentation/screens/auth/verficationsignup_screen.dart';
import '../features/auth/presentation/screens/forgetpassord/forgetpassword_screen.dart';
import '../features/auth/presentation/screens/forgetpassord/resetpassword_screen.dart';
import '../features/auth/presentation/screens/forgetpassord/successresetpassword.dart';
import '../features/auth/presentation/screens/forgetpassord/verficationresetpassword_screen.dart';
import '../features/auth/presentation/screens/test_screen.dart';
import 'app_routes.dart';

List<GetPage<dynamic>>? routes = [
//   GetPage(
//     name: '/',
//     page: () => const LanguageScreen(),
//     middlewares: [
//       AppMiddleware(),
//     ],
//   ),
//  GetPage(
//     name: '/SignInGoogle',
//     page: () =>   SignInGoogle(),
    
//   ),

  // GetPage(
  //   name: AppRoutes.mainScreen,
  //   page: () => const MainScreen(),
  // ),
  // GetPage(
  //   name: AppRoutes.homeScreen,
  //   page: () =>  HomeScreen(),
  // ),
  GetPage(
    name: AppRoutes.testScreen,
    page: () => const TestScreen(),
  ),
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
  // GetPage(
  //   name: AppRoutes.profileScreen,
  //   page: () => const ProfileScreen()
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
  GetPage(
    name: AppRoutes.verficationResetPassword,
    page: () => const VerficationResetpasswordScreen(),
  ),
  GetPage(
    name: AppRoutes.verficationSignUp,
    page: () => const VerficationSignUpScreen(),
  ),
  GetPage(
    name: AppRoutes.resetPassword,
    page: () =>  const ResetPasswordScreen(),
  ),
  GetPage(
    name: AppRoutes.succesSignUp,
    page: () => const SuccesSignUp(),
  ),
  GetPage(
    name: AppRoutes.succesResetPassword,
    page: () => const SuccesResetPassword(),
  ),
  // GetPage(
  //   name: AppRoutes.postScreen,
  //   page: () =>  PostsScreen(),
  // ),
  // GetPage(name: '/tester', page: () => Tester())
];