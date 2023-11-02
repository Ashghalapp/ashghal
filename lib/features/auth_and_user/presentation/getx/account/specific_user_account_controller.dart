import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/account/current_user_account_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/follow_user_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/get_current_user_data_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/get_specific_user_data_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/unfollow_user_uc.dart';
import 'package:ashghal_app_frontend/app_library/public_request/pagination_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/post_request/get_user_posts_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/delete_post_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_current_user_posts_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_user_posts_uc.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/add_update_post_screen.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../../../core/services/dependency_injection.dart' as di;

class SpecificUserAccountController extends GetxController {
  final int userId;
  SpecificUserAccountController(this.userId);

  RxList<Post> postList = <Post>[].obs;

  Rx<User?> userData = Rx(null);

  int pageNumber = 1;
  int perPage = 5;

  RxBool isRequestFinishWithoutData = false.obs;

  // اخر بوست تم من عنده عمل طلب لجلب صفحة index متغير لتخزين
  // جديدة من البوستات وذلك حتى لا يتم تكرار الطلب عدة مرات
  int lastIndexToGetNextPage = 0;

  /// variable to determine if the follow or unfollow request sending or not
  RxBool sendingFollowRequest = false.obs;

  /// متغير لتحديد اذا كان المستخدم الحالي متابع لهذا الحساب ام لا
  RxBool meFollowHim = false.obs;

  /// متغير لتحديد اذا كان هذا الحساب متابع للمستخدم الحالي ام لا
  RxBool heFollowMe = false.obs;

  @override
  void onInit() async {
    super.onInit();

    await refreshData();
  }

  Future<void> refreshData() async {
    await Get.find<CurrentUserAccountController>().getCurrentUserData();
    await getSpecificUserData();
    await getSpecificUserPosts();

    meFollowHim.value =
        SharedPref.getCurrentUserData()?.followingUsers.contains(userId) ?? false;
    heFollowMe.value =
        SharedPref.getCurrentUserData()?.followersUsers.contains(userId) ?? false;
  }

  Future<void> getSpecificUserData() async {
    pageNumber = 1;
    // perPage = 15;

    final GetSpecificUserDataUseCase getSpecificUserUS = di.getIt();

    (await getSpecificUserUS.call(userId)).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      // isRequestFinishWithoutData = true;
      userData.value = null;
    }, (user) {
      // isRequestFinishWithoutData = true;
      userData.value = user;
      print(
          ">>>>>>>>>>>>>>>>>Done get specific $userId User Data>>>>>>>>>>>>>>");
    });
  }

  Future<void> getSpecificUserPosts() async {
    pageNumber = 1;
    // perPage = 15;

    final GetUserPostsUseCase getSpecificUserUS = di.getIt();
    var result = getSpecificUserUS.call(GetUserPostsRequest(
        userId: userId, pageNumber: pageNumber, perPage: perPage));

    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      isRequestFinishWithoutData.value = true;
      postList.value = [];
    }, (posts) {
      isRequestFinishWithoutData.value = posts.isEmpty;
      postList.value = posts;
      printInfo(info: ">>>>>>Done get specific $userId User Posts >>>");
    });
  }

  /// دالة تجلب الصفحة التالية من البوستات الخاصة بالمستخدم
  Future<void> loadNextPageOfSpecificUserPosts() async {
    if (await NetworkInfoImpl().isConnected) {
      printInfo(info: "Call loadNextPage of current user posts");
      pageNumber++;
      final GetUserPostsUseCase getSpecificUserUS = di.getIt();
      var result = getSpecificUserUS.call(GetUserPostsRequest(
          userId: userId, pageNumber: pageNumber, perPage: perPage));

      (await result).fold((failure) {
        AppUtil.hanldeAndShowFailure(failure);
      }, (posts) {
        postList.addAll(posts);
        printInfo(
            info: "Done get page $pageNumber from specific $userId user Posts");
      });
    } else {
      AppUtil.showMessage(
          AppLocalization.noInternet, Get.theme.colorScheme.error);
    }
  }

  void submitFollowButton() {
    if (meFollowHim.value && heFollowMe.value) {
      AppUtil.buildDialog("", AppLocalization.unfollowFriend, () {
        unfollowUser(userId);
        Get.back();
      }, submitButtonText: AppLocalization.unFollow);
    } else if (meFollowHim.value) {
      unfollowUser(userId);
    } else {
      // if (heFollowMe.value ||(!heFollowMe.value && !meFollowHim.value))
      followUser(userId);
    }
  }

  Future<void> followUser(int userId) async {
    if (await NetworkInfoImpl().isConnected) {
      printInfo(info: "Call follow user $userId");
      sendingFollowRequest.value = true;

      final FollowUserUseCase followUserUC = di.getIt();
      (await followUserUC.call(userId)).fold((failure) {
        AppUtil.hanldeAndShowFailure(failure);
      }, (success) {
        meFollowHim.value = true;
        AppUtil.showMessage(success.message, Colors.green);
      });
      sendingFollowRequest.value = false;
    } else {
      AppUtil.showMessage(
          AppLocalization.noInternet, Get.theme.colorScheme.error);
    }
  }

  Future<void> unfollowUser(int userId) async {
    if (await NetworkInfoImpl().isConnected) {
      printInfo(info: "Call unfollow user $userId");
      sendingFollowRequest.value = true;

      final UnfollowUserUseCase unfollowUserUC = di.getIt();
      (await unfollowUserUC.call(userId)).fold((failure) {
        AppUtil.hanldeAndShowFailure(failure);
      }, (success) {
        meFollowHim.value = false;
        AppUtil.showMessage(success.message, Colors.green);
      });
      sendingFollowRequest.value = false;
    } else {
      AppUtil.showMessage(
          AppLocalization.noInternet, Get.theme.colorScheme.error);
    }
  }

  Future<void> deletePost(int postId) async {
    EasyLoading.show(status: AppLocalization.loading);
    DeletePostUseCase deletePostUS = di.getIt();
    (await deletePostUS.call(postId)).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
    }, (success) {
      AppUtil.showMessage(success.message, Get.theme.colorScheme.error);
      postList.removeWhere((element) => element.id == postId);
      print(">>>>>>>>>>>>>>>>>Done get current User Posts>>>>>>>>>>>>>>>");
    });
    EasyLoading.dismiss();
  }

  PopupMenuButtonWidget getPostMenuButtonValuesWidget(int postId) {
    return PopupMenuButtonWidget(
      items: OperationsOnPostPopupMenuValues.values.asNameMap().keys.toList(),
      onSelected: (value) {
        return postPopupMenuButtonOnSelected(value, postId);
      },
    );
  }

  void postPopupMenuButtonOnSelected(String value, int postId) async {
    if (value == OperationsOnCurrentUserPostPopupMenuValues.delete.name) {
      deletePost(postId);
    } else if (value == OperationsOnCurrentUserPostPopupMenuValues.edit.name) {
      Get.to(() => AddUpdatePostScreen(
            isUpdatePost: true,
            post: postList.firstWhere((element) => element.id == postId),
          ));
      // Post p = postList.firstWhere((element) => element.id == postId);
      // ClipboardData clipboardData = ClipboardData(text: p.content);
      // await Clipboard.setData(clipboardData);
    }
  }
}
