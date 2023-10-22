import 'dart:io';

import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/sending_video_view_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/multimedia/sending_image_video_button_and_caption_field.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/multimedia/video_view_top_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

// class SendingVideoViewPage extends StatefulWidget {

//   const SendingVideoViewPage({super.key, required path});

//   @override
//   State<SendingVideoViewPage> createState() => _SendingVideoViewPageState();
// }

class SendingVideoViewPage extends StatelessWidget {
  final SendingVideoViewController _controller;
  SendingVideoViewPage({super.key, required String path})
      : _controller = Get.put(SendingVideoViewController(path: path));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(
              () => _controller.isInitialized.value
                  ? Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: _controller
                              .videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_controller.videoPlayerController),
                        ),
                      ),
                    )
                  : Center(
                      child: AppUtil.addProgressIndicator(50),
                    ),
            ),
            playPauseButton(),
            const VideoViewTopRowWidget(),
            Positioned(
              bottom: 5,
              right: 0,
              left: 0,
              child: SendingImageVideoButtonAndCaptionField(
                captionController: TextEditingController(),
                // imageCount: 5,
                onSendButtonTaped: _controller.sendButtonPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Align playPauseButton() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: _controller.playPauseVideo,
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black38,
          child: Obx(
            () => Icon(
              _controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
