import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/app_dropdownbutton.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:ashghal_app_frontend/core/widget/posts_builder_widget.dart';
import 'package:ashghal_app_frontend/core/widget/scale_down_transition.dart';
import 'package:ashghal_app_frontend/core/widget/horizontal_slide_transition_widget.dart';
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
          preferredSize: const Size.fromHeight(175),
          child: ListView(
            padding: const EdgeInsets.only(top: 15, right: 8, left: 8),
            children: [
              GetX<AppSearchController>(
                builder: (_) {
                  return Row(
                    children: [
                      // category drop down
                      // if (searchController.appliedFilter.value !=
                      //     SearchFilters.users)
                      Flexible(
                        flex: searchController.appliedFilter.value ==
                                SearchFilters.users
                            ? 0
                            : 1,
                        child: AnimatedCrossFade(
                          crossFadeState:
                              searchController.appliedFilter.value ==
                                      SearchFilters.users
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300),
                          sizeCurve: Curves.easeIn,
                          firstChild: const SizedBox.shrink(),
                          secondChild: buildDropMenuWithLabelWidget(
                            label: AppLocalization.category,
                            initialValue:
                                searchController.selectedCategory.value,
                            items: searchController.categories
                                .map((element) => element.toJson())
                                .toList(),
                            onChange: (newValue) {
                              searchController.selectedCategory.value =
                                  int.parse(newValue?.toString() ?? "1");
                            },
                            margin: EdgeInsets.only(
                              top: 1,
                              left: Get.locale?.languageCode == 'ar' ? 8 : 0,
                              right: Get.locale?.languageCode == 'en' ? 8 : 0,
                            ),
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(" ${AppLocalization.category.tr}",
                          //         style: Get.textTheme.labelSmall),
                          //     AppDropDownButton(
                          //       height: 35,
                          //       // labelText: AppLocalization.category,
                          //       initialValue:
                          //           searchController.selectedCategory.value,
                          //       items: searchController.categories
                          //           .map((element) => element.toJson())
                          //           .toList(),
                          //       margin: EdgeInsets.only(
                          //         top: 4,
                          //         left:
                          //             Get.locale?.languageCode == 'ar' ? 8 : 0,
                          //         right:
                          //             Get.locale?.languageCode == 'en' ? 8 : 0,
                          //       ),
                          //       onChange: (newValue) {
                          //         searchController.selectedCategory.value =
                          //             int.parse(newValue?.toString() ?? "1");
                          //       },
                          //     ),
                          //   ],
                          // ),
                        ),
                      ),

                      // city dropdown
                      Flexible(
                        child: buildDropMenuWithLabelWidget(
                          label: AppLocalization.city,
                          initialValue: searchController.selectedCityId.value,
                          items: searchController.cities
                              .map((city) => city.toJson())
                              .toList(),
                          onChange: searchController.onCityChange,
                          margin: EdgeInsets.only(
                            top: 1,
                            left: Get.locale?.languageCode == 'ar' ? 8 : 0,
                            right: Get.locale?.languageCode == 'en' ? 8 : 0,
                          ),
                        ),
                        // AppDropDownButton(
                        //   labelText: AppLocalization.city,
                        //   initialValue: searchController.selectedCityId.value,
                        //   items: searchController.cities
                        //       .map((city) => city.toJson())
                        //       .toList(),
                        //   margin: EdgeInsets.only(
                        //     top: 4,
                        //     left: Get.locale?.languageCode == 'ar' ? 8 : 0,
                        //     right: Get.locale?.languageCode == 'en' ? 8 : 0,
                        //   ),
                        //   onChange: searchController.onCityChange,
                        // ),
                      ),

                      // district dropdown
                      Flexible(
                        child: buildDropMenuWithLabelWidget(
                          label: AppLocalization.district,
                          initialValue:
                              searchController.selectedDistrictId.value,
                          items: searchController.districts
                              .map((district) => district.toJson())
                              .toList(),
                          onChange: (newValue) {
                            searchController.selectedDistrictId.value =
                                int.parse(newValue?.toString() ?? "1");
                          },
                          margin: const EdgeInsets.only(top: 1),
                        ),
                        // AppDropDownButton(
                        //   labelText: AppLocalization.district,
                        //   margin: const EdgeInsets.only(top: 4),
                        //   initialValue:
                        //       searchController.selectedDistrictId.value,
                        //   items: searchController.districts
                        //       .map((district) => district.toJson())
                        //       .toList(),
                        //   onChange: (newValue) {
                        //     searchController.selectedDistrictId.value =
                        //         int.parse(newValue?.toString() ?? "1");
                        //   },
                        // ),
                      ),
                    ],
                  );
                },
              ),

              // search textFormField and search icon button
              Row(
                children: [
                  // search textFormField
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: AppTextFormField(
                        obscureText: false,
                        controller: searchController.textController,
                        hintText: AppLocalization.writeToSearch,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),

                  // search icon button
                  Padding(
                    padding: EdgeInsets.only(
                      right: Get.locale?.languageCode == 'en' ? 8.0 : 0,
                      left: Get.locale?.languageCode == 'ar' ? 8.0 : 0,
                    ),
                    child: ScaleDownTransitionWidget(
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
                    ),
                  )
                ],
              ),

              // filtered buttons
              HorizontalSlideTransitionWidget(
                millisecondToLate: 100,
                child: Obx(() => buildFilterButtons()),
              ),
            ],
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

  Widget buildDropMenuWithLabelWidget({
    required String label,
    required List<Map<String, Object>> items,
    required void Function(Object?) onChange,
    int? initialValue,
    double? dropdownMenuHeight = 38,
    EdgeInsetsGeometry? margin,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          " ${label.tr}",
          style: Get.textTheme.labelSmall,
        ),
        AppDropDownButton(
          height: dropdownMenuHeight,
          initialValue: initialValue,
          items: items,
          margin: margin,
          onChange: onChange,
        ),
      ],
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          children: [
            for (SearchFilters filter in SearchFilters.values)
              Expanded(child: _buildFilterButton(filter)),
          ],
        ),
      ),
    );
  }

  /// Filter outlined button
  Widget _buildFilterButton(SearchFilters filter) {
    final langCode = Get.locale?.languageCode;
    return Container(
      padding: filter == SearchFilters.values.last
          ? null
          : EdgeInsets.only(
              right: langCode == 'en' ? 8 : 0,
              left: langCode == 'ar' ? 8 : 0,
            ),
      child: CustomOutlineButton(
        isFilled: searchController.appliedFilter.value == filter,
        text: filter.value,
        onPress: () => searchController.applyFilter(filter),
      ),
    );
  }
}
