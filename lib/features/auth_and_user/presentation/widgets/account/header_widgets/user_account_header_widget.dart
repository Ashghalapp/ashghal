import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/account/more_acccount_details_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/account/specific_user_account_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/header_widgets/follow_button_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/header_widgets/provider_data_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/header_widgets/statistics_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/header_widgets/user_image_with_back_shape_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UserAccountHeaderWidget extends StatelessWidget {
  final User user;
  UserAccountHeaderWidget({super.key, required this.user});

  late final userController =
      Get.find<SpecificUserAccountController>(tag: user.id.toString());
      
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // صورة المستخدم مع الشكل الخلفي للصورة
        UserImageWithBackShapeWidget(
          imageUrl: user.imageUrl,
          aboveWidget: [
            // back icon button
            Container(
              alignment: AlignmentDirectional.topStart,
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
              ),
            ),

            // details icon button
            Container(
              alignment: AlignmentDirectional.topEnd,
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () =>
                    Get.to(() => MoreAccountDetailsScreen(user: user)),
                icon: const Icon(Icons.info),
              ),
            ),
          ],
        ),

        // name widget
        Center(
          child: Text(
            user.name,
            style: Get.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 10),

        // the statistics widget
        StatisticsWidget(
          userId: user.id,
          followers: user.followersUsers.length,
          followings: user.followingUsers.length,
          posts: user.postsCount,
        ),

        // follow and chat buttons
        const SizedBox(height: 10),
        Obx(
          () => _buildFollowingAndChatButtonsWidget(),
        ),

        // provider data of user widget
        const SizedBox(height: 10),
        if (user.provider != null) ProviderDataWidget(provider: user.provider!),
      ],
    );
  }

  Widget _buildFollowingAndChatButtonsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // follow button
        FollowWidgetButton(
          isSending: userController.sendingFollowRequest.value,
          isFollowHim: userController.meFollowHim.value,
          isFollowMe: userController.heFollowMe.value,
          submitFollowButton: () => userController.submitFollowButton(),
        ),
        const SizedBox(width: 10),

        // chat button
        Material(
          borderRadius: BorderRadius.circular(8),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextAndIconButton(
              height: 40,
              icon: SvgPicture.asset(
                AppIcons.chatBorder,
                height: 20,
                colorFilter: const ColorFilter.mode(AppColors.iconColor, BlendMode.srcIn),
              ),
              onPressed: () {
                Get.to(() => ChatScreen(conversationId: userController.userId));
              },
              text: Text(
               AppLocalization.message,
                style: Get.textTheme.bodyMedium
                    ?.copyWith(color: Get.textTheme.bodyMedium?.color),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String followText = "Follow";
  Widget getFollowIcon(bool isSending, bool followHim, bool followMe) {
    if (isSending) {
      return AppUtil.addProgressIndicator(
          18, Get.textTheme.displayLarge?.color);
    } else if (!followHim && !followMe) {
      followText = "Follow";
      return Icon(
        Icons.person_add_alt_1,
        color: Get.textTheme.displayLarge?.color,
        size: 25,
      );
    } else if (followHim && !followMe) {
      followText = "Followed";
      return Image.asset("assets/icons/person_followed.png",
          width: 25, height: 25);
    } else if (followMe && !followHim) {
      followText = "Follow back";
      return const SizedBox();
    } else {
      //if (followHim && followMe) {
      followText = "Friends";
      return Image.asset("assets/icons/person_friends3.png",
          width: 25, height: 25);
    }
  }

  Widget _buildFollowButton(bool isSending, bool followHim, bool followMe) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      // width: Get.width / 3,
      child: ElevatedButton.icon(
        onPressed: () => userController.submitFollowButton(),
        icon: getFollowIcon(isSending, followHim, followMe),
        label: Text(
          followText, // ? "Followed" : "Follow",
          style: Get.textTheme.bodyMedium
              ?.copyWith(color: Get.textTheme.displayLarge?.color),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
