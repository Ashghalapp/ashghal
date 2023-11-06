import 'package:ashghal_app_frontend/app_library/public_entities/app_category.dart';
import 'package:ashghal_app_frontend/core/cities_and_districts.dart';
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

  Rx<int?> selectedCategory = Rx(null);

  RxList<City> cities = citiess.obs;
  RxList<District> districts = <District>[].obs;

  District allDistrict = District(id: 0, nameAr: "الكل", nameEn: "All");

  Rx<int?> selectedCityId = Rx(null);
  Rx<int?> selectedDistrictId = Rx(null);

  @override
  void onInit() async {
    super.onInit();
    textController = TextEditingController();
    postsFilterModel.perPage = 3;
    usersFilterModel.perPage = 10;
    usersFilterModel.isRequestFinishWithoutData.value = true;

    cities.insert(
      0,
      City(
        id: 0,
        nameAr: "الكل",
        nameEn: "All",
        districts: [allDistrict],
      ),
    );

    loadLocationData();
    loadCategoriesData();

    await getRecentPosts();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  /// functions to get categories data from api if not found in laster
  Future<void> loadCategoriesData() async {
    if (categories.isEmpty) {
      await ApiUtil.getCategoriesFromApi();
      categories = SharedPref.getCategories()?.obs ?? <AppCategory>[].obs;
    }
    categories.insert(0, AppCategory(id: 0, name: AppLocalization.all.tr));
    selectedCategory.value = 0;
  }

  /// functions to initial address filtters with user address
  void loadLocationData() {
    final User? currentUser = SharedPref.getCurrentUserData();
    if (currentUser != null && currentUser.address != null) {
      City? city = City.getCityByNameEn(currentUser.address?.city ?? "");
      printError(info: "<<<<<<<<<<<<<<City data: ${city?.toJson()}");
      if (city != null) {
        selectedCityId.value = city.id;
        districts.addAll(city.districts);
        districts.insert(0, allDistrict);

        District? district =
            city.getDistrictByNameEn(currentUser.address?.district ?? "");
        printError(info: "<<<<<<<<<<<<<<District data: ${district?.toJson()}");
        if (district != null) {
          selectedDistrictId.value = district.id;
        }
      }
    }
  }

  Future<void> getRecentPosts() async {
    await postController.getRecentPosts();
    recentPostsList.value = postController.recentPostsModel.posts;
    postsFilterModel.dataList.value = recentPostsList;
  }

  void onCityChange(selectedValue) {
    if (selectedValue != null) {
      selectedCityId.value = int.parse(selectedValue.toString());
      districts.clear();
      if (selectedValue == 0) {
        districts.add(allDistrict); // = [allDistrict];
        selectedDistrictId.value = 0;
      } else {
        selectedDistrictId.value = null;
        districts.addAll(citiess
            .firstWhere((city) => city.id == selectedCityId.value)
            .districts);
        districts.insert(0, allDistrict);
        selectedDistrictId.value = 0;
      }
      districts.refresh();
    }
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
    // if (textController.text.isEmpty) {
    // if (recentPostsList.isEmpty) {
    // await getRecentPosts();
    // }
    // postsFilterModel.dataList.value = recentPostsList;
    // } else {
    await _sendRequestToSearchPosts();
    // }
    update();
    EasyLoading.dismiss();
  }

  Future<void> loadNextPageOfSearchedPosts() async {
    if (textController.text.isNotEmpty) {
      postsFilterModel.pageNumber++;
      await _sendRequestToSearchPosts(isNextPage: true);
    }
  }

  SearchRequest getSearchRequest(int pageNumber, int perPage) {
    City? city = selectedCityId.value != null
        ? City.getCityById(selectedCityId.value!)
        : null;
    District? district;
    if (city != null && selectedDistrictId.value != null) {
      district = city.getDistrictById(selectedDistrictId.value!);
    }

    return SearchRequest(
        pageNumber: pageNumber,
        perPage: perPage,
        dataForSearch: textController.text,
        city: city?.id != 0 ? city?.nameEn : null,
        district: district?.id != 0 ? district?.nameEn : null,
        category_id:
            selectedCategory.value != 0 ? selectedCategory.value : null);
  }

  Future<void> _sendRequestToSearchPosts({bool isNextPage = false}) async {
    final SearchForPostsUseCase searchPostsUC = di.getIt();
    postsFilterModel.isRequestFinishWithoutData.value = false;

    // City? city = selectedCityId.value != null
    //     ? City.getCityById(selectedCityId.value!)
    //     : null;
    // District? district;
    // if (city != null && selectedDistrictId.value != null) {
    //   district = city.getDistrictById(selectedDistrictId.value!);
    // }

    // final result = searchPostsUC.call(
    //   SearchRequest(
    //     pageNumber: postsFilterModel.pageNumber,
    //     perPage: postsFilterModel.perPage,
    //     dataForSearch: textController.text,
    //     city: city?.id != 0 ? city?.nameEn : null,
    //     district: district?.id != 0 ? district?.nameEn : null,
    //   ),
    // );
    final result = searchPostsUC.call(getSearchRequest(
      postsFilterModel.pageNumber,
      postsFilterModel.perPage,
    ));

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
    await _sendRequestToSearchUsers();

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
    // final result = searchUsersUC.call(
    //   SearchRequest(
    //       dataForSearch: textController.text,
    //       pageNumber: usersFilterModel.pageNumber,
    //       perPage: usersFilterModel.perPage),
    // );

    final result = searchUsersUC.call(getSearchRequest(
      usersFilterModel.pageNumber,
      usersFilterModel.perPage,
    ));

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
