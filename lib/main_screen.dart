import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mainscreen_controller.dart';

class MainScreen extends GetView<MainScreenController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());

    return GetBuilder<MainScreenController>(
      init: MainScreenController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              surfaceTintColor: Colors.white,
              toolbarHeight: 20,
              backgroundColor: Colors.white,
            ),
            bottomNavigationBar: BottomNavigationBar(
              // selectedFontSize: 20,
                unselectedItemColor: Colors.grey.shade600,
                selectedItemColor: Colors.black87,
                currentIndex: controller.currentIndex,
                onTap: (i) => controller.changePage(i),
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                iconSize: 30,
                items: controller.items),
            body: controller.listPage.elementAt(controller.currentIndex));
      },
    );
  }
}
