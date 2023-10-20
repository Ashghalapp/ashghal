import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/util/app_util.dart';
import 'core/widget/app_scaffold_widget.dart';
import 'mainscreen_controller.dart';

class MainScreen extends GetView<MainScreenController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    // print();
    print("--------------------------------------------------------------");
    print("Theme is dark ${Get.isDarkMode}");
    print("Theme is dark ${Theme.of(context).brightness == Brightness.dark}");
    print("--------------------------------------------------------------");

    return GetBuilder<MainScreenController>(
      init: MainScreenController(),
      initState: (_) {},
      builder: (controller) {
        return AppScaffold(
          onBack: () => AppUtil.exitApp(context),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.grey.shade600,
            selectedItemColor: Theme.of(context).primaryColor,
            currentIndex: controller.currentIndex,
            onTap: (i) => controller.changePage(i),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 30,
            items: controller.getItems(),
          ),
          child: controller.listPage.elementAt(controller.currentIndex),
        );
      },
    );
  }
}
