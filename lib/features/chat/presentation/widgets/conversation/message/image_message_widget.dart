import 'dart:io';

import 'package:ashghal_app_frontend/core/services/directory_path.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/upload_download_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/message_text_status_icon.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:open_file/open_file.dart';

class ImageMessageWidget extends StatelessWidget {
  final MessageAndMultimediaModel message;
  final bool isMine;
  ImageMessageWidget({
    super.key,
    required this.message,
    required this.isMine,
  }) : _controller = Get.put(
            UploadDownloadController(
                multimedia: message.multimedia!, isMine: isMine),
            tag: message.multimedia!.localId.toString());

  final UploadDownloadController _controller;

  @override
  Widget build(BuildContext context) {
    print(
        "created--------------------------------****************----------------------------");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width / 1.7,
          // minWidth: MediaQuery.sizeOf(context).width / 2,
          maxHeight: MediaQuery.sizeOf(context).height / 2.5,
          // minHeight: MediaQuery.sizeOf(context).height / 3,
        ),
        // width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isMine
              ? ChatStyle.ownMessageColor
              : ChatStyle.ownMessageColor.withOpacity(0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                /// TODO: Show image in full screen
              },
              child: ImageMessage(
                multimedia: message.multimedia!,
                isMine: isMine,
              ),
            ),
            // MessageTextAndStatusIcon(
            //   message: message.message,
            //   isMine: isMine,
            // ),
          ],
        ),
      ),
    );
  }
}

class ImageMessage extends StatelessWidget {
  final LocalMultimedia multimedia;
  final bool isMine;

  ImageMessage({
    super.key,
    required this.multimedia,
    required this.isMine,
  }) {
    print(
        "created--------------------------------****************----------------------------");
    print(
        "created--------------------------------${multimedia.path}----------------------------");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints(
      //   maxWidth: MediaQuery.sizeOf(context).width / 1.9,
      //   // minWidth: MediaQuery.sizeOf(context).width / 2,
      //   maxHeight: MediaQuery.sizeOf(context).height / 2.8,
      //   // minHeight: MediaQuery.sizeOf(context).height / 3,
      // ),
      width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
        child: GetX<UploadDownloadController>(
          builder: (controller) {
            return Stack(
              alignment: Alignment.center,
              children: [
                if (!controller.fileExists.value)
                  Container(
                    height: 250,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                if (controller.fileExists.value)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(controller.filePath)),
                    // child: Image.file(File(
                    // "/data/user/0/com.example.ashghal_app_frontend/cache/2ef1fa1b-fe94-4fd5-9156-8ad740602240/IMG_20231002_005901.jpg")),
                  ),
                if (!controller.fileExists.value)
                  IconButton(
                    onPressed: controller.toggleDownload,
                    icon: controller.dowloading.value
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: controller.progress.value,
                                strokeWidth: 3,
                                backgroundColor: Colors.grey,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              ),
                              Text(
                                (controller.progress.value * 100)
                                    .toStringAsFixed(2),
                                style: const TextStyle(fontSize: 12),
                              )
                            ],
                          )
                        : const Icon(Icons.download),
                  ),
                // Container(
                //   height: 25,
                //   width: 25,
                //   decoration: BoxDecoration(
                //     color: ChatStyle.ownMessageColor,
                //     shape: BoxShape.circle,
                //   ),
                //   child: const Icon(
                //     Icons.play_arrow,
                //     size: 16,
                //     color: Colors.white,
                //   ),
                // )
              ],
            );
          },
        ),
      ),
    );
  }
}
