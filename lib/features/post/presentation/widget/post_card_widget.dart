import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/post_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/report_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/images_post_design_as_facebook.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/post_and_comments_screen.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/circle_cached_networkimage.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostCardWidget extends StatelessWidget {
  final Post post;
  final ReportController reportController = Get.put(ReportController());
  final PostController postsController = Get.find();
  PostCardWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: buildCircleCachedNetworkImage(
              imageUrl: post.basicUserData['image_url']?.toString(),
            ),
            title: Text(post.basicUserData['name']?.toString() ?? ""),
            subtitle: buildPostsContentText(
              text: post.createdAt.toIso8601String().substring(0, 10),
              fontSize: 11,
            ),
            trailing: PopupMenuButtonWidget(
              values: OperationsOnPostPopupMenuValues.values
                  .asNameMap()
                  .keys
                  .toList(),
              onSelected: (value) =>
                  postsController.postPopupMenuButtonOnSelected(value, post.id),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildPostsContentText(
                  text: post.title,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                buildPostsContentText(text: post.content),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child:
                ImagesPostDesignAsFacebook(multimedia: post.multimedia ?? []),
          ),
          const Divider(color: Colors.black45, thickness: 0.2),
          buildPostBottomButtons(),
        ],
      ),
    );
  }

  Widget buildPostsContentText({
    // AlignmentGeometry alignment =
    double? fontSize,
    FontWeight? fontWeight,
    Color color = Colors.black,
    required String text,
  }) {
    return Container(
      alignment: Get.locale?.languageCode == 'ar'
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? Get.textTheme.bodyMedium?.fontSize ?? 14.0,
          fontWeight: fontWeight ??
              Get.textTheme.bodyMedium?.fontWeight ??
              FontWeight.normal,
          color: color,
        ),
      ),
    );
  }

  Widget buildPostBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        CustomTextAndIconAndCircleCounterButton(
          text: Text("  Comment  ", style: Get.textTheme.bodyMedium),
          onPressed: () => Get.to(() => PostCommentsScreen(post: post)),
          icon: const Icon(Icons.comment, color: Colors.grey),
          count: post.commentsCount.toString(),
        ),
        CustomTextAndIconButton(
          text: Text("  Favorite  ", style: Get.textTheme.bodyMedium),
          onPressed: () {
            postsController.isFavorite.value =
                !postsController.isFavorite.value;
          },
          icon: Obx(
            () => Icon(
              Icons.favorite,
              color:
                  postsController.isFavorite.value ? Colors.red : Colors.grey,
            ),
          ),
        ),
        // InkWell(
        //   // splashColor: Colors.red,
        //   child: Row(
        //     children: <Widget>[
        //       const Icon(Icons.comment),
        //       const Text("  Comment  "),
        //       CircleAvatar(
        //         radius: 8,
        //         backgroundColor: Colors.grey,
        //         child: Text(
        //           post.commentsCount.toString(),
        //           style: Get.textTheme.bodySmall?.copyWith(
        //             color: Colors.white
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        //   onTap: () => Get.to(() => PostCommentsScreen(post: post)),
        // ),
        // InkWell(
        //   child: Row(
        //     children: <Widget>[
        //       Obx(
        //         () => Icon(
        //           Icons.favorite,
        //           color: postsController.isFavorite.value ? Colors.red : null,
        //         ),
        //       ),
        //       const Text("  Favorite"),
        //     ],
        //   ),
        //   onTap: () {
        //     postsController.isFavorite.value =
        //         !postsController.isFavorite.value;
        //   },
        // ),
      ],
    );
  }
}
