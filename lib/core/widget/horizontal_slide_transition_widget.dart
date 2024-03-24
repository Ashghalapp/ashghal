import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizontalSlideTransitionWidget extends StatefulWidget {
  final Widget child;
  final int milliseconds;
  final int? millisecondToLate;
  const HorizontalSlideTransitionWidget({
    super.key,
    required this.child,
    this.milliseconds = 500,
    this.millisecondToLate,
  });

  @override
  State<HorizontalSlideTransitionWidget> createState() => _HorizontalSlideTransitionWidgetState();
}

class _HorizontalSlideTransitionWidgetState extends State<HorizontalSlideTransitionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.milliseconds),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.millisecondToLate != null) {
      Timer(Duration(milliseconds: widget.millisecondToLate!), () {
        _controller.forward();
      });
    } else {
      _controller.forward();
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(Get.locale?.languageCode == 'en' ? -1.0 : 1, 0.0),
        end: const Offset(0, 0),
      ).animate(_controller),
      child: widget.child,
    );
  }
}
