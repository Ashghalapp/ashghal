import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:ashghal_app_frontend/core/cities_and_districts.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/app_dropdownbuttonformfield.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:ashghal_app_frontend/core/widget/posts_builder_widget.dart';
import 'package:ashghal_app_frontend/core/widget/users_builder_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/filled_outline_button.dart';
import 'package:ashghal_app_frontend/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppSearchScreen extends StatelessWidget {
  AppSearchScreen({super.key});

  late final AppSearchController searchController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(165),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
            child: Column(
              children: [
                GetX<AppSearchController>(builder: (_) {
                  return Row(
                    children: [
                      // category drop down
                      if (searchController.appliedFilter.value !=
                          SearchFilters.users)
                        Flexible(
                          child: AppDropDownButton(
                            labelText: AppLocalization.category,
                            initialValue: searchController.selectedCategory.value,
                            items: searchController.categories
                                .map((element) => element.toJson())
                                .toList(),
                            margin: EdgeInsets.only(
                              left: Get.locale?.languageCode == 'ar' ? 8 : 0,
                              right: Get.locale?.languageCode == 'en' ? 8 : 0,
                            ),
                            onChange: (newValue) {
                              searchController.selectedCategory.value =
                                  int.parse(newValue?.toString() ?? "1");
                            },
                          ),
                        ),

                      // city dropdown
                      Flexible(
                        child: AppDropDownButton(
                          labelText: AppLocalization.city,
                          initialValue: searchController.selectedCityId.value,
                          items: searchController.cities
                              .map((city) => city.toJson())
                              .toList(),
                          margin: EdgeInsets.only(
                            left: Get.locale?.languageCode == 'ar' ? 8 : 0,
                            right: Get.locale?.languageCode == 'en' ? 8 : 0,
                          ),
                          onChange: searchController.onCityChange,
                        ),
                      ),

                      // district dropdown
                      Flexible(
                        child: AppDropDownButton(
                          labelText: AppLocalization.district,
                          initialValue:
                              searchController.selectedDistrictId.value,
                          items: searchController.districts
                              .map((district) => district.toJson())
                              .toList(),
                          onChange: (newValue) {
                            searchController.selectedCategory.value =
                                int.parse(newValue?.toString() ?? "1");
                          },
                        ),
                      ),
                    ],
                  );
                }),

                // search textFormField and search icon button
                Row(
                  children: [
                    // search textFormField
                    Expanded(
                      child: AppTextFormField(
                        obscureText: false,
                        controller: searchController.textController,
                        hintText: AppLocalization.writeToSearch,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),

                    // search icon button
                    Padding(
                      padding: EdgeInsets.only(
                        right: Get.locale?.languageCode == 'en' ? 8.0 : 0,
                        left: Get.locale?.languageCode == 'ar' ? 8.0 : 0,
                      ),
                      child: IconButton(
                        onPressed: () => searchController.search(),
                        icon: SvgPicture.asset(
                          AppIcons.searchBorder,
                          width: 30,
                          height: 30,
                          colorFilter: const ColorFilter.mode(
                              AppColors.iconColor, BlendMode.srcIn),
                        ),
                      ),
                    )
                  ],
                ),

                // filtered buttons
                Obx(() => buildFilterButtons()),
              ],
            ),
          ),
        ),
        body: Obx(
            () => searchController.appliedFilter.value == SearchFilters.posts
                ? PostsBuilderWidget(
                    posts: searchController.postsFilterModel.dataList,
                    onIndexChange: (index) {
                      // if (index == searchController.postsList.length - 3 &&
                      //     index != searchController.postLastIndexToGetNextPage) {
                      print(
                          "<<<<<<<<length: ${searchController.postsFilterModel.dataList.length}>>>>>>>>");
                      if (index ==
                              searchController
                                      .postsFilterModel.dataList.length -
                                  3 &&
                          index !=
                              searchController
                                  .postsFilterModel.lastIndexToGetNewPage) {
                        // print(
                        //     "========last index ${searchController.postLastIndexToGetNextPage}");
                        searchController
                            .postsFilterModel.lastIndexToGetNewPage = index;
                        print(
                            "========last index ${searchController.postsFilterModel.lastIndexToGetNewPage}");
                        searchController.loadNextPageOfSearchedPosts();
                        // searchController.postLastIndexToGetNextPage = index;
                      }
                    },
                    getPopupMenuFunction: AppUtil.getPostMenuButtonValuesWidget,
                    isRequestFinishWithoutData:
                        // searchController.isPostsRequestFinishWithoutData,
                        searchController
                            .postsFilterModel.isRequestFinishWithoutData,
                    faildDownloadWidget: Center(
                      child: Text(AppLocalization.notFound),
                    ),
                  )
                : UsersBuilderWidget(
                    users: searchController.usersFilterModel.dataList,
                    onIndexChange: (index) {
                      print(
                          "<<<<<<<<length: ${searchController.usersFilterModel.dataList.length}>>>>>>>>");
                      if (index ==
                              searchController
                                      .usersFilterModel.dataList.length -
                                  3 &&
                          index !=
                              searchController
                                  .usersFilterModel.lastIndexToGetNewPage) {
                        searchController
                            .usersFilterModel.lastIndexToGetNewPage = index;
                        print(
                            "========last index ${searchController.usersFilterModel.lastIndexToGetNewPage}");
                        searchController.loadNextPageOfSearchedUsers();
                      }
                    },
                    isRequestFinishWithoutData: searchController
                        .usersFilterModel.isRequestFinishWithoutData,
                    faildDownloadWidget: Center(
                      child: Text(AppLocalization.notFound),
                    ),
                  )

            // usersBuilder(),
            ),
      ),
    );
  }

  // Widget usersBuilder() {
  //   final users = searchController.usersList;
  //   return users.isNotEmpty
  //       ? ListView.builder(
  //           itemBuilder: (context, index) {
  //             if (index < users.length) {
  //               return UserCardWidget(user: users[index]);
  //             }
  //             return null;
  //           },
  //           itemCount: searchController.usersList.length,
  //         )
  //       : Center(
  //           child: Text(AppLocalization.notFound),
  //         );
  // }

  /// A list of filters
  SizedBox buildFilterButtons() {
    return SizedBox(
      height: 41,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 5),
        scrollDirection: Axis.horizontal,
        children: [
          for (SearchFilters filter in SearchFilters.values)
            _buildFilterButton(filter),
        ],
      ),
    );
  }

  /// Filter outlined button
  Padding _buildFilterButton(SearchFilters filter) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: CustomOutlineButton(
        isFilled: searchController.appliedFilter.value == filter,
        text: filter.value,
        onPress: () => searchController.applyFilter(filter),
      ),
    );
  }
}
