import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/util/bottom_sheet_util.dart';
import 'package:ashghal_app_frontend/core/widget/circle_cached_networkimage.dart';
import 'package:ashghal_app_frontend/core/widget/user_card_widget.dart';
import 'package:ashghal_app_frontend/core/widget/users_builder_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/account/follow_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// لبناء صف يحتوي على عدد المتابعين والمتابعات والاعجابات widget
class StatisticsWidget extends StatelessWidget {
  final int userId;
  final int followers;
  final void Function()? onFollowersTap;
  final int followings;
  final void Function()? onFollowingsTap;
  final int posts;
  final void Function()? onPostsTap;
  StatisticsWidget({
    super.key,
    required this.userId,
    required this.followers,
    this.onFollowersTap,
    required this.followings,
    this.onFollowingsTap,
    required this.posts,
    this.onPostsTap,
  });

  /// استنادا لرقم التاج حتى يتم تعريف لكل مستخدم متحكم منفصل عن  controller تعريف
  /// الاخر وحذف هذا المتحكم عند الخروج من صفحة المستخدم، ما عدا المستخدم الحالي
  late final followController =
      Get.put(FollowController(), tag: userId.toString());
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // followers
        _buildStatisticColumn(
          text: AppLocalization.followers,
          count: followers,
          onTap: () {
            followController.getFollowers(userId);
            BottomSheetUtil.buildBottomsheet(
              height: Get.height * 0.7,
              // child: _usersBuilder(followController.followersList),
              child: UsersBuilderWidget(
                users: followController.followersModel.users,
                onIndexChange: _onFollowersUserBuilderIndexChange,
                isRequestFinishWithoutData:
                    followController.followersModel.isRequestFinishWithoutData,
                faildDownloadWidget: Center(
                  child: Text(AppLocalization.notFound),
                ),
              ),
            );
          },
        ),
        // followings
        _buildStatisticColumn(
          text: AppLocalization.followings,
          count: followings,
          onTap: () {
            followController.getFollowings(userId);
            BottomSheetUtil.buildBottomsheet(
              height: Get.height * 0.7,
              //   child: _usersBuilder(followController.followingsList),
              // );
              child: UsersBuilderWidget(
                users: followController.followingsModel.users,
                onIndexChange: _onFollowingsUserBuilderIndexChange,
                isRequestFinishWithoutData:
                    followController.followingsModel.isRequestFinishWithoutData,
                faildDownloadWidget: Center(
                  child: Text(AppLocalization.notFound),
                ),
              ),
            );
          },
        ),
        _buildStatisticColumn(text: AppLocalization.posts, count: posts),
        // _buildUserCard(),
      ],
    );
  }

  void _onFollowersUserBuilderIndexChange(int index) {
    print(
        "<<<<<<<<length: ${followController.followersModel.users.length}>>>>>>>>");
    if (index == followController.followersModel.users.length - 3 &&
        index != followController.followersModel.lastIndexToGetNewPage) {
      followController.followersModel.lastIndexToGetNewPage = index;
      print(
          "========last index ${followController.followersModel.lastIndexToGetNewPage}");
      followController.loadNextPageOfFollowers(userId);
    }
  }

  void _onFollowingsUserBuilderIndexChange(int index) {
    print(
        "<<<<<<<<length: ${followController.followingsModel.users.length}>>>>>>>>");
    if (index == followController.followingsModel.users.length - 3 &&
        index != followController.followingsModel.lastIndexToGetNewPage) {
      followController.followingsModel.lastIndexToGetNewPage = index;
      print(
          "========last index ${followController.followingsModel.lastIndexToGetNewPage}");
      followController.loadNextPageOfFollowings(userId);
    }
  }

  Widget _buildStatisticColumn(
      {required String text, required int count, void Function()? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count.toString(),
            style: Get.textTheme.displayLarge
                ?.copyWith(color: Get.theme.primaryColor),
          ),
          Text(text, style: Get.textTheme.bodyMedium),
        ],
      ),
    );
  }

  // Widget _usersBuilder(RxList<User> users) {
  //   return Obx(
  //     () => users.isNotEmpty
  //         ? ListView.builder(
  //             shrinkWrap: true,
  //             itemBuilder: (_, index) {
  //               print("------------User number $index");
  //               if (index < users.length) {
  //                 return UserCardWidget(
  //                   user: users[index],
  //                 );
  //               }
  //               return null;
  //             },
  //             itemCount: users.length,
  //           )
  //         : followController.isRequestFinishWithoutData
  //             ? Center(child: Text(AppLocalization.notFound))
  //             : AppUtil.getShimmerForFullPage(),
  //   );
  // }
}
