import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_shimmer.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsBuilderWidget extends StatelessWidget {
  final RxList<Post> posts;
  // final int lastIndexToGetNextPage;
  final void Function(int index) onIndexChange;
  final PopupMenuButtonWidget Function(Post post) getPopupMenuFunction;
  final RxBool isRequestFinishWithoutData;
  final ScrollController? scrollController;
  final Widget faildDownloadWidget;
  const PostsBuilderWidget({
    super.key,
    required this.posts,
    this.scrollController,
    // required this.lastIndexToGetNextPage,
    required this.onIndexChange,
    required this.getPopupMenuFunction,
    required this.isRequestFinishWithoutData,
    required this.faildDownloadWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => posts.isNotEmpty
          ? ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print("------------Posts number $index of ${posts.length}");
                onIndexChange(index);
                // if (index == posts.length - 3 &&
                //     index != lastIndexToGetNextPage) {
                //   onIndexChange(index);
                //   // postController.lastIndexToGetNewPage = index;
                //   // postController.lastIndexToGetNextPage = index;
                // }
                // print("------------last index ${lastIndexToGetNextPage}");
                // print(
                // "------------last loaded index ${postController.lastIndexToGetNewPage}");
                if (index < posts.length) {
                  return PostCardWidget(
                      post: posts[index],
                      postMenuButton: getPopupMenuFunction(posts[index])
                      );
                }
                return null;
              },
              itemCount: posts.length,
            )
          : isRequestFinishWithoutData.value
              ? faildDownloadWidget
              : PostShimmer(width: Get.width, shimmerNumber: 2),
    );
  }
}
