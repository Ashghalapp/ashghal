import 'dart:async';

import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/widget/posts_builder_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/account/current_user_account_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/account_nested_scroll_view_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/header_widgets/profile_account_header_widget.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_shimmer.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_widget.dart';
import 'package:ashghal_app_frontend/mainscreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'PostPageView.dart';

class CurrentUserAccountScreen extends StatelessWidget {
  CurrentUserAccountScreen({super.key});

  late final userController = Get.find<CurrentUserAccountController>();

  final RxBool _showAddButton = true.obs;

  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    scrollController.addListener(scrollListenerFunction);

    // refresh user data when back from settings and anothe causes.
    userController.userData.value = userController.getCurrentUserDataOffline;

    return SafeArea(
      child: Scaffold(
        body: AccountNestedScrollViewWidget(
          onRefresh: userController.refreshData,
          scrollController: scrollController,
          header: Obx(
            () => ProfileAccountHeaderWidget(
              user: userController.userData.value != null
                  ? userController.userData.value!
                  : userController.getCurrentUserDataOffline!,
            ),
          ),
          // pageView1: Obx(() => postsBuilder()),
          pageView1: PostsBuilderWidget(
            posts: userController.postList,
            onIndexChange: (index) {
              if (index == userController.postList.length - 3 &&
                  index != userController.lastIndexToGetNextPage) {
                userController.lastIndexToGetNextPage = index;
                print(
                    "=========last index ${userController.lastIndexToGetNextPage}");
                userController.loadNextPageOfCurrentUserPosts();
              }
            },
            getPopupMenuFunction: userController.getPostMenuButtonValuesWidget,
            isRequestFinishWithoutData:
                userController.isRequestFinishWithoutData,
            faildDownloadWidget: buildFaildDownloadPostsWidget(),
          ),
          pageView2: const PostPageView(),
        ),
        floatingActionButton: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showAddButton.value ? 53 : 0,
            width: 53,
            child: FloatingActionButton(
              onPressed: () {
                Get.find<MainScreenController>().changePage(2);
              },
              // shape: const CircleBorder(),
              // elevation: 4,
              tooltip: AppLocalization.addNewPost,
              child: Icon(Icons.add, size: _showAddButton.value ? 25 : 0),
            ),
          ),
        ),
      ),
    );
  }

  // Widget postsBuilder() {
  //   return userController.postList.isNotEmpty
  //       ? ListView.builder(
  //           // controller: scrollController,
  //           shrinkWrap: true,
  //           itemBuilder: (context, index) {
  //             print("------------Posts number $index");
  //             if (index == userController.postList.length - 3 &&
  //                 index != userController.lastIndexToGetNextPage) {
  //               userController.loadNextPageOfCurrentUserPosts();
  //               userController.lastIndexToGetNextPage = index;
  //             }
  //             if (index < userController.postList.length) {
  //               return PostCardWidget(
  //                 post: userController.postList[index],
  //                 postMenuButton:
  //                     userController.getPostMenuButtonValuesWidget(index),
  //               );
  //             }
  //             return null;
  //           },
  //           itemCount: userController.postList.length,
  //         )
  //       : userController.isRequestFinishWithoutData.value
  //           ? buildFaildDownloadPostsWidget()
  //           : PostShimmer(width: Get.width, shimmerNumber: 1);
  // }

  Widget buildFaildDownloadPostsWidget() {
    return Center(
      child: Text(AppLocalization.youHaveNotPostsYet),
    );
  }

  void scrollListenerFunction() {
    if (scrollController.offset < 250) {
      _showAddButton.value = true;
      return;
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _showAddButton.value = false;
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _showAddButton.value = true;
    }
    if (_showAddButton.value) {
      Timer(const Duration(seconds: 3), () {
        _showAddButton.value = false;
      });
    }
  }
}
