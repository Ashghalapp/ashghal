import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/posts_builder_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/account/specific_user_account_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/account_nested_scroll_view_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/header_widgets/user_account_header_widget.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_shimmer.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'PostPageView.dart';

class SpecificUserAccountScreen extends StatelessWidget {
  final int userId;
  SpecificUserAccountScreen({super.key, required this.userId});

  late final userController =
      Get.put(SpecificUserAccountController(userId), tag: userId.toString());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AccountNestedScrollViewWidget(
          onRefresh: userController.refreshData,
          // scrollController: scrollController,
          header: Obx(
            () => userController.userData.value != null
                ? UserAccountHeaderWidget(user: userController.userData.value!)
                : AppUtil.getShimmerForFullPage(),
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
                userController.loadNextPageOfSpecificUserPosts();
              }
            },
            getPopupMenuFunction: AppUtil.getPostMenuButtonValuesWidget,
            isRequestFinishWithoutData:
                userController.isRequestFinishWithoutData,
            faildDownloadWidget: buildFaildDownloadPostsWidget(),
          ),
          pageView2: const PostPageView(),
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
  //               userController.loadNextPageOfSpecificUserPosts();
  //               userController.lastIndexToGetNextPage = index;
  //             }
  //             if (index < userController.postList.length) {
  //               return PostCardWidget(
  //                 post: userController.postList[index],
  //                 postMenuButton: userController.getPostMenuButtonValuesWidget(
  //                     userController.postList[index].id),
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
}
