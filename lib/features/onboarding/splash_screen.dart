import 'dart:async';

import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:ashghal_app_frontend/main_screen.dart';
import 'package:ashghal_app_frontend/manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/helper/shared_preference.dart';
import '../auth_and_user/presentation/screens/auth/login_screen.dart';
import '../../core/widget/logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animationCon;
  late AnimationController textAnimationCon;

  late String pageName;
  late Widget page;
  @override
  void initState() {
    super.initState();

    textAnimationCon = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Widget page = _nextPage();
    animationCon = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addStatusListener(
        (status) async {
          if (status == AnimationStatus.completed) {
            // Get.off(page);
            // printInfo(info: ":::Now Go Next");
            // Get.off(() => const FadeTransitionWidget(child: LoginScreen(), milliseconds: 1000,));
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(
            //     builder: (context) => FadeTransitionWidget(
            //       child: page,
            //       milliseconds: 900,
            //     ),
            //   ),
            // );
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                settings: RouteSettings(name: pageName),
                pageBuilder: (context, animation, secondaryAnimation) => page,
                transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  return FadeTransition(
                    opacity: animation,
                    child: page,
                  );
                },
              ),
            );

            // animationCon.reset();

            Timer(
              const Duration(milliseconds: 300),
              () {
                animationCon.reset();
                textAnimationCon.reset();
              },
            );
          }
        },
      );

    Timer(
      const Duration(milliseconds: 200),
      () {
        setState(() {
          sizeLogo = 160;
        });
      },
    );

    Timer(
      const Duration(milliseconds: 1000),
      () {
        setState(() {
          isStarted = true;
        });
      },
    );

    Timer(
      const Duration(milliseconds: 1650),
      () {
        textAnimationCon.forward();
      },
    );

    Timer(
      const Duration(milliseconds: 3400),
      () {
        animationCon.forward();
        setState(() {});
      },
    );
  }

  bool isStarted = false;
  double sizeLogo = 0;

  @override
  void dispose() {
    animationCon.dispose();
    textAnimationCon.dispose();
    // printInfo(
    //     info:
    //         "<<<<<<<<<<<<<<<<<<<<<<<<<<<Dispose splash>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: InkWell(
        onTap: () {
          Get.off(const SplashScreen(), preventDuplicates: true);
        },
        child: Stack(
          children: [
            Center(
              child: TweenAnimationBuilder(
                duration: const Duration(seconds: 4),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.fastEaseInToSlowEaseOut,
                builder: (context, value, child) {
                  return Opacity(opacity: value, child: child);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1700),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: sizeLogo,
                  width: sizeLogo,
                  child: const LogoWidget(),
                ),
              ),
            ),
            // if (false)
            Stack(
              children: [
                Center(
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0, end: 10.0)
                        .animate(animationCon),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animationCon,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      height: sizeLogo,
                      width: sizeLogo,
                      child: const LogoWidget(),
                    ),
                  ),
                ),
              ],
            ),

            // const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(top: sizeLogo + 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: isStarted ? 1.0 : 0.0,
                    duration: const Duration(seconds: 3),
                    curve: Curves.fastEaseInToSlowEaseOut,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.ease,
                      // height: isStarted ? 30 : 0,
                      margin: EdgeInsets.only(top: isStarted ? 0 : 30),
                      child: Text(
                        'A',
                        style: Get.textTheme.displayLarge!.copyWith(
                          fontSize: AppSize.s28,
                          color: animationCon.status == AnimationStatus.forward
                              ? Colors.white
                              : AppColors.appColorPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: textAnimationCon,
                    axis: Axis.horizontal,
                    axisAlignment: -1.0,
                    child: Center(
                      child: Text(
                        ' s h g h a l',
                        style: Get.textTheme.headlineLarge!.copyWith(
                          color: Get.textTheme.headlineLarge!.color,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Center(
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: SizeTransition(
            //       sizeFactor: textAnimationCon..forward(),
            //       // axis: Axis.horizontal,
            //       axisAlignment: 0.0,
            //       child: RichText(
            //         textAlign: TextAlign.center,
            //         text: TextSpan(
            //           children: [
            //             TextSpan(
            //               text: 'A',
            //               style: Get.textTheme.displayLarge!.copyWith(
            //                   fontSize: AppSize.s28,
            //                   color: AppColors.appColorPrimary),
            //             ),
            //             TextSpan(
            //               text: ' s h g h a l',
            //               style: Get.textTheme.headlineLarge!.copyWith(
            //                 color: Get.textTheme.headlineLarge!.color,
            //                 fontSize: 26,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _nextPage() {
    // Check if the user has seen the onboarding screen.
    bool hasSeenOnboarding = SharedPref.getintroductionScreenSeen();

    // Check if the user is logged in or as a guest.
    bool isUserLoggedIn = SharedPref.isUserLoggedIn();
    bool isUserLoggedInAsGuest = SharedPref.isUserLoggedInAsGuest();

    if (!hasSeenOnboarding) {
      // If the user hasn't seen the onboarding screen, redirect to it.
      pageName = AppRoutes.onBoarding;
      return const OnBoardingScreen();
    } else if (isUserLoggedIn || isUserLoggedInAsGuest) {
      // If the user is logged in, redirect to the main screen.
      pageName = AppRoutes.mainScreen;
      return const MainScreen();
    } else {
      // If the user has seen the onboarding but isn't logged in, redirect to the login screen.
      pageName = AppRoutes.logIn;
      return const LoginScreen();
    }
  }
}
