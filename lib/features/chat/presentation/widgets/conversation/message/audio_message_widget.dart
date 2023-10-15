import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/upload_download_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// class AudioMessageWidget extends StatelessWidget {
//   const AudioMessageWidget({
//     super.key,
//     required this.message,
//     required this.isMine,
//   });

//   final LocalMessage message;
//   final bool isMine;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
//       width: MediaQuery.sizeOf(context).width * 0.50,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(50),
//         color: isMine
//             ? ChatStyle.ownMessageColor
//             : ChatStyle.ownMessageColor.withOpacity(0.3),
//       ),
//       child: Row(
//         children: [

//         ],
//       ),
//     );
//   }
// }
// Widget _audio({
//   required String message,
//   required bool isCurrentUser,
//   required int index,
//   required String time,
//   required String duration,
// }) {
//   return AudioMessageWidget();
// }

class AudioMessageWidget extends StatelessWidget {
  final LocalMultimedia multimedia;
  final bool isMine;
  final UploadDownloadController _controller;
  // final int index;
  // final String time;
  // final String duration;

  AudioMessageWidget({
    super.key,
    required this.multimedia,
    required this.isMine,
    // required this.index,
    // required this.time,
    // required this.duration,
  }) : _controller = Get.put(
          UploadDownloadController(multimedia: multimedia, isMine: isMine),
          tag: multimedia.localId.toString(),
        );

  AudioController audioController = Get.find();

  // AudioPlayer audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          color: Colors.black54,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              children: [
                (multimedia.path == null && multimedia.url != null ||
                        (multimedia.path != null && multimedia.url == null))
                    ? _controller.dowloading.value
                        ? DownloadinUploadingCicrularWidget(
                            controller: _controller)
                        : PressableCircularContianerWidget(
                            childPadding: EdgeInsets.all(4),
                            onPress: _controller.toggleDownload,
                            child: DownloadUploadIconWidget(
                              isMine: isMine,
                            ),
                          )
                    : buildSpeadText(),

                // buildSlider(),
                Expanded(
                  child: Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(
                        color: Colors.lightBlue,
                        value: (audioController.currentId == multimedia.localId
                            //     &&
                            // !audioController.isLoading.value
                            // audioController.isRecordPlaying
                            )
                            ? audioController.completedPercentage.value
                                .toDouble()
                            : 0.0,
                      ),
                    ),
                  ),
                ),
                // Obx(
                //   () => Text(
                //     audioController.currentId == multimedia.localId
                //         ? getDurationInMinutesAndSeconds(
                //             audioController.currentDuration.value,
                //           )
                //         : "0:0",
                //     style: TextStyle(
                //       fontSize: 14,
                //       color: isMine ? Colors.white : Colors.white70,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        if (!(multimedia.path == null && multimedia.url != null ||
            (multimedia.path != null && multimedia.url == null)))
          buildPlayPuaseRow(),
      ],
    );
  }

  PressableCircularContianerWidget buildSpeadText() {
    return PressableCircularContianerWidget(
      color: Colors.white30,
      childPadding: const EdgeInsets.all(6),
      onPress: audioController.increasePlayingSpeed,
      child: Obx(
        () => Text(
          "${audioController.playSpeed} x",
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  Expanded buildSlider() {
    return Expanded(
      child: Obx(
        () => Slider(
          // divisions: 100,
          min: 0,
          max: audioController.totalDuration.value.toDouble(),
          // max: 101,
          // min: 0,
          value:
              // isSliding
              //     ? sliderValue
              //     :
              (audioController.currentId == multimedia.localId
                  //     &&
                  // !audioController.isLoading.value
                  // audioController.isRecordPlaying
                  )
                  ? audioController.currentDuration.value.toDouble()
                  : 0.0,
          // onChangeEnd: (value) {
          //   print((value * audioController.totalDuration.value)
          //       .toInt());
          //   audioController.seekTo(value);
          //   setState(() {
          //     isSliding = false;
          //   });
          // },
          // onChangeStart: (value) {
          //   setState(() {
          //     isSliding = true;
          //   });
          // },
          onChanged: (value) {
            // setState(() {
            //   sliderValue = value;
            // });
            // print((value * audioController.totalDuration.value)
            // .toInt());
            audioController.seekTo(value);
            // print(value);
            // print(audioController.completedPercentage.value);
            // audioController.completedPercentage.value =
            //     value;
          },
        ),
      ),
    );
  }

  Widget buildPlayPuaseRow() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              audioController.currentId == multimedia.localId
                  ? getDurationInMinutesAndSeconds(
                      audioController.currentDuration.value,
                    )
                  : "0:0",
              style: TextStyle(
                fontSize: 14,
                color: isMine ? Colors.white : Colors.white70,
              ),
            ),

            //  MultimediaSizeTextWidget(
            //   size: multimedia.size,
            // ),
          ),
          Flexible(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    audioController.seekTo(
                        audioController.currentDuration.toDouble() + 10);
                  },
                  child: Icon(
                    Icons.fast_rewind_outlined,
                    color: audioController.currentId == multimedia.localId
                        ? Colors.white
                        : Colors.white70,
                    size: 28,
                  ),
                  //  Image.asset(
                  //   'assets/icons/rewind.png',
                  //   height: 20,
                  //   width: 20,
                  // ),
                ),
                // const SizedBox(width: 15),
                InkWell(
                  onTap: () => audioController.onPressedPlayButton(
                    multimedia.localId,
                    multimedia.path!,
                  ),
                  child: Icon(
                    audioController.isRecordPlaying &&
                            audioController.currentId == multimedia.localId
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color: audioController.currentId == multimedia.localId
                        ? Colors.white
                        : Colors.white70,
                    size: 28,
                  ),
                ),
                // const SizedBox(width: 15),
                InkWell(
                    onTap: () {
                      audioController.seekTo(
                          audioController.currentDuration.toDouble() + 10);
                    },
                    child: Icon(
                      Icons.fast_forward_outlined,
                      // Icons.keyboard_double_arrow_right_sharp,
                      color: audioController.currentId == multimedia.localId
                          ? Colors.white
                          : Colors.white70,
                      size: 28,
                    )
                    // Image.asset(
                    //   'assets/icons/forward.png',
                    //   height: 20,
                    //   width: 20,
                    // ),
                    ),
              ],
            ),
          ),
          // if (audioController.currentId == multimedia.localId)
          Flexible(
            flex: 1,
            child: Obx(
              () => Text(
                (audioController.currentId == multimedia.localId)
                    ?
                    //     ? audioController.completedPercentage.value.toString()
                    //     : audioController.totalDuration.value.toDouble().toString(),
                    getDurationInMinutesAndSeconds(
                        audioController.totalDuration.value)
                    : "0:0",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getDurationInMinutesAndSeconds(int durationInSeconds) {
    Duration duration = Duration(seconds: durationInSeconds);
    return "${duration.inMinutes} : ${duration.inSeconds}";
    // return "${durationInSeconds > 59 ? durationInSeconds % 60 : 0}:${durationInSeconds > 59 ? durationInSeconds % 60 : durationInSeconds}";
    // audioController.currentDuration>
  }

  Padding buildIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: (multimedia.path == null && multimedia.url != null
              // !widget.isMine)
              ||
              (multimedia.path != null && multimedia.url == null))
          ? PressableCircularContianerWidget(
              childPadding: EdgeInsets.all(4),
              onPress: _controller.toggleDownload,
              child: DownloadUploadIconWidget(
                isMine: isMine,
              ),
            )
          : PressableCircularContianerWidget(
              childPadding: EdgeInsets.all(4),
              onPress: () => audioController.onPressedPlayButton(
                multimedia.localId,
                multimedia.path!,
              ),
              child: (audioController.isRecordPlaying &&
                      audioController.currentId == multimedia.localId)
                  ? Icon(
                      Icons.pause,
                      color: isMine ? Colors.white : ChatStyle.ownMessageColor,
                      size: 25,
                    )
                  : Icon(
                      Icons.play_arrow,
                      color: isMine ? Colors.white : ChatStyle.ownMessageColor,
                      size: 30,
                    ),
            ),
    );
  }
}

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
