import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ScrollerAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? action;
  final Widget? bottom;
  final ScrollController pageScrollController;
  final void Function(ScrollDirection scrollDirection, bool isAppBarShow)?
      onScrollDirectionChange;
  ScrollerAppBar({
    super.key,
    required this.title,
    required this.pageScrollController,
    this.bottom,
    this.onScrollDirectionChange,
    this.action,
  });

  final RxBool _showAppbar = true.obs;

  @override
  Widget build(BuildContext context) {
    _runPageScrollerListener(pageScrollController);
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            height: _showAppbar.value ? 56 : 0,
            duration: const Duration(milliseconds: 300),
            child: AppBar(
              title: Text(title.tr),
              actions: action,
            ),
          ),
          if (bottom != null)
            Visibility(visible: _showAppbar.value, child: bottom!),
        ],
      ),
    );
  }

  void _runPageScrollerListener(ScrollController pageScrollController) {
    pageScrollController.addListener(() {
      // printError(info: "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
      if (pageScrollController.offset < 100) {
        _showAppbar.value = true;
        return;
      }

      if (pageScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        //  printError(info: "================================================");
        // if (!isScrollingDown) {
        _showAppbar.value = false;
      }

      if (pageScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        //  printError(info: "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
        // if (isScrollingDown) {
        _showAppbar.value = true;
      }
      if (onScrollDirectionChange != null) {
        onScrollDirectionChange!(
            pageScrollController.position.userScrollDirection,
            _showAppbar.value);
      }
    });
  }
}

// body: NestedScrollView(
//             controller: scrollController,
//             headerSliverBuilder: (context, innerBoxIsScrolled) {
//               return [
//                 SliverAppBar(
//                   // to fixed filters use pinned: true
//                   // pinned: true,
//                   title: Text("Posts"),
//                   floating: true,
//                   bottom: PreferredSize(
//                     preferredSize: const Size.fromHeight(50),
//                     child: buildFilterButtons(),
//                   ),
//                 ),

                
//               ];
//             },
//             body: _postsBuilder(),