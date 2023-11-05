import 'dart:async';
import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'tab_bar_sliver_persistent_header_delegate.dart';

/// widget that make nested scroll between the header and the tabview widgets
class AccountNestedScrollViewWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final ScrollController? scrollController;
  final Widget header;
  final Widget pageView1;
  final Widget pageView2;
  const AccountNestedScrollViewWidget({
    super.key,
    required this.onRefresh,
    this.scrollController,
    required this.header,
    required this.pageView1,
    required this.pageView2,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      notificationPredicate: (notification) {
        // print("<<<<<<<<<<<<<<<<<${notification.depth}>>>>>>>>>>>>>>>>>>");
        return notification.depth == 0 || notification.depth == 2;
      },
      onRefresh: onRefresh,
      child: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (_, bool innerBoxIsScrolled) => [
          // build the header of screen that contains user image, name, statistics
          SliverToBoxAdapter(
            child: header,
          ),

          // the tabBar of screen
          SliverPersistentHeader(
            pinned: true,
            delegate: TabBarSliverPersistentHeaderDelegate(
              child: SizedBox(
                height: 48,
                child: Center(child: Text(AppLocalization.posts, style: Get.textTheme.titleMedium,)),
              ),
            ),
          ),
        ],
        body: pageView1,
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //     length: 2,
  //     child: RefreshIndicator(
  //       notificationPredicate: (notification) {
  //         // print("<<<<<<<<<<<<<<<<<${notification.depth}>>>>>>>>>>>>>>>>>>");
  //         return notification.depth == 0 || notification.depth == 2;
  //       },
  //       onRefresh: onRefresh,
  //       child: NestedScrollView(
  //         controller: scrollController,
  //         headerSliverBuilder: (_, bool innerBoxIsScrolled) => [
  //           // build the header of screen that contains user image, name, statistics
  //           SliverToBoxAdapter(
  //             child: header,
  //           ),

  //           // the tabBar of screen
  //           SliverPersistentHeader(
  //             pinned: true,
  //             delegate: TabBarSliverPersistentHeaderDelegate(
  //               child: SizedBox(
  //                 height: 48,
  //                 child: TabBar(
  //                   // key: const GlobalObjectKey("posts"),
  //                   indicatorColor: Get.theme.colorScheme.onBackground,
  //                   unselectedLabelColor: AppColors.iconColor,
  //                   tabs: const [
  //                     Tab(icon: Icon(Icons.grid_on)),
  //                     Tab(icon: Icon(Icons.favorite_border))
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //         body: TabBarView(
  //           children: [
  //             pageView1,
  //             pageView2,
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // List<Widget> headerSliverBuilderFunction(_, bool innerBoxIsScrolled) {
  //   return [
  //     // build the header of screen that contains user image, name, statistics
  //     SliverToBoxAdapter(
  //       child: header,
  //     ),

  //     // the tabBar of screen
  //     SliverPersistentHeader(
  //       pinned: true,
  //       delegate: TabBarSliverPersistentHeaderDelegate(
  //         child: SizedBox(
  //           height: 48,
  //           child: TabBar(
  //             key: const GlobalObjectKey("posts"),
  //             indicatorColor: Get.theme.colorScheme.onBackground,
  //             tabs: const [
  //               Tab(icon: Icon(Icons.grid_on)),
  //               Tab(icon: Icon(Icons.person_outline))
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   ];
  // }
}
