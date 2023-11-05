import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/upload_download_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/chat_style.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AudioMessageWidget extends StatelessWidget {
  final LocalMultimedia multimedia;
  final bool isMine;
  final UploadDownloadController _uploadDownloadController;
  final AudioMessageController _audioController;

  AudioMessageWidget({
    super.key,
    required this.multimedia,
    required this.isMine,
  })  : _uploadDownloadController = Get.put(
          UploadDownloadController(multimedia: multimedia, isMine: isMine),
          tag: multimedia.localId.toString(),
        ),
        _audioController = Get.put(
          AudioMessageController(multimedia: multimedia),
          tag: multimedia.localId.toString(),
        );

  AudioController audioGeneralController = Get.find();

  final playerWaveStyle = PlayerWaveStyle(
    fixedWaveColor: Get.isPlatformDarkMode ? Colors.white54 : Colors.black38,
    liveWaveColor: Get.isPlatformDarkMode ? Colors.white70 : Colors.black87,
    spacing: 6,
    waveCap: StrokeCap.square,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 45,
        maxHeight: 65,
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (multimedia.path == null && multimedia.url != null ||
                      (multimedia.path != null && multimedia.url == null))
                  ? Obx(
                      () => _uploadDownloadController.dowloading.value
                          ? Row(
                              children: [
                                DownloadinUploadingCicrularWidget(
                                  onCancel:
                                      _uploadDownloadController.cancelDownload,
                                  cancelIconColor: null,
                                ),
                                Obx(
                                  () => DownloadingUploadingProgressPercent(
                                    value: _uploadDownloadController
                                        .progress.value,
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: _uploadDownloadController.toggleDownload,
                              child: DownloadUploadIconWidget(
                                isMine: isMine,
                                iconSize: 24,
                                color: null,
                              ),
                            ),
                    )
                  : InkWell(
                      onTap: _audioController.playPuaseButtonPressed,
                      child: Obx(
                        () => Icon(
                          audioGeneralController.currentId.value ==
                                      multimedia.localId &&
                                  _audioController.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 33,
                        ),
                      ),
                    ),
              Obx(
                () => _audioController.isPlayerPrepared.value
                    ? AudioFileWaveforms(
                        padding: const EdgeInsets.all(0),
                        margin: const EdgeInsets.all(0),
                        size:
                            Size(MediaQuery.of(context).size.width / 2.15, 25),
                        playerController: _audioController.playerController,
                        waveformType: WaveformType.long,
                        playerWaveStyle: playerWaveStyle,
                      )
                    : Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                height: 3,
                                color: Get.isPlatformDarkMode
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 3),
                            if ((multimedia.path == null &&
                                    multimedia.url != null) ||
                                (multimedia.path != null &&
                                    multimedia.url == null))
                              MultimediaSizeTextWidget(
                                size: multimedia.size,
                                isMine: isMine,
                              )
                          ],
                        ),
                      ),
              ),
            ],
          ),
          Obx(
            () => _audioController.isPlayerPrepared.value
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 6.0, right: 6.0, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _builPlayingTimeText(),
                        _buildTotalTimeText(),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Color _getContentColor() {
    return isMine
        ? ChatStyle.ownMessageTextColor
        : Get.isPlatformDarkMode
            ? ChatStyle.otherMessageTextDarkColor
            : ChatStyle.otherMessageTextLightColor;
  }

  Widget _buildTotalTimeText() {
    return Obx(
      () => Text(
        getDurationInMinutesAndSeconds(
          _audioController.totalDuration.value,
        ),
        style: TextStyle(
          fontSize: 14,
          color: _getContentColor(),
        ),
      ),
    );
  }

  Widget _builPlayingTimeText() {
    return Obx(
      () => Text(
        getDurationInMinutesAndSeconds(
          _audioController.currentDuration.value,
        ),
        style: TextStyle(
          fontSize: 14,
          color: _getContentColor(),
        ),
      ),
    );
  }

  String getDurationInMinutesAndSeconds(int durationInMiliseconds) {
    Duration duration = Duration(milliseconds: durationInMiliseconds);
    return "${duration.inMinutes} : ${duration.inSeconds}";
  }
}

// ignore: must_be_immutable
class ReadyAudioMessageWidget extends StatelessWidget {
  final LocalMultimedia multimedia;
  final bool isMine;
  final AudioMessageController _audioController;

  ReadyAudioMessageWidget({
    super.key,
    required this.multimedia,
    required this.isMine,
  }) : _audioController = Get.put(
          AudioMessageController(multimedia: multimedia, isReady: true),
          tag: multimedia.localId.toString(),
        );

  AudioController audioGeneralController = Get.find();

  final playerWaveStyle = PlayerWaveStyle(
    fixedWaveColor: Get.isPlatformDarkMode ? Colors.white54 : Colors.black38,
    liveWaveColor: Get.isPlatformDarkMode ? Colors.white70 : Colors.black87,
    spacing: 6,
    waveCap: StrokeCap.square,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 45,
        maxHeight: 65,
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: _audioController.playPuaseButtonPressed,
                child: Obx(
                  () => Icon(
                    audioGeneralController.currentId.value ==
                                multimedia.localId &&
                            _audioController.isPlaying.value
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 33,
                  ),
                ),
              ),
              Obx(
                () => _audioController.isPlayerPrepared.value
                    ? AudioFileWaveforms(
                        padding: const EdgeInsets.all(0),
                        margin: const EdgeInsets.all(0),
                        size:
                            Size(MediaQuery.of(context).size.width / 2.15, 25),
                        playerController: _audioController.playerController,
                        waveformType: WaveformType.long,
                        playerWaveStyle: playerWaveStyle,
                      )
                    : Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                height: 3,
                                color: Get.isPlatformDarkMode
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 3),
                            if ((multimedia.path == null &&
                                    multimedia.url != null) ||
                                (multimedia.path != null &&
                                    multimedia.url == null))
                              MultimediaSizeTextWidget(
                                size: multimedia.size,
                                isMine: isMine,
                              )
                          ],
                        ),
                      ),
              ),
            ],
          ),
          Obx(
            () => _audioController.isPlayerPrepared.value
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 6.0, right: 6.0, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _builPlayingTimeText(),
                        _buildTotalTimeText(),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Color _getContentColor() {
    return isMine
        ? ChatStyle.ownMessageTextColor
        : Get.isPlatformDarkMode
            ? ChatStyle.otherMessageTextDarkColor
            : ChatStyle.otherMessageTextLightColor;
  }

  Widget _buildTotalTimeText() {
    return Obx(
      () => Text(
        getDurationInMinutesAndSeconds(
          _audioController.totalDuration.value,
        ),
        style: TextStyle(
          fontSize: 14,
          color: _getContentColor(),
        ),
      ),
    );
  }

  Widget _builPlayingTimeText() {
    return Obx(
      () => Text(
        getDurationInMinutesAndSeconds(
          _audioController.currentDuration.value,
        ),
        style: TextStyle(
          fontSize: 14,
          color: _getContentColor(),
        ),
      ),
    );
  }

  String getDurationInMinutesAndSeconds(int durationInMiliseconds) {
    Duration duration = Duration(milliseconds: durationInMiliseconds);
    return "${duration.inMinutes} : ${duration.inSeconds}";
  }
}
