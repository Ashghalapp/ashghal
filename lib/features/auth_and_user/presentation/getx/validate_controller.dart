import 'dart:async';
import 'package:get/get.dart';


class ValidateController extends GetxController {
  RxInt remainingSeconds = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds.value--;

      if (remainingSeconds.value <= 0) {
        _timer?.cancel();
        update();
      }
    });
  }

  void resendCode(Function resendCodeFunction) async {
    if (await resendCodeFunction()) {
      remainingSeconds.value = 60; // Reset the timer to the initial value
      startTimer();
      update();
    }
  }
}
