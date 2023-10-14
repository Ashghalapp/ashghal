import 'dart:async';

import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/post_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/ScrollerAppBar.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/jump_to_top_or_bottom_Button.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_card_widget.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsScreen extends StatelessWidget {
  final PostController postController = Get.put(PostController());
  PostsScreen({super.key});
  final RxBool _showJumpTopButton = true.obs;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: postController.getAlivePosts,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 224, 227, 232),
          body: Column(
            children: [
              ScrollerAppBar(
                controller: postController.scrollController,
                title: "Posts",
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
                child: Obx(
                  () => postController.postList.isNotEmpty
                      ? ListView.builder(
                          controller: postController.scrollController,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            print("------------Posts number $index");
                            if (index == postController.postList.length - 3 &&
                                index != postController.lastIndexToGetNewPage) {
                              postController.loadNextPageOfPosts();
                              postController.lastIndexToGetNewPage = index;
                            }
                            if (index < postController.postList.length) {
                              return PostCardWidget(
                                key: GlobalObjectKey(
                                    postController.postList[index].id),
                                post: postController.postList[index],
                              );
                            }
                            return null;
                          },
                          itemCount: postController.postList.length,
                        )
                      : postController.isRequestFinishWithoutData
                          ? buildFaildDownloadPostsWidget()
                          : PostShimmer(width: Get.width, shimmerNumber: 2),
                ),
              ),
            ],
          ),

          floatingActionButton: Obx(
            () => AnimatedJumpToTopOrBottomButton(
              controller: postController.scrollController,
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

  Widget buildFaildDownloadPostsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalization.thereIsSomethingError),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: postController.refreshPosts,
            child: const Text(
              "Try again",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
