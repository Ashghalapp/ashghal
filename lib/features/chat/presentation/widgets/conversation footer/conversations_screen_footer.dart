import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation%20footer/attachment_bottom_sheet.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation%20footer/emoji_picker_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation%20footer/send_button_widget.dart';
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
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 7),
        hintText: AppLocalization.typeMessage.tr,
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
        color: Colors.transparent,
      ),
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
