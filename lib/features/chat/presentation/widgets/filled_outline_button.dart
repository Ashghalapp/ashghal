import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomOutlineButton extends StatelessWidget {
  final bool isFilled;
  final VoidCallback onPress;
  final String text;
  final void Function(bool value)? onHighlightChanged;
  const CustomOutlineButton({
    Key? key,
    this.isFilled = true,
    required this.onPress,
    required this.text,
    this.onHighlightChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnimationController animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 200),
    );

    // AnimationController colorController = AnimationController(
    //   vsync: Navigator.of(context),
    //   duration: const Duration(milliseconds: 200),
    // );

    // if (isFilled) {
    //   colorController.forward();
    //   print("<<<<<<<<<<<<${colorController.status}>>>>>>>>>>>>");
    // } else {
    //   colorController.reverse();
    // }

    return ScaleTransition(
      scale: Tween<double>(begin: 1, end: 1.08).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.fastLinearToSlowEaseIn,
      )),
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
        tween: ColorTween(
          begin: null,
          end: isFilled ? Get.theme.primaryColor : Colors.transparent,
        ),
        builder: (context, Color? value, child) {
          return MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: Get.theme.primaryColor),
            ),
            splashColor: Colors.transparent, // Get.theme.primaryColor,
            elevation: isFilled ? 2 : 0,
            highlightColor: Get.theme.scaffoldBackgroundColor,
            // color: isFilled ? Get.theme.primaryColor : null,
            color: value,
            onPressed: () async {
              await animationController.forward();
              onPress();
              // Future.delayed(
              //   const Duration(milliseconds: 100),
              //   () {
              animationController.reverse();
              // },
              // );
            },
            child: child,
          );
        },
        child: Text(
          text,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: isFilled ? Colors.white : null,
            // fontSize: 15,
          ),
        ),
      ),
    );
  }
}
