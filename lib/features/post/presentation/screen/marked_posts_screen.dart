import 'dart:async';

import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/posts_builder_widget.dart';
import 'package:ashghal_app_frontend/core/widget/scale_down_transition.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/marked_posts_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/ScrollerAppBar.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/jump_to_top_or_bottom_Button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarkedPostsScreen extends StatelessWidget {
  MarkedPostsScreen({super.key});

  late final markedPostsController = Get.put(MarkedPostsController());
  final scrollController = ScrollController();
  final RxBool _showJumpTopButton = false.obs;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: markedPostsController.getMarkedPosts,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              ScrollerAppBar(
                title: AppLocalization.markedPosts,
                pageScrollController: scrollController,
                action: [
                  ScaleDownTransitionWidget(
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: markedPostsController.getMarkedPosts,
                    ),
                  ),
                ],
                onScrollDirectionChange: (scrollDirection, isAppBarShow) {
                  _showJumpTopButton.value = isAppBarShow;
                  if (_showJumpTopButton.value) {
                    Timer(
                      const Duration(seconds: 3),
                      () {
                        _showJumpTopButton.value = false;
                      },
                    );
                  }
                },
              ),
              Expanded(
                child: PostsBuilderWidget(
                  scrollPhysics: const AlwaysScrollableScrollPhysics(),
                  posts: markedPostsController.markedPostList,
                  onIndexChange: (index) {},
                  // onIndexChange: (index) {
                  //   if (index == markedPostsController.markedPostList.length - 3 &&
                  //       index != markedPostsController.lastIndexToGetNextPage) {
                  //     markedPostsController.lastIndexToGetNextPage = index;
                  //     print("=========last index ${userController.lastIndexToGetNextPage}");
                  //     userController.loadNextPageOfCurrentUserPosts();
                  //   }
                  // },
                  getPopupMenuFunction: AppUtil.getPostMenuButtonValuesWidget,
                  isRequestFinishWithoutData:
                      markedPostsController.isMarketRequestFinishWithoutData,
                  faildDownloadWidget: buildFaildDownloadPostsWidget(),
                ),
              ),
            ],
          ),
          floatingActionButton: Obx(
            () => AnimatedJumpToTopOrBottomButton(
              controller: scrollController,
              height: _showJumpTopButton.value ? 40 : 0.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFaildDownloadPostsWidget() {
    return Center(
      child: Text(AppLocalization.notFound),
    );
  }
}
