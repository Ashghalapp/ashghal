import 'dart:async';

import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/widget/posts_builder_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/filled_outline_button.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/post_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/ScrollerAppBar.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/jump_to_top_or_bottom_Button.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_widget.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../config/app_icons.dart';

class PostsScreen extends StatelessWidget {
  PostsScreen({super.key});

  final scrollController = ScrollController();

  final RxBool _showJumpTopButton = false.obs;

  // late final PostController postController = Get.put(PostController());
  late final PostController postController = Get.find();

  @override
  Widget build(BuildContext context) {
    // if (postController.postList.isEmpty) {
    //   postController.getAlivePosts();
    // }

    return RefreshIndicator(
      onRefresh: postController.refreshFilteredPosts,
      child: SafeArea(
        child: Scaffold(
          // backgroundColor: const Color.fromARGB(255, 224, 227, 232),
          body: Column(
            children: [
              ScrollerAppBar(
                pageScrollController: scrollController,
                title: "Posts",
                action: [
                  IconButton(
                    icon: SvgPicture.asset(
                      AppIcons.chatBorder,
                      width: 25,
                      height: 25,
                      colorFilter: const ColorFilter.mode(
                          AppColors.iconColor, BlendMode.srcIn),
                    ),
                    onPressed: () => Get.to(() => ChatScreen()),
                  ),
                ],
                bottom: Obx(() => buildFilterButtons()),
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
              // Expanded(child: Obx(() => postsBuilder())),
              Expanded(
                child: Obx(
                  () => PostsBuilderWidget(
                    posts: postController.filteredPosts,
                    onIndexChange: (index) {
                      if (index == postController.filteredPosts.length - 3 &&
                          index != postController.lastIndexToGetNextPage) {
                        postController.lastIndexToGetNextPage = index;
                        print(
                            "=========last index ${postController.lastIndexToGetNextPage}");
                        postController.loadNextPageOfFilteredPosts();
                        // postController.lastIndexToGetNewPage = index;
                      }
                      // if (index == searchController.postsList.length - 3 &&
                      //     index != searchController.postLastIndexToGetNextPage) {
                    },
                    getPopupMenuFunction:
                        postController.getPostMenuButtonValuesWidget,
                    isRequestFinishWithoutData:
                        postController.isRequestFinishWithoutData,
                    // searchController.isPostsRequestFinishWithoutData,
                    // searchController.postsFilterModel.isRequestFinishWithoutData,
                    faildDownloadWidget: buildFaildDownloadPostsWidget(),
                  ),
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

    // onPressed: () => WidgetsBinding.instance.addPostFrameCallback(
    //   (_) async => await Scrollable.ensureVisible(
    //       const GlobalObjectKey(10).currentContext!),
    // ),
    // child: const Text("Scroll to data"),
    // )),
  }

  // Widget postsBuilder() {
  //   final posts = postController.filteredPosts;
  //   return posts.isNotEmpty
  //       ? ListView.builder(
  //           controller: scrollController,
  //           shrinkWrap: true,
  //           itemBuilder: (context, index) {
  //             print("------------Posts number $index");

  //             if (index == posts.length - 3 &&
  //                 index != postController.lastIndexToGetNextPage) {
  //               postController.loadNextPageOfFilteredPosts();
  //               // postController.lastIndexToGetNewPage = index;
  //               postController.lastIndexToGetNextPage = index;
  //             }
  //             print(
  //                 "------------last index ${postController.lastIndexToGetNextPage}");
  //             // print(
  //             // "------------last loaded index ${postController.lastIndexToGetNewPage}");
  //             if (index < posts.length) {
  //               return PostCardWidget(
  //                 // key: GlobalObjectKey(postController.postList[index].id),
  //                 post: posts[index],
  //                 postMenuButton: postController.getPostMenuButtonValuesWidget(
  //                   posts[index].id,
  //                 ),
  //               );
  //             }
  //             return null;
  //           },
  //           itemCount: posts.length,
  //         )
  //       : postController.isRequestFinishWithoutData.value
  //           ? buildFaildDownloadPostsWidget()
  //           : PostShimmer(width: Get.width, shimmerNumber: 2);
  // }

  // Widget _postsBuilder() {
  //   return postController.alivePostsList.isNotEmpty
  //       ? ListView.builder(
  //           controller: scrollController,
  //           shrinkWrap: true,
  //           itemBuilder: (context, index) {
  //             print("------------Posts number $index");
  //             if (index == postController.alivePostsList.length - 3 &&
  //                 index != postController.lastIndexToGetNPage) {
  //               postController.loadNextPageOfAlivePosts();
  //               postController.lastIndexToGetNewPage = index;
  //             }
  //             if (index < postController.alivePostsList.length) {
  //               return PostWidget(
  //                 // key: GlobalObjectKey(postController.postList[index].id),
  //                 post: postController.alivePostsList[index],
  //                 postMenuButton: postController.getPostMenuButtonValuesWidget(
  //                   postController.alivePostsList[index].id,
  //                 ),
  //               );
  //             }
  //             return null;
  //           },
  //           itemCount: postController.alivePostsList.length,
  //         )
  //       : postController.isRequestFinishWithoutData
  //           ? buildFaildDownloadPostsWidget()
  //           : PostShimmer(width: Get.width, shimmerNumber: 2);
  // }

  Widget buildFaildDownloadPostsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalization.thereIsSomethingError),
          const SizedBox(height: 10),
          TextButton(
            onPressed: postController.refreshFilteredPosts,
            child: const Text(
              "Try again",
              // style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  /// A list of filters
  SizedBox buildFilterButtons() {
    return SizedBox(
      // height: _showAppbar.value? 50 : 0,
      height: 50,
      child: ListView(
        padding: const EdgeInsets.only(left: 10, top: 7, bottom: 7),
        scrollDirection: Axis.horizontal,
        children: [
          for (PostFilters filter in PostFilters.values)
            _buildFilterButton(filter),
        ],
      ),
    );
  }

  /// Filter outlined button
  Padding _buildFilterButton(PostFilters filter) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: CustomOutlineButton(
        isFilled: postController.appliedFilter.value == filter,
        text: filter.value,
        onPress: () => postController.applyFilter(filter),
      ),
    );
  }
}
