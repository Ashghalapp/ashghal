import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/sending_video_view_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/video_player_page_controller.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

const ASPECT_RATIO = 3 / 2;

class VideoPlayerPage extends StatelessWidget {
  final LocalMultimedia multimedia;
  final bool isMine;
  final VideoPlayerPageController _controller;
  VideoPlayerPage({
    super.key,
    required this.multimedia,
    required this.isMine,
  }) : _controller = Get.put(VideoPlayerPageController(
          multimedia: multimedia,
          isMine: isMine,
        ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(
          () => Stack(
            alignment: Alignment.center,
            children: [
              _controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8),
                        child: Visibility(
                          visible: _controller
                              .videoPlayerController.value.isInitialized,
                          child: SizedBox(
                            width: double.infinity,
                            child: AspectRatio(
                              aspectRatio: _controller
                                  .videoPlayerController.value.aspectRatio,
                              // child: VideoPlayer(_controller.videoPlayerController),
                              child: Chewie(
                                controller: ChewieController(
                                  videoPlayerController:
                                      _controller.videoPlayerController,
                                  aspectRatio: ASPECT_RATIO,
                                  autoInitialize: false,
                                  autoPlay: true,
                                  deviceOrientationsAfterFullScreen: [
                                    DeviceOrientation.portraitUp
                                  ],
                                  materialProgressColors: ChewieProgressColors(
                                    playedColor: Colors.purple,
                                    handleColor: Colors.purple,
                                    backgroundColor: Colors.grey,
                                    bufferedColor: Colors.purple.shade100,
                                  ),
                                  placeholder: Container(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              // playPauseButton(),
              // const VideoViewTopRowWidget(),
              // Positioned(
              //   bottom: 5,
              //   right: 0,
              //   left: 0,
              //   child: SendingImageVideoButtonAndCaptionField(
              //     captionController: TextEditingController(),
              //     // imageCount: 5,
              //     onSendButtonTaped: _controller.sendButtonPressed,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Align playPauseButton() {
  //   return Align(
  //     alignment: Alignment.center,
  //     child: InkWell(
  //       onTap: _controller.playPauseVideo,
  //       child: CircleAvatar(
  //         radius: 30,
  //         backgroundColor: Colors.black38,
  //         child: Icon(
  //           _controller.videoPlayerController.value.isPlaying
  //               ? Icons.pause
  //               : Icons.play_arrow,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
