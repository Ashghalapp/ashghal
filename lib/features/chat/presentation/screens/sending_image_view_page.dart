import 'dart:io';

import 'package:ashghal_app_frontend/features/chat/presentation/getx/sending_image_view_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/multimedia/image_view_top_row_icons.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/multimedia/sending_image_video_button_and_caption_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendingImageViewPage extends StatelessWidget {
  // final Function(List<String> paths,List<String> captions) sendButtonPressed;
  final SendingImageViewController _controller;

  SendingImageViewPage({super.key, required List<String> paths})
      : _controller = Get.put(SendingImageViewController(paths: paths));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              itemCount: _controller.paths.length,
              controller: PageController(
                initialPage: _controller.currentIndex.value,
              ),
              onPageChanged: _controller.changeImageIndex,
              itemBuilder: (context, index) {
                return Image.file(
                  File(_controller.paths[index]),
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),
            ImageViewTopRowIcons(onCropButtonTaped: () async {
              // TODO Implement Crop Images btn
            }),
            Positioned(
              bottom: 5,
              right: 0,
              left: 0,
              child: SendingImageVideoButtonAndCaptionField(
                captionController: _controller
                    .captionControllers[_controller.currentIndex.value],
                onSendButtonTaped: _controller.sendButtonPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
