import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ScrollerAppBar extends StatelessWidget {
  final ScrollController controller;
  final String title;
  final void Function(ScrollDirection scrollDirection, bool isAppBarShow)?
      onScrollDirectionChange;
  ScrollerAppBar({
    super.key,
    required this.controller,
    required this.title,
    this.onScrollDirectionChange,
  });

  final RxBool _showAppbar = true.obs;

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      // printError(info: "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
      if (controller.offset < 100) {
        _showAppbar.value = true;
        return;
      }

      if (controller.position.userScrollDirection == ScrollDirection.reverse) {
        //  printError(info: "================================================");
        // if (!isScrollingDown) {
        // isScrollingDown = true;
        _showAppbar.value = false;
        // setState(() {});
        // }
      }

      if (controller.position.userScrollDirection == ScrollDirection.forward) {
        //  printError(info: "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
        // if (isScrollingDown) {
        // isScrollingDown = false;
        _showAppbar.value = true;
        // setState(() {});
        // }
      }
      if (onScrollDirectionChange != null) {
        onScrollDirectionChange!(
            controller.position.userScrollDirection, _showAppbar.value);
      }
    });
    return Obx(
      () => AnimatedContainer(
        height: _showAppbar.value ? 56.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: AppBar(
          // backgroundColor: Colors.amber,
          title: Text(title),
        ),
      ),
    );
  }
}
