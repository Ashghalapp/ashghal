import 'package:flutter/material.dart';

class ScaleDownTransitionWidget extends StatelessWidget {
  final Widget child;
  final double minSize;
  ScaleDownTransitionWidget(
      {super.key, required this.child, this.minSize = 0.7});

  late AnimationController animationController;

  void onPressed() async {
    if (!animationController.isAnimating) {
      print("<<<<<<<<<<<Start Animation>>>>>>>>>>>");
      await animationController.forward();
      animationController.reverse();
    }
    // if (!animationController.isAnimating) {
    //   if (animationController.status == AnimationStatus.completed) {
    //     animationController.reverse();
    //   } else {
    //     animationController.forward();
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 200),
    );

    return Listener(
      onPointerDown: (event) => onPressed(),
      onPointerUp: (event) => onPressed(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: minSize).animate(
          animationController,
        ),
        child: child,
      ),
    );
  }
}
