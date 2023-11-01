import 'package:flutter/material.dart';

class TabBarSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  Widget child;

  TabBarSliverPersistentHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Theme.of(context).cardColor,
      elevation: overlapsContent ? 4 : 0,
      child: child,
    );
  }

  @override
  double get maxExtent => 48.0;  // ارتفاع الرأس الثابت

  @override
  double get minExtent => 48.0;  // ارتفاع الرأس عند الانزلاق

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
