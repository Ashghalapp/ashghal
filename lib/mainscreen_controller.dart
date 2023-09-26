import 'package:ashghal_app_frontend/app_library/public_entities/address.dart';
import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/features/post/data/data_sources/post_comment_remote_data_source.dart';
import 'package:ashghal_app_frontend/features/post/data/repositories/post_comment_repository_impl.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/add_update_post_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/delete_some_post_multimedia_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/get_posts_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/post_comment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import 'config/app_icons.dart';
import 'features/post/domain/Requsets/get_category_posts_request.dart';
import 'features/post/domain/Requsets/get_user_posts_request.dart';

class MainScreenController extends GetxController {
  int currentIndex = 0;
  final search = TextEditingController();

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
          label: 'Activity'
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
    //  HomeScreen(),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(child: Text("Home screen")),
        ElevatedButton(onPressed: () async{
          try{
          PostCommentRepository ds= PostCommentRepositoryImpl();
          (await ds.addPost(AddPostRequest(title: "title", content: "Upload more one multimedia", categoryId: 1)));
          } catch (e){
            print(">>>>>>>>>>>error<<<<<<<<<<<:$e");
          }
        }, child: const Text("Try", style: TextStyle(color: Colors.white))),
        ElevatedButton(onPressed: () async{
          try{
          PostCommentRepository ds= PostCommentRepositoryImpl();
          (await ds.updatePost(UpdatePostRequest(id: 8, allowComment: true, address: Address.updateRequest(city: 'taiz', street: "ss", lat: 10.2))));
          } catch (e){
            print(">>>>>>>>>>>error<<<<<<<<<<<:$e");
          }
        }, child: const Text("Try", style: TextStyle(color: Colors.white))),
        ElevatedButton(onPressed: () async{
          try{
          PostCommentRepository ds= PostCommentRepositoryImpl();
          (await ds.deletePost(90));
          } catch (e){
            print(">>>>>>>>>>>error<<<<<<<<<<<:$e");
          }
        }, child: const Text("Try", style: TextStyle(color: Colors.white))),
        ElevatedButton(onPressed: () async{
          try{
          PostCommentRepository ds= PostCommentRepositoryImpl();
          (await ds.deleteSomePostMultimedia(DeleteSomePostMultimediaRequest(postId: 93, multimediaIds: [0])));
          } catch (e){
            print(">>>>>>>>>>>error<<<<<<<<<<<:$e");
          }
        }, child: const Text("Try", style: TextStyle(color: Colors.white))),
      ],
    ),
    const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: Text("Search screen"))],
    ),
    const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: Text("Add Post"))],
    ),
    const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: Text("Activity Screen"))],
    ),
    const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: Text("Profile Screen"))],
    ),
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
