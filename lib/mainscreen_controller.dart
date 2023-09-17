import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

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

  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
        activeIcon: Icon(
          Iconsax.home_25,
        ),
        icon: Icon(
          Iconsax.home_24,
        ),
        label: ''),
    const BottomNavigationBarItem(
        activeIcon: Icon(
          Iconsax.search_normal,
        ),
        icon: Icon(
          Iconsax.search_normal_1,
        ),
        label: ''),
    const BottomNavigationBarItem(
      activeIcon: Icon(
          Icons.add_circle_outlined,
        ),
        icon: Icon(
          Icons.add_circle_outline_outlined,
        ),
        label: ''),
    const BottomNavigationBarItem(
      activeIcon: Icon(
          Iconsax.heart5,
        ),
        icon: Icon(
          Iconsax.heart,
        ),
        label: ''),
    const BottomNavigationBarItem(
      activeIcon: Icon(
       
          Iconsax.user,
        ),
        icon: Icon(
          Iconsax.user,
        ),
        label: ''),
  ];

  //===========================================//

  List<Widget> listPage = [
    //  HomeScreen(),
    const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: Text("Home screen"))],
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
