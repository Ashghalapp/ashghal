import 'package:ashghal_app_frontend/app_library/public_entities/address.dart';
import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/account/specific_user_account_screen.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/report_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/images_post_design_as_facebook.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/post_and_comments_screen.dart';
import 'package:ashghal_app_frontend/core/widget/circle_cached_networkimage.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PostCardWidget extends StatelessWidget {
  final Post post;
  final PopupMenuButtonWidget postMenuButton;
  PostCardWidget({super.key, required this.post, required this.postMenuButton});

  final ReportController reportController = Get.put(ReportController());
  // final PostController postsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.5),
      width: double.infinity,
      // decoration: BoxDecoration(
      // color: Colors.white,
      // color: Get.theme.cardColor,
      // borderRadius: BorderRadius.circular(12),
      // boxShadow: [
      //   BoxShadow(
      //     color: Get.textTheme.bodyMedium?.color ?? Colors.black,
      //     offset: const Offset(0, 2),
      //     blurRadius: 20,
      //     // spreadRadius: 10
      //   ),
      // ],
      // ),
      child: Material(
        color: Get.theme.cardColor,
        elevation: 3,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 3),
                // user image
                leading: CircleCachedNetworkImageWidget(
                  imageUrl: post.basicUserData['image_url']?.toString(),
                  onTap: () => Get.to(
                    () => SpecificUserAccountScreen(
                      userId: int.parse(post.basicUserData['id'].toString()),
                    ),
                  ),
                ),
                // user name
                title: SelectableText(
                  post.basicUserData['name']?.toString() ?? "",
                  maxLines: 1,
                  style: Get.textTheme.bodyMedium,
                ),

                // category name and time
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      post.categoryData['name']?.toString() ?? "",
                      style: Get.textTheme.bodySmall,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        AppUtil.timeAgoSince(post.createdAt),
                        // DateFormat('yyyy-MMM-dd').format(post.createdAt),
                        style: Get.textTheme.bodySmall
                            ?.copyWith(color: Get.textTheme.titleSmall?.color),
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
                //  SelectableText(
                //   DateFormat('yyyy-MMM-dd').format(post.createdAt),
                //   style: Get.textTheme.bodySmall,
                // ),
                trailing: postMenuButton,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
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
              ImagesPostDesignAsFacebook(multimedia: post.multimedia ?? []),

              // address details
              if (post.address != null)
                ...buildMoreDetailsWidgets(post.address!),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: Get.theme.dividerColor,
                  // thickness: 0.2,
                  height: 6,
                ),
              ),
              buildPostBottomButtons(),
            ],
          ),
        ),
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
          // comment button
          CustomTextAndIconAndCircleCounterButton(
            text: Text(
              AppLocalization.comment,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: !post.allowComment ? Get.theme.disabledColor : null,
              ),
            ),
            onPressed: () {
              // if (post.allowComment) {
              Get.to(() => PostCommentsScreen(post: post));
              // }
            },
            icon: Icon(
                post.allowComment
                    ? Icons.mode_comment_outlined
                    : Icons.comments_disabled_outlined,
                color: AppColors.iconColor),
            count: post.commentsCount.toString(),
          ),
          Container(width: 0.5, height: 20, color: AppColors.iconColor),

          // complete/incomplete button
          CustomTextAndIconButton(
            text: Text(
              post.isComplete
                  ? AppLocalization.completed
                  : AppLocalization.incomplete,
              style: Get.textTheme.bodyMedium
                  ?.copyWith(color: Get.theme.disabledColor),
            ),
            onPressed: () {},
            icon: const Icon(null, size: 0),
          ),
          Container(width: 0.5, height: 20, color: AppColors.iconColor),

          // favorite button
          CustomTextAndIconButton(
            text: Text("Favorite", style: Get.textTheme.bodyMedium),
            onPressed: () {
              // postsController.isFavorite.value =
              //     !postsController.isFavorite.value;
            },
            icon: const Icon(Icons.favorite_border, color: AppColors.iconColor
                // postsController.isFavorite.value ? Colors.red : Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildMoreDetailsWidgets(Address address) {
    return [
      SizedBox(
          width: Get.width / 2,
          height: 6,
          child: Divider(
            color: Get.theme.dividerColor,
          )),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "${address.street}, ", style: Get.textTheme.bodyMedium),
            TextSpan(text: address.city, style: Get.textTheme.bodyMedium),
          ],
        ),
      ),
      if (address.desc != null)
        SelectableText(address.desc!),
    ];
  }
}
