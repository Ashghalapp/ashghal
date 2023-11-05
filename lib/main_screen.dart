import 'package:ashghal_app_frontend/app_live_cycle_controller.dart';
import 'package:ashghal_app_frontend/app_live_cycle_observer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mainscreen_controller.dart';

class MainScreen extends GetView<MainScreenController> {
  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    // print();
    // print("--------------------------------------------------------------");
    // print("Theme is dark ${Get.isDarkMode}");
    // print("Theme is dark ${Theme.of(context).brightness == Brightness.dark}");
    // print("--------------------------------------------------------------");

    // printError(info: "<<<<<<<<<<<${Get.isDarkMode} ${Get.isPlatformDarkMode}");
    return GetBuilder<MainScreenController>(
      init: MainScreenController(),
      initState: (_) {},
      builder: (controller) {
        return Scaffold(
          // onBack: () => AppUtil.exitApp(context),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.grey.shade600,
            selectedItemColor: Theme.of(context).primaryColor,
            currentIndex: controller.currentIndex,
            onTap: controller.changePage,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 30,
            items: controller.getItems(),
          ),
          body: controller.listPage[controller.currentIndex],
          // IndexedStack(
          //   index: controller.currentIndex,
          //   children: [
          //     // index tap 0
          //     controller.currentIndex == 0 ? PostsScreen() : Container(),
          //     // index tap 1
          //     const Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [Center(child: Text("Search screen"))],
          //     ),
          //     // index tap 2
          //     controller.currentIndex == 2 ? AddPostScreen() : Container(),
          //     // index tap 3
          //     const Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [Center(child: Text("Activity Screen"))],
          //     ),
          //     // index tap 4
          //     controller.currentIndex == 4 ? AccountScreen() : Container(),
          //   ],
          // ) // controller.listPage.elementAt(controller.currentIndex),
        );
      },
    );
  }
}
