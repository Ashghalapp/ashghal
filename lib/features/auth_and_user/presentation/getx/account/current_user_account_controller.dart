import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/app_functions.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/util/dialog_util.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/settings/show_edit_profile_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/get_current_user_data_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/get_specific_user_data_uc.dart';
import 'package:ashghal_app_frontend/app_library/public_request/pagination_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/post_request/add_update_post_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/post_request/get_user_posts_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/delete_post_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_current_user_posts_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_marked_post_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_user_posts_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/update_post_us.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/add_update_post_screen.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../../../core/services/dependency_injection.dart' as di;

class CurrentUserAccountController extends GetxController {
  // final int? userId;
  RxList<Post> postList = <Post>[].obs;
  RxList<Post> markedPostList = <Post>[].obs;

  Rx<User?> userData = Rx(null);

  int pageNumber = 1;
  int perPage = 4;

  RxBool isRequestFinishWithoutData = false.obs;
  RxBool isMarketRequestFinishWithoutData = false.obs;

  // اخر بوست تم من عنده عمل طلب لجلب صفحة index متغير لتخزين
  // جديدة من البوستات وذلك حتى لا يتم تكرار الطلب عدة مرات
  int lastIndexToGetNextPage = 0;

  @override
  void onInit() async {
    super.onInit();
    refreshData();
  }

  User? get getCurrentUserDataOffline {
    return SharedPref.getCurrentUserData();
  }

  Future<void> refreshData() async {
    // printError(info: "Reeeeeefresh");
    await getCurrentUserData();
    await getCurrentUserPosts();
  }

  Future<void> getCurrentUserData() async {
    GetCurrentUserDataUseCase getCurrentUserDataUS = di.getIt();
    (await getCurrentUserDataUS.call()).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      // isRequestFinishWithoutData = true;
      userData.value = null;
    }, (user) {
      // isRequestFinishWithoutData = true;
      userData.value = user;
      print(">>>>>>>>>>>>>>>>>Done get current User Data>>>>>>>>>>>>>>");
    });
  }

  Future<void> getCurrentUserPosts() async {
    pageNumber = 1;
    // perPage = 15;

    final GetCurrentUserPostsUseCase getCurrentUserUS = di.getIt();
    var result = getCurrentUserUS
        .call(PaginationRequest(pageNumber: pageNumber, perPage: perPage));

    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      isRequestFinishWithoutData.value = true;
      postList.value = [];
    }, (posts) {
      isRequestFinishWithoutData.value = posts.isEmpty;
      postList.value = posts;
      print(">>>>>>>>>>>>>>>>>Done get current User Posts>>>>>>>>>>>>>>>");
    });
  }

  /// دالة تجلب الصفحة التالية من البوستات الخاصة بالمستخدم
  Future<void> loadNextPageOfCurrentUserPosts() async {
    if (await NetworkInfoImpl().isConnected) {
      printInfo(info: "Call loadNextPage of current user posts");
      pageNumber++;
      final GetCurrentUserPostsUseCase getCurrentUserUS = di.getIt();
      final result = getCurrentUserUS
          .call(PaginationRequest(pageNumber: pageNumber, perPage: perPage));

      (await result).fold((failure) {
        AppUtil.hanldeAndShowFailure(failure);
      }, (posts) {
        postList.addAll(posts);
        printInfo(info: "Done get page $pageNumber from alive Posts");
      });
    } else {
      AppUtil.showMessage(
          AppLocalization.noInternet, Get.theme.colorScheme.error);
    }
  }

  // Future<void> getSpecificUserPosts(int userId) async {
  //   pageNumber = 1;
  //   // perPage = 15;

  //   final GetUserPostsUseCase getSpecificUserUS = di.getIt();
  //   var result = getSpecificUserUS.call(GetUserPostsRequest(
  //       userId: userId, pageNumber: pageNumber, perPage: perPage));

  //   (await result).fold((failure) {
  //     AppUtil.hanldeAndShowFailure(failure);
  //     isRequestFinishWithoutData.value = true;
  //     postList.value = [];
  //   }, (posts) {
  //     isRequestFinishWithoutData.value = posts.isEmpty;
  //     postList.value = posts;
  //     print(
  //         ">>>>>>>>>>>>>>>>>Done get specific $userId User Posts>>>>>>>>>>>>>>>");
  //   });
  // }

  // /// دالة تجلب الصفحة التالية من البوستات الخاصة بالمستخدم
  // Future<void> loadNextPageOfSpecificUserPosts(int userId) async {
  //   if (await NetworkInfoImpl().isConnected) {
  //     printInfo(info: "Call loadNextPage of current user posts");
  //     pageNumber++;
  //     final GetUserPostsUseCase getSpecificUserUS = di.getIt();
  //     var result = getSpecificUserUS.call(GetUserPostsRequest(
  //         userId: userId, pageNumber: pageNumber, perPage: perPage));

  //     (await result).fold((failure) {
  //       AppUtil.hanldeAndShowFailure(failure);
  //     }, (posts) {
  //       postList.addAll(posts);
  //       printInfo(
  //           info: "Done get page $pageNumber from specific $userId user Posts");
  //     });
  //   } else {
  //     AppUtil.showMessage(
  //         AppLocalization.noInternet, Get.theme.colorScheme.error);
  //   }
  // }

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

  Future<void> getMarkedPosts() async {
    final GetMarkedPostUseCase getMarkedPostsUC = di.getIt();
    var result = getMarkedPostsUC.call();

    isMarketRequestFinishWithoutData.value = false;
    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      isMarketRequestFinishWithoutData.value = true;
      markedPostList.value = [];
    }, (posts) {
      isMarketRequestFinishWithoutData.value = posts.isEmpty;
      markedPostList.value = posts;
      print(">>>>>>>>>>>>>>>>>Done get marked posts>>>>>>>>>>>>>>>");
    });
  }

  Future<void> markPostAsComplete(int postId) async {
    EasyLoading.show(status: AppLocalization.loading);

    await sendUpdatePostRequest(UpdatePostRequest(
      postId: postId,
      isComplete: true,
    ));

    EasyLoading.dismiss();
  }

  Future<void> allowCommentForPost(int postId) async {
    EasyLoading.show(status: AppLocalization.loading);

    await sendUpdatePostRequest(UpdatePostRequest(
      postId: postId,
      allowComment: true,
    ));

    EasyLoading.dismiss();
  }

  Future<void> disallowCommentForPost(int postId) async {
    EasyLoading.show(status: AppLocalization.loading);

    await sendUpdatePostRequest(UpdatePostRequest(
      postId: postId,
      allowComment: false,
    ));

    EasyLoading.dismiss();
  }

  Future<void> sendUpdatePostRequest(UpdatePostRequest request) async {
    UpdatePostUseCase updatePostUS = di.getIt();

    (await updatePostUS.call(request)).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
    }, (post) {
      AppUtil.showMessage(AppLocalization.successEditPost, Colors.green);
      int postIndex = postList.indexWhere((element) => element.id == post.id);
      if (postIndex != -1) {
        postList[postIndex] = post;
      }
    });
  }

  /// function to get the operations that can do it on a post as list of string
  PopupMenuButtonWidget getPostMenuButtonValuesWidget(Post post) {
    // final post = postList.firstWhere((element) => element.id == postId);
    final values = ['Edit'];
    if (!post.isComplete) {
      values.add('Mark this post as complete');
    }
    if (post.allowComment) {
      values.add('Disallow comments to this post');
    }
    if (!post.allowComment) {
      values.add('Allow comments to this post');
    }
    values.add('Delete');
    return PopupMenuButtonWidget(
      items: values,
      //  OperationsOnCurrentUserPostPopupMenuValues.values.asNameMap().keys.toList(),
      onSelected: (value) {
        return postPopupMenuButtonOnSelected(value, post);
      },
    );
  }

  void postPopupMenuButtonOnSelected(String value, Post post) async {
    if (value == "Edit") {
      // final indexPost = postList.indexWhere((element) => element.id == post);
      if (post.isComplete) {
        AppUtil.showMessage(AppLocalization.youCanOnlyEditIncompletePost, Colors.grey);
      } else {
        Get.to(
          () => AddUpdatePostScreen(
            isUpdatePost: true,
            post: post,
          ),
        )?.then((value) {
          if (value != null) {
            return postList = value;
          }
        });
      }
    } else if (value == "Mark this post as complete") {
      markPostAsComplete(post.id);
    } else if (value == "Allow comments to this post") {
      allowCommentForPost(post.id);
    } else if (value == "Disallow comments to this post") {
      disallowCommentForPost(post.id);
    } else if (value == "Delete") {
      DialogUtil.showDialog(
        title: AppLocalization.warning,
        message: AppLocalization.areYouSureToDelete,
        onSubmit: () {
          Get.back();
          deletePost(post.id);
        },
        submitText: AppLocalization.ok,
      );
    }
    // else if (value = ""){}
    // if (value == OperationsOnCurrentUserPostPopupMenuValues.delete.name) {
    //   deletePost(postId);
    // } else if (value == OperationsOnCurrentUserPostPopupMenuValues.edit.name) {
    // Get.to(() => AddPostScreen(
    //       isUpdatePost: true,
    //       post: postList.firstWhere((element) => element.id == postId),
    //     ));
    // }
    // Post p = postList.firstWhere((element) => element.id == postId);
    // ClipboardData clipboardData = ClipboardData(text: p.content);
    // await Clipboard.setData(clipboardData);
  }
}
