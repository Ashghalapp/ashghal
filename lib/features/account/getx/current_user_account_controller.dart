import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/app_functions.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/user_usecases/get_current_user_data_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/user_usecases/get_specific_user_data_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/pagination_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/post_request/get_user_posts_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/delete_post_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_current_user_posts_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_user_posts_uc.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/add_post_screen.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../core/services/dependency_injection.dart' as di;

class CurrentUserAccountController extends GetxController {
  final int? userId;
  RxList<Post> postList = <Post>[].obs;

  Rx<User?> userData = Rx(null);

  int pageNumber = 1;
  int perPage = 5;

  bool isRequestFinishWithoutData = false;

  // اخر بوست تم من عنده عمل طلب لجلب صفحة index متغير لتخزين
  // جديدة من البوستات وذلك حتى لا يتم تكرار الطلب عدة مرات
  int lastIndexToGetNewPage = 0;

  CurrentUserAccountController(this.userId);

  @override
  void onInit() async {
    super.onInit();

    if (userId != null) {
      await getSpecificUserData(userId!);
      getSpecificUserPosts(userId!);
    } else {
      await getCurrentUserData();
      getCurrentUserPosts();
    }
  }

  User get getCurrentUserDataOffline {
    return SharedPref.getCurrentUserData();
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
      isRequestFinishWithoutData = true;
      postList.value = [];
    }, (posts) {
      isRequestFinishWithoutData = posts.isEmpty;
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

  Future<void> getSpecificUserData(int userId) async {
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

  Future<void> getSpecificUserPosts(int userId) async {
    pageNumber = 1;
    // perPage = 15;

    final GetUserPostsUseCase getSpecificUserUS = di.getIt();
    var result = getSpecificUserUS.call(GetUserPostsRequest(
        userId: userId, pageNumber: pageNumber, perPage: perPage));

    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      isRequestFinishWithoutData = true;
      postList.value = [];
    }, (posts) {
      isRequestFinishWithoutData = posts.isEmpty;
      postList.value = posts;
      print(
          ">>>>>>>>>>>>>>>>>Done get specific $userId User Posts>>>>>>>>>>>>>>>");
    });
  }

  /// دالة تجلب الصفحة التالية من البوستات الخاصة بالمستخدم
  Future<void> loadNextPageOfSpecificUserPosts(int userId) async {
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

  Future refreshData() async {
    if (userId != null) {
      await getSpecificUserData(userId!);
      await getSpecificUserPosts(userId!);
    } else {
      await getCurrentUserData();
      await getCurrentUserPosts();
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
      values: userId != null
          ? OperationsOnPostPopupMenuValues.values.asNameMap().keys.toList()
          : OperationsOnCurrentUserPostPopupMenuValues.values
              .asNameMap()
              .keys
              .toList(),
      onSelected: (value) {
        return postPopupMenuButtonOnSelected(value, postId);
      },
    );
  }

  void postPopupMenuButtonOnSelected(String value, int postId) async {
    if (value == OperationsOnCurrentUserPostPopupMenuValues.save.name) {
    } else if (value ==
        OperationsOnCurrentUserPostPopupMenuValues.delete.name) {
      deletePost(postId);
    } else if (value == OperationsOnCurrentUserPostPopupMenuValues.edit.name) {
      Get.to(() => AddPostScreen(
            isUpdatePost: true,
            post: postList.firstWhere((element) => element.id == postId),
          ));
      // Post p = postList.firstWhere((element) => element.id == postId);
      // ClipboardData clipboardData = ClipboardData(text: p.content);
      // await Clipboard.setData(clipboardData);
    }
  }
}
