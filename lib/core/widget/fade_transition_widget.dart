import 'package:flutter/material.dart';

class FadeTransitionWidget extends StatelessWidget {
  final Widget child;
  final int milliseconds;
  const FadeTransitionWidget({
    super.key,
    required this.child,
    required this.milliseconds,
  });

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: AnimationController(
        duration: Duration(milliseconds: milliseconds),
        vsync: Navigator.of(context),
      )..forward(),
      curve: Curves.easeIn,
    );

    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: child,
    );
  }
}
