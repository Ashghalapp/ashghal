import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/user_card_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_shimmer.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersBuilderWidget extends StatelessWidget {
  final RxList<User> users;
  // final int lastIndexToGetNextPage;
  final void Function(int index) onIndexChange;
  final RxBool isRequestFinishWithoutData;
  final ScrollController? scrollController;
  final Widget faildDownloadWidget;
  const UsersBuilderWidget({
    super.key,
    required this.users,
    this.scrollController,
    required this.onIndexChange,
    required this.isRequestFinishWithoutData,
    required this.faildDownloadWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => users.isNotEmpty
          ? ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print("------------Posts number $index");
                onIndexChange(index);

                if (index < users.length) {
                  return UserCardWidget(user: users[index]);
                }
                return null;
              },
              itemCount: users.length,
            )
          : isRequestFinishWithoutData.value
              ? faildDownloadWidget
              : AppUtil.getShimmerForFullPage(),
    );
  }
}
