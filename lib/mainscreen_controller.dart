import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/util/dialog_util.dart';
import 'package:ashghal_app_frontend/core_api/users_state_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/account/current_user_account_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_screen.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/marked_posts_screen.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/post_screen.dart';
import 'package:ashghal_app_frontend/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import 'config/app_icons.dart';
import 'features/post/presentation/screen/add_update_post_screen.dart';

class MainScreenController extends GetxController {
  int currentIndex = 0;
  final search = TextEditingController();
  final UsersStateController stateController = Get.put(UsersStateController());

  AppServices appServices = Get.find();
  var location = ''.obs;
  var jobTitle = ''.obs;

  void searchFilter() {
    debugPrint(
        'Performing search with location: ${location.value} and job title: ${jobTitle.value}');
    Get.back();
  }

  Widget myIcons(
      {String? svgAssetUrl, double? width, double? height, Color? color}) {
    return SvgPicture.asset(
      svgAssetUrl!,
      // AppIcons.email,
      width: width ?? 30,
      height: height ?? 30,

      colorFilter:
          ColorFilter.mode(color ?? AppColors.iconColor, BlendMode.srcIn),
    );
  }

  List<BottomNavigationBarItem> getItems() {
    return [
      BottomNavigationBarItem(
          activeIcon: myIcons(
            svgAssetUrl: AppIcons.home,
            color: AppColors.appColorPrimary,
          ),
          //  Icon(
          //   Iconsax.home_25,
          //   // Icons.home,
          // ),
          icon: myIcons(svgAssetUrl: AppIcons.homeBorder),
          // Icon(
          //   Iconsax.home_24,
          //   // Icons.home_filled
          // ),
          label: 'Home'),
      BottomNavigationBarItem(
          icon: myIcons(svgAssetUrl: AppIcons.searchBorder),
          activeIcon: myIcons(
            svgAssetUrl: AppIcons.search,
            color: AppColors.appColorPrimary,
          ),
          label: 'Search'
          // activeIcon: Icon(
          //   Iconsax.search_normal,
          //   // Icons.search
          // ),
          // icon: Icon(
          //   Iconsax.search_normal_1,
          //   // Icons.search,
          // ),
          ),
      BottomNavigationBarItem(
          icon: myIcons(svgAssetUrl: AppIcons.plusBorder),
          activeIcon: myIcons(
            svgAssetUrl: AppIcons.plus,
            color: AppColors.appColorPrimary,
          ),
          label: 'Add'
          // activeIcon: Icon(
          //     Icons.add_circle_outlined,
          //   ),
          //   icon: Icon(
          //     Icons.add_circle_outline_outlined,
          //   ),
          ),
      BottomNavigationBarItem(
          icon: myIcons(svgAssetUrl: AppIcons.heartBorder),
          activeIcon: myIcons(
            svgAssetUrl: AppIcons.heart,
            color: AppColors.appColorPrimary,
          ),
          label: 'Favorite'
          // activeIcon: Icon(
          //     Iconsax.heart5,
          //     // Icons.heart_broken_outlined
          //   ),
          //   icon: Icon(
          //     Iconsax.heart,
          //     // Icons.heart_broken_rounded
          //   ),
          ),
      BottomNavigationBarItem(
          icon: myIcons(svgAssetUrl: AppIcons.userBorder),
          activeIcon: myIcons(
            svgAssetUrl: AppIcons.user,
            color: AppColors.appColorPrimary,
          ),
          label: 'Profile'
          // activeIcon: Icon(

          //     Iconsax.user,
          //     // Icons.person_2_outlined
          //   ),
          //   icon: Icon(
          //     Iconsax.user,
          //     // Icons.person_2,
          //   ),
          ),
    ];
  }
  //===========================================//

  List<Widget> listPage = [
    // index 0 => posts
    PostsScreen(),
    //  HomeScreen(),

    // const Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [Center(child: Text("Search screen"))],
    // ),

    // index 1 => Search for posts or users
    AppSearchScreen(),

    // index 2 => Add Post screen
    AddUpdatePostScreen(),
    // const Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [Center(child: Text("Add Post"))],
    // ),

    // index 3 => favorit screen
    MarkedPostsScreen(),
    // const Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [Center(child: Text("Favorite Posts"))],
    // ),
    // Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     ElevatedButton(
    //         onPressed: () {
    //           print(SharedPref.getUserToken());
    //           Get.to(() => ChatScreen());
    //         },
    //         child: Text("Open Chat"))
    //   ],
    // ),

    // AccountScreen(),
    if (SharedPref.getCurrentUserData() != null) CurrentUserAccountScreen(),
    // if (SharedPref.getCurrentUserData() == null)
    //   FutureBuilder(
    //     future: AppUtil.buildErrorDialog("hh"),
    //     builder: (context, snapshot) {
    //       return const Center(child: Text("data"));
    //     },
    //   )
    // AppUtil.buildErrorDialog("hh"),
    // const Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [Center(child: Text("Profile Screen"))],
    // ),
  ];

  List<IconData> bottomappbar = [
    Icons.home,
    Icons.notifications_active_outlined,
    Icons.person_pin_sharp,
    Icons.settings
  ];

  changePage(int index) async {
    // if ((index == 2 || index == 3 || index == 4) &&
    //     SharedPref.getCurrentUserData() == null) {
    //   await DialogUtil.showSignInDialog();
    //   return;
    // }

    if ((index == 2 || index == 3 || index == 4) &&
        !AppUtil.checkUserLoginAndNotifyUser()) {
      return;
    }

    currentIndex = index;
    update();
  }
}
