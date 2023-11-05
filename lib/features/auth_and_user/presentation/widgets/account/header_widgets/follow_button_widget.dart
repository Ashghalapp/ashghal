import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowWidgetButton extends StatelessWidget {
  final bool isSending;
  final bool isFollowHim;
  final bool isFollowMe;
  final void Function() submitFollowButton;
  FollowWidgetButton({
    super.key,
    required this.isSending,
    required this.isFollowHim,
    required this.isFollowMe,
    required this.submitFollowButton,
  });

  String followText = "Follow";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: ElevatedButton.icon(
        onPressed: submitFollowButton,
        icon: getFollowIcon(),
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

  Widget getFollowIcon() {
    if (isSending) {
      return AppUtil.addProgressIndicator(
          18, Get.textTheme.displayLarge?.color);
    } else if (!isFollowHim && !isFollowMe) {
      followText = "Follow";
      return Icon(
        Icons.person_add_alt_1,
        color: Get.textTheme.displayLarge?.color,
        size: 25,
      );
    } else if (isFollowHim && !isFollowMe) {
      followText = "Followed";
      return Image.asset("assets/icons/person_followed.png",
          width: 25, height: 25);
    } else if (isFollowMe && !isFollowHim) {
      followText = "Follow back";
      return const SizedBox();
    } else { // if (followHim && followMe) {
      followText = "Friends";
      return Image.asset("assets/icons/person_friends3.png",
          width: 25, height: 25);
    }
  }
}
