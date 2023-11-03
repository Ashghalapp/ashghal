import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/config/app_constants.dart';
import 'package:ashghal_app_frontend/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:ashghal_app_frontend/main_screen.dart';
import 'package:ashghal_app_frontend/manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



import '../../core/helper/shared_preference.dart';
import '../auth_and_user/presentation/screens/auth/login_screen.dart';
import '../auth_and_user/presentation/widgets/logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: AppConstants.splashDelay)).then((value) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => _next(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.bounceOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
     const LogoWidget(),
     const SizedBox(height:15),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'A',
                      style: Get.textTheme.displayLarge!.copyWith(
                        fontSize: AppSize.s28,
                        color: AppColors.appColorPrimary),
                    ),

                    TextSpan(
                      text: ' s h g h a l',
                      style: Get.textTheme.headlineLarge!.copyWith(
                        color: Get.textTheme.headlineLarge!.color,
                        fontSize: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _next() {
    // Check if the user has seen the onboarding screen.
    bool hasSeenOnboarding = SharedPref.getintroductionScreenSeen();

    // Check if the user is logged in or as a guest.
    bool isUserLoggedIn = SharedPref.isUserLoggedIn();
    bool isUserLoggedInAsGuest = SharedPref.isUserLoggedInAsGuest();

    if (!hasSeenOnboarding) {
      // If the user hasn't seen the onboarding screen, redirect to it.
   return const OnBoardingScreen();
    } else if (isUserLoggedIn || isUserLoggedInAsGuest) {
      // If the user is logged in, redirect to the main screen.
   return const MainScreen();
    } else {
      // If the user has seen the onboarding but isn't logged in, redirect to the login screen.
 return const LoginScreen();
    }
  }
}
