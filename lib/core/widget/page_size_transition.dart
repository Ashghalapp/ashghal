import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageSizeTransition extends PageRouteBuilder<Widget> {
  final Widget page;
  PageSizeTransition(this.page)
      : super(
          pageBuilder: (context, animation, secondAnimation) => page,
          transitionDuration: const Duration(milliseconds: 1200),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondAnimation, child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastLinearToSlowEaseIn,
              reverseCurve: Curves.fastOutSlowIn,
            );
            return Align(
              alignment: Alignment.bottomCenter,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: 0,
                child: page,
              ),
            );
          },
        );
}

class PageSizeTransition2 extends CustomTransition {
  // final Duration customTransitionDuration;
  // final Duration customReverseTransitionDuration;

  PageSizeTransition2(
      //{ required this.customTransitionDuration,
      // required this.customReverseTransitionDuration,}
      );

  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // AnimationController animationController = AnimationController(
    //   duration: const Duration(milliseconds: 1000),
    //   reverseDuration: const Duration(milliseconds: 0),
    //   vsync: Navigator.of(context),
    // )..forward();

    animation = CurvedAnimation(
      parent: animation,
      curve: Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.fastOutSlowIn,
    );
    // animationController.forward();

    // final t =TweenAnimationBuilder(tween: Tween<double>(begin: 0.0, end: 1.0), duration: Duration(milliseconds: 1200), builder: (context, value, child) {

    // },);

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: 0,
        child: child,
      ),
    );
  }
}

double lastValue = 0;

class PageSizeTransition3 extends CustomTransition {
  // final TickerProvider tickerProvider;
  // final Duration customTransitionDuration;
  // final Duration customReverseTransitionDuration;

  static GlobalKey screenKey = GlobalKey();
  static GlobalKey screenKey2 = GlobalKey();
  PageSizeTransition3();

  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // كود لاستخدام انيميشن مخصص اكثر روعة لكنه يجيب شوية مشاكل في صفحات 
    // انشاء حساب عند اغلاق الكيبورد
    // AnimationController animationController = AnimationController(
    //   duration: const Duration(milliseconds: 1400),
    //   reverseDuration: const Duration(milliseconds: 500),
    //   vsync: Navigator.of(context),
    // );

    // final value = MediaQuery.of(context).viewInsets.bottom;
    // if (value > 0 || lastValue > 0) {
    //   print(":::::::::::::::::::lastValue: $lastValue, current value: $value");
    //   lastValue = value;
    // } else {
    //   print(":::::::::::::::::::lastValue: $lastValue, current value: $value");
    //   lastValue = value;
    //   animation = CurvedAnimation(
    //     parent: animation,
    //     curve: Curves.fastLinearToSlowEaseIn,
    //     reverseCurve: Curves.fastOutSlowIn,
    //   );
    //   animationController.forward();
    // }
    
    return Align(
      // key: screenKey,
      alignment: Alignment.bottomCenter,
      child: SizeTransition(
        // key: screenKey2,
        sizeFactor: animation,
        axisAlignment: 0,
        child: child,
      ),
    );
  }
}
