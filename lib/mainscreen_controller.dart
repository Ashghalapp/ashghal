import 'package:ashghal_app_frontend/app_library/public_entities/address.dart';
import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/core_api/users_state_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_main_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/home_screen.dart';
import 'package:ashghal_app_frontend/features/account/Screen/account_screen.dart';
import 'package:ashghal_app_frontend/features/post/data/data_sources/post_remote_data_source.dart';
import 'package:ashghal_app_frontend/features/post/data/repositories/post_repository_impl.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/post_request/add_update_post_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/post_request/delete_some_post_multimedia_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/pagination_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/post_repository.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import 'config/app_icons.dart';
import 'features/post/presentation/screen/add_post_screen.dart';

class MainScreenController extends GetxController {
  int currentIndex = 4;
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
          icon: myIcons(svgAssetUrl: AppIcons.chatBorder),
          activeIcon: myIcons(
            svgAssetUrl: AppIcons.chat,
            color: AppColors.appColorPrimary,
          ),
          label: 'Chat'
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
    PostsScreen(),
    //  HomeScreen(),
    // Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     const Center(child: Text("Home screen")),
    //     ElevatedButton(onPressed: () async{
    //       try{
    //       PostCommentRepository ds= PostCommentRepositoryImpl();
    //       (await ds.addPost(AddPostRequest(title: "title", content: "Upload more one multimedia", categoryId: 1)));
    //       } catch (e){
    //         print(">>>>>>>>>>>error<<<<<<<<<<<:$e");
    //       }
    //     }, child: const Text("Try", style: TextStyle(color: Colors.white))),
    //     ElevatedButton(onPressed: () async{
    //       try{
    //       PostCommentRepository ds= PostCommentRepositoryImpl();
    //       (await ds.updatePost(UpdatePostRequest(id: 8, allowComment: true, address: Address.updateRequest(city: 'taiz', street: "ss", lat: 10.2))));
    //       } catch (e){
    //         print(">>>>>>>>>>>error<<<<<<<<<<<:$e");
    //       }
    //     }, child: const Text("Try", style: TextStyle(color: Colors.white))),
    //     ElevatedButton(onPressed: () async{
    //       try{
    //       PostCommentRepository ds= PostCommentRepositoryImpl();
    //       (await ds.deletePost(90));
    //       } catch (e){
    //         print(">>>>>>>>>>>error<<<<<<<<<<<:$e");
    //       }
    //     }, child: const Text("Try", style: TextStyle(color: Colors.white))),
    //     ElevatedButton(onPressed: () async{
    //       try{
    //       PostCommentRepository ds= PostCommentRepositoryImpl();
    //       (await ds.deleteSomePostMultimedia(DeleteSomePostMultimediaRequest(postId: 93, multimediaIds: [0])));
    //       } catch (e){
    //         print(">>>>>>>>>>>error<<<<<<<<<<<:$e");
    //       }
    //     }, child: const Text("Try", style: TextStyle(color: Colors.white))),
    //   ],
    // ),
    const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: Text("Search screen"))],
    ),
    AddPostScreen(),
    // const Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [Center(child: Text("Add Post"))],
    // ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              print(SharedPref.getUserToken());
              Get.to(() => ChatScreen());
            },
            child: Text("Open Chat"))
      ],
    ),
    AccountScreen(),
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

  changePage(int index) {
    currentIndex = index;
    update();
  }
}
