import 'package:ashghal_app_frontend/config/app_souds.dart';
import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';

// class SendButtonWidget extends StatelessWidget {
//   final InsertingMessageController insertingMessageController;
//   final AudioController audioController = Get.find();
//   final ConversationScreenController screenController = Get.find();

//   SendButtonWidget({
//     super.key,
//     required this.insertingMessageController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         bottom: 8,
//         right: 2,
//         left: 2,
//       ),
//       child: CircleAvatar(
//         radius: 25,
//         backgroundColor: ChatStyle.ownMessageColor,
//         child: GetX<InsertingMessageController>(
//           builder: (controller) {
//             // if (controller.sendButtonEnabled.value) {
//             //   return IconButton(
//             //     icon: Icon(
//             //       Icons.send,
//             //       color: Colors.white,
//             //     ),
//             //     onPressed: insertingMessageController.sendMessage,
//             //   );
//             // } else {
//             return GestureDetector(
//               onTap: insertingMessageController.sendMessage,
//               onLongPress: () async {
//                 var audioPlayer = AudioPlayer();
//                 await audioPlayer.play(AssetSource(AppSounds.startRecording));
//                 audioPlayer.onPlayerComplete.listen((a) {
//                   audioController.start.value = DateTime.now();
//                   audioController
//                       .startRecord(screenController.conversation.userName);
//                   audioController.isRecording.value = true;
//                 });
//               },
//               onLongPressEnd: (details) {
//                 audioController.stopRecord();
//               },
//               child: Icon(
//                 controller.sendButtonEnabled.value ? Icons.send : Icons.mic,
//                 color: Colors.white,
//               ),
//             );
//             // }
//           },
//         ),
//       ),
//     );
//   }
// }

class SendButtonWidget extends StatelessWidget {
  final InsertingMessageController insertingMessageController = Get.find();
  final AudioController audioController = Get.find();
  final ConversationScreenController screenController = Get.find();
  SendButtonWidget({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ChatColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ChatColors.primary.withOpacity(0.3),
            spreadRadius: 8,
            blurRadius: 24,
          ),
        ],
      ),
      child: ClipOval(
        child: GetX<InsertingMessageController>(builder: (controller) {
          // if (controller.sendButtonEnabled.value) {
          //   return IconButton(
          //     icon: Icon(
          //       Icons.send,
          //       color: Colors.white,
          //     ),
          //     onPressed: insertingMessageController.sendMessage,
          //   );
          // } else {
          return
              //     GestureDetector(
              //       onTap: insertingMessageController.sendMessage,
              //       onLongPress: () async {
              //         var audioPlayer = AudioPlayer();
              //         await audioPlayer.play(AssetSource(AppSounds.startRecording));
              //         audioPlayer.onPlayerComplete.listen((a) {
              //           audioController.start.value = DateTime.now();
              //           audioController
              //               .startRecord(screenController.conversation.userName);
              //           audioController.isRecording.value = true;
              //         });
              //       },
              //       onLongPressEnd: (details) {
              //         audioController.stopRecord();
              //       },
              //       child: Icon(
              //         controller.sendButtonEnabled.value ? Icons.send : Icons.mic,
              //         color: Colors.white,
              //       ),
              //     );
              //     // }
              //   },
              // ),
              Material(
            color: ChatColors.primary,
            child: GestureDetector(
              // splashColor: ChatColors.cardLight,
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
              child: SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  controller.sendButtonEnabled.value ? Icons.send : Icons.mic,
                  size: 26,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
