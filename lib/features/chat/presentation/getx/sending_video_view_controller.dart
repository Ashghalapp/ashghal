import 'dart:io';

import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SendingVideoViewController extends GetxController {
  late VideoPlayerController videoPlayerController;
  String path;
  SendingVideoViewController({required this.path});
  final ConversationScreenController _conversationScreenController = Get.find();
  RxBool isInitialized = false.obs;
  RxBool isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    videoPlayerController = VideoPlayerController.file(File(path));
    videoPlayerController.setLooping(true);
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    await videoPlayerController.initialize();
    isInitialized.value = true;
  }

  void playPauseVideo() {
    if (isInitialized.value) {
      isPlaying.value
          ? videoPlayerController.pause()
          : videoPlayerController.play();
      isPlaying.value = !isPlaying.value;
    }
  }

  Future<void> sendButtonPressed() async {
    _conversationScreenController.sendMultimediaMessage(path);
    Get.back();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}
