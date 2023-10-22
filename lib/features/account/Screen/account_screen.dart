import 'dart:async';

import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/account/getx/current_user_account_controller.dart';
import 'package:ashghal_app_frontend/features/account/widgets/header_widgets/profile_account_header_widget.dart';
import 'package:ashghal_app_frontend/features/account/widgets/header_widgets/user_account_header_widget.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_widget.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_shimmer.dart';
import 'package:ashghal_app_frontend/mainscreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'PostPageView.dart';
import '../tab_bar_sliver_persistent_header_delegate.dart';

class AccountScreen extends StatelessWidget {
  final int? userId;
  AccountScreen({super.key, this.userId});

  // final currentUserData = SharedPref.getCurrentUserData();

  late final userController =
      Get.put(CurrentUserAccountController(userId), tag: userId?.toString());
  // late final userController = Get.find<CurrentUserPostsController>();

  final RxBool _showAddButton = true.obs;

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(scrollListenerFunction);

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: RefreshIndicator(
          notificationPredicate: (notification) {
            // print("<<<<<<<<<<<<<<<<<${notification.depth}>>>>>>>>>>>>>>>>>>");
            return notification.depth == 0 || notification.depth == 2;
          },
          onRefresh: () async => await userController.refreshData(),
          child: Scaffold(
            body: NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: headerSliverBuilderFunction,
              body: TabBarView(
                children: [
                  postsBuilder(),
                  const PostPageView(),
                ],
              ),
            ),
            floatingActionButton: userId == null
                ? Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _showAddButton.value ? 53 : 0,
                      width: 53,
                      child: FloatingActionButton(
                        onPressed: () {
                          Get.find<MainScreenController>().changePage(2);
                        },
                        shape: const CircleBorder(),
                        elevation: 4,
                        tooltip: AppLocalization.addNewPost,
                        child: Icon(Icons.add,
                            size: _showAddButton.value ? 25 : 0),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  _buildUserInfoInBottomScreen() {
    return Obx(
      () {
        final userData = userController.userData;
        if (userData.value != null) {
          return Column(
            children: [
              Text("Join at: ${userData.value!.createdAt}"),
              Text("Gender: ${userData.value!.gender.name}"),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  List<Widget> headerSliverBuilderFunction(_, bool innerBoxIsScrolled) {
    return [
      // build the header of screen that contains user image, name, statistics
      SliverToBoxAdapter(
        child: Obx(
          () {
            if (userController.userData.value != null) {
              return userId != null
                  ? UserAccountHeaderWidget(
                      user: userController.userData.value!)
                  : ProfileAccountHeaderWidget(
                      user: userController.userData.value!);
            } else if (userId == null) {
              // final userOfflineData = userController.getCurrentUserDataOffline
              return ProfileAccountHeaderWidget(
                user: userController.getCurrentUserDataOffline,
              );
            } else {
              return AppUtil.getShimmerForFullPage();
            }
          },
        ),
      ),

      // the tabBar of screen
      SliverPersistentHeader(
        pinned: true,
        delegate: TabBarSliverPersistentHeaderDelegate(
          child: SizedBox(
            height: 48,
            child: TabBar(
              key: const GlobalObjectKey("posts"),
              indicatorColor: Get.theme.colorScheme.onBackground,
              tabs: const [
                Tab(icon: Icon(Icons.grid_on)),
                Tab(icon: Icon(Icons.person_outline))
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget postsBuilder() {
    return Obx(
      () => userController.postList.isNotEmpty
          ? ListView.builder(
              // controller: scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print("------------Posts number $index");
                if (index == userController.postList.length - 3 &&
                    index != userController.lastIndexToGetNewPage) {
                  userController.loadNextPageOfCurrentUserPosts();
                  userController.lastIndexToGetNewPage = index;
                }
                if (index < userController.postList.length) {
                  return PostWidget(
                    post: userController.postList[index],
                    postMenuButton:
                        userController.getPostMenuButtonValuesWidget(
                            userController.postList[index].id),
                  );
                }
                return null;
              },
              itemCount: userController.postList.length,
            )
          : userController.isRequestFinishWithoutData
              ? buildFaildDownloadPostsWidget()
              : PostShimmer(width: Get.width, shimmerNumber: 1),
    );
  }

  Widget buildFaildDownloadPostsWidget() {
    return Center(
      child: Text(AppLocalization.youHaveNotPostsYet),
    );
  }

  void scrollListenerFunction() {
    if (scrollController.offset < 250) {
      _showAddButton.value = true;
      return;
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _showAddButton.value = false;
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _showAddButton.value = true;
    }
    if (_showAddButton.value) {
      Timer(const Duration(seconds: 3), () {
        _showAddButton.value = false;
      });
    }
  }
}
