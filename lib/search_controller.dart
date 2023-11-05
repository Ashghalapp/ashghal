import 'package:ashghal_app_frontend/app_library/public_entities/app_category.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/app_library/public_request/search_request.dart';
import 'package:ashghal_app_frontend/core_api/api_util.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/search_for_users_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/search_for_posts_us.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/post_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../core/services/dependency_injection.dart' as di;

import 'app_library/app_data_types.dart';
import 'features/auth_and_user/domain/entities/user.dart';
import 'features/post/presentation/widget/custom_report_buttomsheet.dart';

enum SearchFilters {
  posts,
  users,
}

extension SearchFiltersExtension on SearchFilters {
  String get value {
    switch (this) {
      case SearchFilters.posts:
        return AppLocalization.posts;
      case SearchFilters.users:
        return AppLocalization.users;
    }
  }
}

class SearchAndPaginationRequestModel<T> {
  final RxList<T> dataList = <T>[].obs;
  RxBool isRequestFinishWithoutData = false.obs;

  int pageNumber = 1;
  int perPage = 10;
  int lastIndexToGetNewPage = 0;
}

class AppSearchController extends GetxController {
  late final TextEditingController textController;

  final postsFilterModel = SearchAndPaginationRequestModel<Post>();
  final usersFilterModel = SearchAndPaginationRequestModel<User>();

  final RxList<Post> recentPostsList = <Post>[].obs;

  Rx<SearchFilters> appliedFilter = SearchFilters.posts.obs;

  final PostController postController = Get.find();

  RxList<AppCategory> categories =
      SharedPref.getCategories()?.obs ?? <AppCategory>[].obs;

  int? selectedCategory;

  @override
  void onInit() async {
    super.onInit();
    textController = TextEditingController();
    postsFilterModel.perPage= 4;
    usersFilterModel.perPage= 10;
    usersFilterModel.isRequestFinishWithoutData.value = true;

    if (categories.isEmpty){
      await ApiUtil.getCategoriesFromApi();
      categories = SharedPref.getCategories()?.obs ?? <AppCategory>[].obs;
    }
    await getRecentPosts();
  }

  Future<void> getRecentPosts() async {
    await postController.getRecentPosts();
    recentPostsList.value = postController.recentPostsModel.posts;
    postsFilterModel.dataList.value = recentPostsList;
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void applyFilter(SearchFilters filter) {
    appliedFilter.value = filter;
    search();
  }

  Future<void> search() async {
    switch (appliedFilter.value) {
      case SearchFilters.posts:
        await searchForPosts();
      case SearchFilters.users:
        await searchForUSers();
    }
  }

  /// functions to send reqest into api to get searched posts
  Future<void> searchForPosts() async {
    postsFilterModel.pageNumber = 1;
    Get.focusScope?.unfocus();
    EasyLoading.show(status: AppLocalization.loading);
    if (textController.text.isEmpty) {
      if (recentPostsList.isEmpty){
        await getRecentPosts();
      }
      postsFilterModel.dataList.value = recentPostsList;
    } else {
      await _sendRequestToSearchPosts();
    }
    update();
    EasyLoading.dismiss();
  }

  Future<void> loadNextPageOfSearchedPosts() async {
    if (textController.text.isNotEmpty) {
      postsFilterModel.pageNumber++;
      await _sendRequestToSearchPosts(isNextPage: true);
    }
  }

  Future<void> _sendRequestToSearchPosts({bool isNextPage = false}) async {
    final SearchForPostsUseCase searchPostsUC = di.getIt();
    postsFilterModel.isRequestFinishWithoutData.value = false;
    final result = searchPostsUC.call(
      SearchRequest(
          dataForSearch: textController.text,
          pageNumber: postsFilterModel.pageNumber,
          perPage: postsFilterModel.perPage),
    );
    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      postsFilterModel.isRequestFinishWithoutData.value = true;
      if (!isNextPage) postsFilterModel.dataList.value = [];
    }, (posts) {
      postsFilterModel.isRequestFinishWithoutData.value = posts.isEmpty;
      if (isNextPage) {
        postsFilterModel.dataList.addAll(posts);
      } else {
        postsFilterModel.dataList.value = posts;
      }
      printInfo(info: ">>>>>>Done get searched Posts>>>>>");
    });
  }

  /// functions to send reqest into api to get searched posts
  Future<void> searchForUSers() async {
    usersFilterModel.pageNumber = 1;
    Get.focusScope?.unfocus();
    EasyLoading.show(status: AppLocalization.loading);
    if (textController.text.isNotEmpty) {
      await _sendRequestToSearchUsers();
    }
    update();
    EasyLoading.dismiss();
  }

  Future<void> loadNextPageOfSearchedUsers() async {
    if (textController.text.isNotEmpty) {
      usersFilterModel.pageNumber++;
      await _sendRequestToSearchUsers(isNextPage: true);
    }
  }

  Future<void> _sendRequestToSearchUsers({bool isNextPage = false}) async {
    final SearchForUsersUseCase searchUsersUC = di.getIt();
    usersFilterModel.isRequestFinishWithoutData.value = false;
    final result = searchUsersUC.call(
      SearchRequest(
          dataForSearch: textController.text,
          pageNumber: usersFilterModel.pageNumber,
          perPage: usersFilterModel.perPage),
    );
    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      usersFilterModel.isRequestFinishWithoutData.value = true;
      if (!isNextPage) usersFilterModel.dataList.value = [];
    }, (users) {
      usersFilterModel.isRequestFinishWithoutData.value = users.isEmpty;
      if (isNextPage) {
        usersFilterModel.dataList.addAll(users);
      } else {
        usersFilterModel.dataList.value = users;
      }
      printInfo(info: ">>>>>>Done get searched Userss>>>>>");
    });
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
    if (value == OperationsOnPostPopupMenuValues.save.name) {
    } else if (value == OperationsOnPostPopupMenuValues.report.name) {
      Get.bottomSheet(CustomBottomSheet());
    } else if (value == OperationsOnPostPopupMenuValues.copy.name) {}
  }
}
