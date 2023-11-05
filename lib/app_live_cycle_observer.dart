import 'package:ashghal_app_frontend/app_live_cycle_controller.dart';
import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLifeCycleManager extends StatefulWidget {
  const AppLifeCycleManager({super.key, required this.child});
  final Widget child;

  @override
  State<AppLifeCycleManager> createState() => _AppLifeCycleManagerState();
}

class _AppLifeCycleManagerState extends State<AppLifeCycleManager>
    with WidgetsBindingObserver {
      
      @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

 @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  

  }

 @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  AppLifeCycleController cycleController = Get.find();
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        AppPrint.printData("AppLifecycleState.resumed");
        cycleController.isAppResumed.value = true;
        break;
      case AppLifecycleState.inactive:
        AppPrint.printData("AppLifecycleState.inactive");
        break;
      case AppLifecycleState.paused:
        AppPrint.printData("AppLifecycleState.paused");
        cycleController.isAppResumed.value = false;
      break;
      case AppLifecycleState.detached:
        AppPrint.printData("AppLifecycleState.detached");
        // isAppResumed.value = false;
        break;
    }
  }
}
