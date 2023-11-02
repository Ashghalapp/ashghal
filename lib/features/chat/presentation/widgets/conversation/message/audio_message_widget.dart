import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/upload_download_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
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

  // final playerWaveStyle = const PlayerWaveStyle(
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

  // final playerWaveStyle = const PlayerWaveStyle(
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

// class AudioMessageWidget extends StatelessWidget {
//   final LocalMultimedia multimedia;
//   final bool isMine;
//   final UploadDownloadController _controller;
//   // final int index;
//   // final String time;
//   // final String duration;

//   AudioMessageWidget({
//     super.key,
//     required this.multimedia,
//     required this.isMine,
//     // required this.index,
//     // required this.time,
//     // required this.duration,
//   }) : _controller = Get.put(
//           UploadDownloadController(multimedia: multimedia, isMine: isMine),
//           tag: multimedia.localId.toString(),
//         );

//   AudioController audioController = Get.find();

//   // AudioPlayer audioPlayer = AudioPlayer();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Card(
//           elevation: 0,
//           color: isMine ? Colors.black54 : Colors.white70,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(5),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(7.0),
//             child: Row(
//               children: [
//                 (multimedia.path == null && multimedia.url != null ||
//                         (multimedia.path != null && multimedia.url == null))
//                     ? _controller.dowloading.value
//                         ? DownloadinUploadingCicrularWidget(
//                             controller: _controller)
//                         : PressableCircularContianerWidget(
//                             childPadding: const EdgeInsets.all(4),
//                             onPress: _controller.toggleDownload,
//                             child: DownloadUploadIconWidget(
//                               isMine: isMine,
//                             ),
//                           )
//                     : buildSpeadText(),

//                 // buildSlider(),
//                 Expanded(
//                   child: Obx(
//                     () => Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: LinearProgressIndicator(
//                         backgroundColor:
//                             isMine ? Colors.white70 : Colors.black45,
//                         color: Colors.lightBlue,
//                         value: (audioController.currentId == multimedia.localId
//                             //     &&
//                             // !audioController.isLoading.value
//                             // audioController.isRecordPlaying
//                             )
//                             ? audioController.completedPercentage.value
//                                 .toDouble()
//                             : 0.0,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Obx(
//                 //   () => Text(
//                 //     audioController.currentId == multimedia.localId
//                 //         ? getDurationInMinutesAndSeconds(
//                 //             audioController.currentDuration.value,
//                 //           )
//                 //         : "0:0",
//                 //     style: TextStyle(
//                 //       fontSize: 14,
//                 //       color: isMine ? Colors.white : Colors.white70,
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//         if (!(multimedia.path == null && multimedia.url != null ||
//             (multimedia.path != null && multimedia.url == null)))
//           buildPlayPuaseRow(),
//       ],
//     );
//   }

//   Color _getContentColor() {
//     return isMine
//         ? ChatStyle.ownMessageTextColor
//         : Get.isPlatformDarkMode
//             ? ChatStyle.otherMessageTextDarkColor
//             : ChatStyle.otherMessageTextLightColor;
//   }

//   PressableCircularContianerWidget buildSpeadText() {
//     return PressableCircularContianerWidget(
//       width: 50,
//       color: isMine ? Colors.white30 : Colors.black38,
//       childPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
//       onPress: audioController.increasePlayingSpeed,
//       child: Obx(
//         () => Text(
//           "${audioController.playSpeed} x",
//           style: const TextStyle(color: Colors.white, fontSize: 13),
//         ),
//       ),
//     );
//   }
  // String

  // Expanded buildSlider() {
  //   return Expanded(
  //     child: Obx(
  //       () => Slider(
  //         // divisions: 100,
  //         min: 0,
  //         max: audioController.totalDuration.value.toDouble(),
  //         // max: 101,
  //         // min: 0,
  //         value:
  //             // isSliding
  //             //     ? sliderValue
  //             //     :
  //             (audioController.currentId == multimedia.localId
  //                 //     &&
  //                 // !audioController.isLoading.value
  //                 // audioController.isRecordPlaying
  //                 )
  //                 ? audioController.currentDuration.value.toDouble()
  //                 : 0.0,
  //         // onChangeEnd: (value) {
  //         //   print((value * audioController.totalDuration.value)
  //         //       .toInt());
  //         //   audioController.seekTo(value);
  //         //   setState(() {
  //         //     isSliding = false;
  //         //   });
  //         // },
  //         // onChangeStart: (value) {
  //         //   setState(() {
  //         //     isSliding = true;
  //         //   });
  //         // },
  //         onChanged: (value) {
  //           // setState(() {
  //           //   sliderValue = value;
  //           // });
  //           // print((value * audioController.totalDuration.value)
  //           // .toInt());
  //           audioController.seekTo(value);
  //           // print(value);
  //           // print(audioController.completedPercentage.value);
  //           // audioController.completedPercentage.value =
  //           //     value;
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget buildPlayPuaseRow() {
  //   return Obx(
  //     () => Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         Flexible(
  //           flex: 1,
  //           child: _builPlayingTimeText(),

  //           //  MultimediaSizeTextWidget(
  //           //   size: multimedia.size,
  //           // ),
  //         ),
  //         Flexible(
  //           flex: 2,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               InkWell(
  //                 onTap: () {
  //                   audioController.seekTo(
  //                       audioController.currentDuration.toDouble() + 10);
  //                 },
  //                 child: Icon(
  //                   Icons.fast_rewind_outlined,
  //                   color: audioController.currentId == multimedia.localId
  //                       ? _getContentColor().withOpacity(0.7)
  //                       : _getContentColor().withOpacity(0.6),
  //                   size: 28,
  //                 ),
  //                 //  Image.asset(
  //                 //   'assets/icons/rewind.png',
  //                 //   height: 20,
  //                 //   width: 20,
  //                 // ),
  //               ),
  //               // const SizedBox(width: 15),
  //               InkWell(
  //                 onTap: () => audioController.onPressedPlayButton(
  //                   multimedia.localId,
  //                   multimedia.path!,
  //                 ),
  //                 child: Icon(
  //                   audioController.isRecordPlaying.value &&
  //                           audioController.currentId == multimedia.localId
  //                       ? Icons.pause_circle
  //                       : Icons.play_circle,
  //                   color: audioController.currentId == multimedia.localId
  //                       ? _getContentColor().withOpacity(0.7)
  //                       : _getContentColor().withOpacity(0.6),
  //                   size: 28,
  //                 ),
  //               ),
  //               // const SizedBox(width: 15),
  //               InkWell(
  //                   onTap: () {
  //                     audioController.seekTo(
  //                         audioController.currentDuration.toDouble() + 10);
  //                   },
  //                   child: Icon(
  //                     Icons.fast_forward_outlined,
  //                     // Icons.keyboard_double_arrow_right_sharp,
  //                     color: audioController.currentId == multimedia.localId
  //                         ? _getContentColor().withOpacity(0.7)
  //                         : _getContentColor().withOpacity(0.6),
  //                     size: 28,
  //                   )
  //                   // Image.asset(
  //                   //   'assets/icons/forward.png',
  //                   //   height: 20,
  //                   //   width: 20,
  //                   // ),
  //                   ),
  //             ],
  //           ),
  //         ),
  //         // if (audioController.currentId == multimedia.localId)
  //         Flexible(
  //           flex: 1,
  //           child: Obx(
  //             () => _buildTotalTimeText(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Text _buildTotalTimeText() {
  //   return Text(
  //     (audioController.currentId == multimedia.localId)
  //         ?
  //         //     ? audioController.completedPercentage.value.toString()
  //         //     : audioController.totalDuration.value.toDouble().toString(),
  //         getDurationInMinutesAndSeconds(audioController.totalDuration.value)
  //         : "0:0",
  //     style: TextStyle(
  //       fontSize: 14,
  //       color: _getContentColor(),
  //     ),
  //   );
  // }

  // Text _builPlayingTimeText() {
  //   return Text(
  //     audioController.currentId == multimedia.localId
  //         ? getDurationInMinutesAndSeconds(
  //             audioController.currentDuration.value,
  //           )
  //         : "0:0",
  //     style: TextStyle(
  //       fontSize: 14,
  //       color: _getContentColor(),
  //     ),
  //   );
  // }

  // String getDurationInMinutesAndSeconds(int durationInSeconds) {
  //   Duration duration = Duration(seconds: durationInSeconds);
  //   return "${duration.inMinutes} : ${duration.inSeconds}";
  //   // return "${durationInSeconds > 59 ? durationInSeconds % 60 : 0}:${durationInSeconds > 59 ? durationInSeconds % 60 : durationInSeconds}";
  //   // audioController.currentDuration>
  // }

  // Padding buildIcon() {
  //   return Padding(
  //     padding: const EdgeInsets.only(right: 5.0),
  //     child: (multimedia.path == null && multimedia.url != null
  //             // !widget.isMine)
  //             ||
  //             (multimedia.path != null && multimedia.url == null))
  //         ? PressableCircularContianerWidget(
  //             childPadding: EdgeInsets.all(4),
  //             onPress: _controller.toggleDownload,
  //             child: DownloadUploadIconWidget(
  //               isMine: isMine,
  //             ),
  //           )
  //         : PressableCircularContianerWidget(
  //             childPadding: EdgeInsets.all(4),
  //             onPress: () => audioController.onPressedPlayButton(
  //               multimedia.localId,
  //               multimedia.path!,
  //             ),
  //             child: (audioController.isRecordPlaying &&
  //                     audioController.currentId == multimedia.localId)
  //                 ? Icon(
  //                     Icons.pause,
  //                     color: isMine ? Colors.white : ChatStyle.ownMessageColor,
  //                     size: 25,
  //                   )
  //                 : Icon(
  //                     Icons.play_arrow,
  //                     color: isMine ? Colors.white : ChatStyle.ownMessageColor,
  //                     size: 30,
  //                   ),
  //           ),
  //   );
  // }
// }

// child: Row(
//       children: [
//         const Icon(
//           Icons.play_arrow,
//           size: 25,
//         ),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5),
//             child: Stack(
//               clipBehavior: Clip.none,
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 2,
//                   color: Colors.black,
//                 ),
//                 Positioned(
//                   left: 0,
//                   child: Container(
//                     width: 8,
//                     height: 8,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // const SizedBox(
//         //   width: 5,
//         // ),
//         const Text(
//           "1:50",
//           style: TextStyle(),
//         ),
//       ],
//     ),
