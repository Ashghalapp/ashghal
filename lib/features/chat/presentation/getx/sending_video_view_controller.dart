import 'dart:io';

import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SendingVideoViewController extends GetxController {
  late VideoPlayerController videoPlayerController;
  String path;
  SendingVideoViewController({required String path}) : this.path = path;
  final ConversationController _conversationController = Get.find();
  @override
  void onInit() {
    super.onInit();
    videoPlayerController = VideoPlayerController.file(File(path))
      ..initialize().then((value) {
        // Ensure the first frame is shown after the video is initialized,
        //even before the play button has been pressed.
      });
  }

  void playPauseVideo() {
    videoPlayerController.value.isPlaying
        ? videoPlayerController.pause()
        : videoPlayerController.play();
  }

  Future<void> sendButtonPressed() async {
    // Get.back<List<String>>(result: paths);

    _conversationController.sendMultimediaMessage(path);
    Get.back();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}
