import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendingImageViewController extends GetxController {
  RxInt currentIndex = 0.obs;
  List<TextEditingController> captionControllers = [];
  RxList<String> paths;
  SendingImageViewController({required List<String> paths}) : paths = paths.obs;

  final ConversationScreenController _conversationScreenController = Get.find();

  @override
  void onInit() {
    super.onInit();
    captionControllers =
        List.generate(paths.length, (_) => TextEditingController());
  }

  void changeImageIndex(int index) {
    currentIndex.value = index;
  }

  Future<void> sendButtonPressed() async {
    // Get.back<List<String>>(result: paths);
    print("dasdsa");
    for (int i = 0; i < paths.length; i++) {
      if (captionControllers[i].text.trim().isNotEmpty) {
        _conversationScreenController.sendTextAndMultimediaMessage(
            captionControllers[i].text.trim(), paths[i]);
      } else {
        _conversationScreenController.sendMultimediaMessage(paths[i]);
      }
    }
    Get.back();
  }

  @override
  void onClose() {
    for (var controller in captionControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
