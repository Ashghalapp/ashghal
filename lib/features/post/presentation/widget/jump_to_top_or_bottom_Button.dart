import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnimatedJumpToTopOrBottomButton extends StatelessWidget {
  final ScrollController controller;
  final double height;
  final int durationMillisecond;
  final IconData icon;
  final bool jumpToTop;
  const AnimatedJumpToTopOrBottomButton({
    super.key,
    required this.controller,
    this.jumpToTop = true,
    this.height = 40,
    this.durationMillisecond =  300,
    this.icon = Icons.arrow_upward_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: height,
      duration: Duration(milliseconds: durationMillisecond),
      child: FloatingActionButton(
        shape: const CircleBorder(),
        child: Icon(icon, size: height != 0 ? 24 : 0),
        onPressed: () async {
          double offset = jumpToTop
              ? controller.position.minScrollExtent
              : controller.position.maxScrollExtent;
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              controller.animateTo(
                offset,
                duration: const Duration(milliseconds: 5),
                curve: Curves.fastOutSlowIn,
              );
            },
          );
        },
      ),
    );
  }
}
