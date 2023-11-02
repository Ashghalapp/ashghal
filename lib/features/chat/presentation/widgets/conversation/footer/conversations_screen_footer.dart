// import 'package:ashghal_app_frontend/config/chat_theme.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/screens/camera_screen.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/attachment_bottom_sheet.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/emoji_picker_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';

// class ChatTextFormFieldWidget extends StatelessWidget {
//   final InsertingMessageController insertingMessageController = Get.find();
//   final MultimediaController multimediaController = Get.find();

//   ChatTextFormFieldWidget({super.key});
//   Color getIconsColor(context) =>
//       Theme.of(context).brightness == Brightness.light
//           ? Colors.black54
//           : Colors.white70;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.sizeOf(context).width * 0.85,
//       child: Card(
//         elevation: 2,
//         // shadowColor: Colors.grey,
//         margin: const EdgeInsets.only(left: 6, right: 2, bottom: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50),
//         ),
//         child: TextFormField(
//           onChanged: insertingMessageController.sendTypingNotification,
//           controller: insertingMessageController.messageTextEdittingController,
//           focusNode: insertingMessageController.messageFieldFocusNode,
//           textAlignVertical: TextAlignVertical.center,
//           keyboardType: TextInputType.multiline,
//           maxLines: 5,
//           minLines: 1,
//           style: const TextStyle(color: Colors.black87, fontSize: 16),
//           decoration: InputDecoration(
//             hintStyle: const TextStyle(fontSize: 18),
//             fillColor: Colors.white,
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(50),
//               borderSide: const BorderSide(color: Colors.transparent),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(50),
//               borderSide: const BorderSide(color: Colors.transparent),
//             ),
//             hintText: "Message",
//             // contentPadding: const EdgeInsets.all(5),
//             // border: InputBorder(),
//             prefixIcon: GetX<InsertingMessageController>(
//               builder: (controller) => IconButton(
//                 onPressed: controller.imojiButtonPressed,
//                 icon: Icon(
//                   controller.emojiPickerShowing.value
//                       ? Icons.keyboard
//                       : Icons.emoji_emotions_outlined,
//                   color: getIconsColor(context),
//                 ),
//               ),
//             ),
//             suffixIcon: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 //Attachment Button
//                 IconButton(
//                   onPressed: () async {
//                     await showAttachmentBottomSheet(multimediaController);
//                   },
//                   icon: Icon(
//                     Icons.attach_file,
//                     color: getIconsColor(context),
//                   ),
//                 ),

//                 IconButton(
//                   onPressed: multimediaController.goToCameraScreen,
//                   icon: Icon(
//                     Icons.camera_alt,
//                     color: getIconsColor(context),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/attachment_bottom_sheet.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/emoji_picker_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/send_button_widget.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationScreenFooter extends StatelessWidget {
  ConversationScreenFooter({Key? key}) : super(key: key);

  final InsertingMessageController insertingMessageController = Get.find();

  final MultimediaController multimediaController = Get.find();
  final AudioController audioController = Get.find();
  final ConversationScreenController screenController = Get.find();

  Color? getIconsColor() => Get.isPlatformDarkMode ? null : Colors.black54;

  // final StreamMessageInputController controller =
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(
              () => audioController.isRecording.value ||
                      audioController.isRecordingCompleted.value
                  ? _buildRecordingRow(context)
                  : _buildWritingMessageRow(context),
            ),
            //this widget shows or unshows its child based on the offstage value
            GetX<InsertingMessageController>(
              builder: (controller) => Offstage(
                offstage: !controller.emojiPickerShowing.value,
                child: SizedBox(
                  height: 250,
                  child: EmojiPickerWidget(
                    textEditingController: insertingMessageController
                        .messageTextEdittingController,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildWritingMessageRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 12.0,
            right: 6,
          ),
          child: InkWell(
            onTap: insertingMessageController.imojiButtonPressed,
            child: Obx(
              () => Icon(
                insertingMessageController.emojiPickerShowing.value
                    ? Icons.keyboard
                    : Icons.emoji_emotions_outlined,
                color: getIconsColor(),
              ),
            ),
          ),
        ),
        Expanded(
          child: _buildTextField(),
        ),
        InkWell(
          onTap: () async {
            await showAttachmentBottomSheet(multimediaController);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Icon(
              Icons.attach_file,
              color: getIconsColor(),
            ),
          ),
        ),
        const SizedBox(width: 7),
        InkWell(
          onTap: multimediaController.goToCameraScreen,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Icon(
              Icons.camera_alt_sharp,
              color: getIconsColor(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 14,
            bottom: 3,
            // right: 10,
          ),
          child: Obx(
            () => SendButtonWidget(
              icon: insertingMessageController.sendButtonEnabled.value
                  ? Icons.send
                  : Icons.mic,
              onPressed: () {
                if (insertingMessageController.sendButtonEnabled.value) {
                  insertingMessageController.sendMessage();
                } else {
                  audioController.startRecord(
                      screenController.currentConversation.userName);
                }
              },
              onLongPressed: () {
                if (!insertingMessageController.sendButtonEnabled.value) {
                  audioController.startRecord(
                      screenController.currentConversation.userName);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Row _buildRecordingRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () => Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Row(
              children: [
                if (!audioController.isRecording.value)
                  InkWell(
                    onTap: audioController.cancelRecord,
                    child: Icon(
                      Icons.cancel_outlined,
                      color: getIconsColor(),
                      size: 28,
                    ),
                  ),
                const SizedBox(width: 4),
                _builRecordingTimerText()
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => audioController.isRecording.value
                ? _buildRecordingWaves(context)
                : _buildPlayingWaves(context),
          ),
        ),
        const SizedBox(width: 7),
        Obx(
          () => audioController.isRecordingCompleted.value
              ? audioController.isPlayerPrepared.value
                  ? InkWell(
                      onTap: audioController.playPauseRecord,
                      child: Icon(
                        audioController.isRecordPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: getIconsColor(),
                        size: 30,
                      ),
                    )
                  : Transform.scale(
                      scale: 0.6,
                      child: const CircularProgressIndicator(),
                    )
              : const SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 14,
            bottom: 3,
            // right: 10,
          ),
          child: Obx(
            () => SendButtonWidget(
              icon: audioController.isRecording.value ? Icons.stop : Icons.send,
              onPressed: () {
                if (audioController.isRecording.value) {
                  audioController.stopRecord();
                } else if (audioController.isRecordingCompleted.value) {
                  audioController.uploadAudio();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _builRecordingTimerText() {
    return Obx(
      () => Text(
        getDurationInMinutesAndSeconds(
          audioController.recordingDurationInSeconds.value,
        ),
        style: const TextStyle(
          fontSize: 14,
          // color: _getContentColor(),
        ),
      ),
    );
  }

  String getDurationInMinutesAndSeconds(int durationInSeconds) {
    Duration duration = Duration(seconds: durationInSeconds);
    return "${duration.inMinutes} : ${duration.inSeconds}";
  }

  TextFormField _buildTextField() {
    return TextFormField(
      onChanged: insertingMessageController.sendTypingNotification,
      controller: insertingMessageController.messageTextEdittingController,
      focusNode: insertingMessageController.messageFieldFocusNode,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      minLines: 1,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(
        fontSize: 18,
        color: Get.isPlatformDarkMode ? Colors.white : Colors.black,
      ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 7),
        hintText: 'Type something...',
        border: InputBorder.none,
      ),
    );
  }

  AudioWaveforms _buildRecordingWaves(BuildContext context) {
    return AudioWaveforms(
      enableGesture: true,
      size: Size(MediaQuery.of(context).size.width / 2, 25),
      recorderController: audioController.recorderController,
      waveStyle: WaveStyle(
        waveColor: Get.isPlatformDarkMode ? Colors.white : Colors.black,
        extendWaveform: true,
        showMiddleLine: false,
      ),
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(12.0),
        // color: const Color(0xFF1E1B26),
        color: Colors.transparent,
      ),
      // padding: const EdgeInsets.only(left: 18),
      // margin: const EdgeInsets.symmetric(horizontal: 15),
    );
  }

  _buildPlayingWaves(BuildContext context) {
    return AudioFileWaveforms(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      size: Size(MediaQuery.of(context).size.width / 2, 25),
      playerController: audioController.currentPlayer,
      waveformType: WaveformType.fitWidth,
      playerWaveStyle: PlayerWaveStyle(
        fixedWaveColor:
            Get.isPlatformDarkMode ? Colors.white54 : Colors.black54,
        liveWaveColor: Get.isPlatformDarkMode ? Colors.white : Colors.black,
        spacing: 6,
        waveCap: StrokeCap.square,
      ),
    );
  }
}
// Row _buildWritingMessageRow(BuildContext context) {
//   return Row(
//             crossAxisAlignment:
//                 audioController2.isRecordingCompleted.value ||
//                         audioController2.isRecording.value ||
//                         audioController2.isRecordPlaying.value
//                     ? CrossAxisAlignment.center
//                     : CrossAxisAlignment.end,
//             children: [
//               Obx(
//                 () => audioController2.isRecording.value
//                     ? const SizedBox.shrink()
//                     : Padding(
//                         padding: EdgeInsets.only(
//                           bottom:
//                               audioController2.isRecordingCompleted.value
//                                   ? 0
//                                   : 12.0,
//                           right: 6,
//                         ),
//                         child: InkWell(
//                           onTap: () {
//                             if (audioController2
//                                 .isRecordingCompleted.value) {
//                               audioController2.cancelRecord();
//                             } else {
//                               insertingMessageController
//                                   .imojiButtonPressed();
//                             }
//                           },
//                           child: Icon(
//                             audioController2.isRecordingCompleted.value
//                                 ? Icons.cancel_outlined
//                                 : insertingMessageController
//                                         .emojiPickerShowing.value
//                                     ? Icons.keyboard
//                                     : Icons.emoji_emotions_outlined,
//                             color: getIconsColor(),
//                             size:
//                                 audioController2.isRecordingCompleted.value
//                                     ? 30
//                                     : null,
//                           ),
//                         ),
//                       ),
//               ),
//               Expanded(
//                 child: Obx(
//                   () => audioController2.isRecording.value
//                       ? _buildRecordingWaves(context)
//                       : audioController2.isRecordingCompleted.value
//                           ? _buildPlayingWaves(context)
//                           : _buildTextField(),
//                 ),
//               ),
//               Obx(
//                 () => audioController2.isRecording.value ||
//                         audioController2.isRecordingCompleted.value
//                     ? const SizedBox.shrink()
//                     : InkWell(
//                         onTap: () async {
//                           await showAttachmentBottomSheet(
//                               multimediaController);
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 12.0),
//                           child: Icon(
//                             Icons.attach_file,
//                             color: getIconsColor(),
//                           ),
//                         ),
//                       ),
//               ),
//               const SizedBox(width: 7),
//               Obx(
//                 () => audioController2.isRecording.value
//                     ? const SizedBox.shrink()
//                     : audioController2.isRecordingCompleted.value
//                         ? InkWell(
//                             onTap: audioController2.playPauseRecord,
//                             child: Padding(
//                               padding: const EdgeInsets.only(bottom: 12.0),
//                               child: Icon(
//                                 audioController2.isRecordPlaying.value
//                                     ? Icons.pause
//                                     : Icons.play_arrow,
//                                 color: getIconsColor(),
//                                 size: 30,
//                               ),
//                             ),
//                           )
//                         : InkWell(
//                             onTap: multimediaController.goToCameraScreen,
//                             child: Padding(
//                               padding: const EdgeInsets.only(bottom: 12.0),
//                               child: Icon(
//                                 Icons.camera_alt_sharp,
//                                 color: getIconsColor(),
//                               ),
//                             ),
//                           ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                   left: 14,
//                   bottom: 3,
//                   // right: 10,
//                 ),
//                 child: SendButtonWidget(
//                   icon: Icons.send_rounded,
//                   onPressed: () {},
//                 ),
//               ),
//             ],
//           );
// }
