import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/features/account/Screen/account_screen.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/post_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/report_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/images_post_design_as_facebook.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/post_and_comments_screen.dart';
import 'package:ashghal_app_frontend/core/widget/circle_cached_networkimage.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final PopupMenuButtonWidget postMenuButton;
  PostWidget({super.key, required this.post, required this.postMenuButton});

  final ReportController reportController = Get.put(ReportController());
  // final PostController postsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.5),
      width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.white,
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleCachedNetworkImageWidget(
              imageUrl: post.basicUserData['image_url']?.toString(),
              onTap: () => Get.to(
                () => AccountScreen(
                  userId: int.parse(post.basicUserData['id'].toString()),
                ),
              ),
            ),
            title: SelectableText(post.basicUserData['name']?.toString() ?? ""),
            subtitle: SelectableText(
              DateFormat('yyyy-MMM-dd').format(post.createdAt),
              style: Get.textTheme.bodySmall,
            ),
            trailing: postMenuButton,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextWidget(
                  text: post.title,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildTextWidget(text: post.content),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child:
                ImagesPostDesignAsFacebook(multimedia: post.multimedia ?? []),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(
              color: Get.theme.dividerColor,
              thickness: 0.2,
              height: 6,
            ),
          ),
          buildPostBottomButtons(),
        ],
      ),
    );
  }

  Widget buildTextWidget({
    required String text,
    TextStyle? style,
  }) {
    return SelectableText(
      text,
      style: style,
    );
  }

  Widget buildPostBottomButtons() {
    return SizedBox(
      // height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CustomTextAndIconAndCircleCounterButton(
            text:
                Text(AppLocalization.comment, style: Get.textTheme.bodyMedium),
            onPressed: () => Get.to(() => PostCommentsScreen(post: post)),
            icon: const Icon(Icons.mode_comment_outlined, color: Colors.grey),
            count: post.commentsCount.toString(),
          ),
          Container(width: 0.5, height: 20, color: Colors.grey),
          CustomTextAndIconButton(
            text: Text(
              post.isComplete
                  ? AppLocalization.completed
                  : AppLocalization.incomplete,
              style: Get.textTheme.bodyMedium,
            ),
            onPressed: () {},
            icon: const Icon(null, size: 0),
          ),
          Container(width: 0.5, height: 20, color: Colors.grey),
          CustomTextAndIconButton(
            text: Text("Favorite", style: Get.textTheme.bodyMedium),
            onPressed: () {
              // postsController.isFavorite.value =
              //     !postsController.isFavorite.value;
            },
            icon: const Icon(Icons.favorite_border, color: Colors.grey
                // postsController.isFavorite.value ? Colors.red : Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
