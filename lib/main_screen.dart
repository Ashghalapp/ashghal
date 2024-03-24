
import 'package:ashghal_app_frontend/bottombar_builder_widget.dart';
import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/widget/fade_transition_widget.dart';
import 'package:ashghal_app_frontend/core/widget/horizontal_slide_transition_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mainscreen_controller.dart';

class MainScreen extends GetView<MainScreenController> {
  const MainScreen({super.key});

  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController(), permanent: false);
    // print();
    // print("--------------------------------------------------------------");
    // print("Theme is dark ${Get.isDarkMode}");
    // print("Theme is dark ${Theme.of(context).brightness == Brightness.dark}");
    // print("--------------------------------------------------------------");

    // final animationCon = AnimationController(
    //   duration: const Duration(milliseconds: 400),
    //   vsync: Navigator.of(context),
    // );

    // Timer(const Duration(seconds: 1), () {
    //   animationCon.forward();
    // });

    // printError(info: "<<<<<<<<<<<${Get.isDarkMode} ${Get.isPlatformDarkMode}");
    return GetBuilder<MainScreenController>(
      init: MainScreenController(),
      initState: (_) {},
      builder: (controller) {
        AppPrint.printInfo("Main Screen rebuild");
        return Scaffold(
          key: scaffoldKey,
          // onBack: () => AppUtil.exitApp(context),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HorizontalSlideTransitionWidget(
                millisecondToLate: 800,
                milliseconds: 600,
                child: BottombarBuilderWidget(
                  onTap: controller.changePage,
                  currentIndex: controller.currentIndex,
                ),
              ),
            ],
          ),
          body: FadeTransitionWidget(
            milliseconds: 500,
            child: controller.listPage[controller.currentIndex],
          ),
        );
      },
    );
  }
}
