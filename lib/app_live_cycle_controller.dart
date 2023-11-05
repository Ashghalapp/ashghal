import 'package:get/get.dart';

class AppLifeCycleController extends GetxController {
  final RxBool isAppResumed = true.obs;

  // @override
  // void onInit() {
  //   appLifecycleObserver.isAppResumed.bindStream(isAppResumed.stream);
  //   super.onInit();
  // }

  // @override
  // void onClose() {
  //   appLifecycleObserver.isAppResumed.close();
  //   super.onClose();
  // }
}
