import 'package:flutter/material.dart';

class VerticalSlideTransitionWidget extends StatelessWidget {
  final Widget child;
  final int milliseconds;
  final bool fromDownToUp;
  const VerticalSlideTransitionWidget({
    super.key,
    required this.child,
    this.milliseconds = 500,
    this.fromDownToUp = true,
  });

  @override
  Widget build(BuildContext context) {
    final animationCon = AnimationController(
      vsync: Navigator.of(context),
      duration: Duration(milliseconds: milliseconds),
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, fromDownToUp ? 1 : -1),
        end: const Offset(0, 0),
      ).animate(CurvedAnimation(
        parent: animationCon..forward(),
        curve: Curves.easeInOut,
      )),
      child: child,
    );
  }
}
