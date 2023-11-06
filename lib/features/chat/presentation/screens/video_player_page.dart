import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/video_player_page_controller.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ignore: constant_identifier_names
const ASPECT_RATIO = 3 / 2;

class VideoPlayerPage extends StatelessWidget {
  final LocalMultimedia multimedia;

  final VideoPlayerPageController _controller;
  VideoPlayerPage({
    super.key,
    required this.multimedia,
  }) : _controller = Get.put(
          VideoPlayerPageController(
            multimedia: multimedia,
          ),
        );

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
                                    playedColor: Colors.blue,
                                    handleColor: Colors.blue,
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
            ],
          ),
        ),
      ),
    );
  }
}
