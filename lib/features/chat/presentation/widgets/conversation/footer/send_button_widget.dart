import 'package:ashghal_app_frontend/config/app_souds.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';

class SendButtonWidget extends StatelessWidget {
  final InsertingMessageController insertingMessageController;
  final AudioController audioController = Get.find();
  final ConversationScreenController screenController = Get.find();

  SendButtonWidget({
    super.key,
    required this.insertingMessageController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
        right: 2,
        left: 2,
      ),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: ChatStyle.ownMessageColor,
        child: GetX<InsertingMessageController>(
          builder: (controller) {
            // if (controller.sendButtonEnabled.value) {
            //   return IconButton(
            //     icon: Icon(
            //       Icons.send,
            //       color: Colors.white,
            //     ),
            //     onPressed: insertingMessageController.sendMessage,
            //   );
            // } else {
            return GestureDetector(
              onTap: insertingMessageController.sendMessage,
              onLongPress: () async {
                var audioPlayer = AudioPlayer();
                await audioPlayer.play(AssetSource(AppSounds.startRecording));
                audioPlayer.onPlayerComplete.listen((a) {
                  audioController.start.value = DateTime.now();
                  audioController
                      .startRecord(screenController.conversation.userName);
                  audioController.isRecording.value = true;
                });
              },
              onLongPressEnd: (details) {
                audioController.stopRecord();
              },
              child: Icon(
                controller.sendButtonEnabled.value ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
            );
            // }
          },
        ),
      ),
    );
  }
}
