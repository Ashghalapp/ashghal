import 'dart:io';

import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/upload_download_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/video_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoMessageWidget extends StatelessWidget {
  final LocalMultimedia multimedia;
  final bool isMine;
  final VideoMessageController _videoMessageController;
  final UploadDownloadController _uploadDownloadController;

  VideoMessageWidget({
    super.key,
    required this.multimedia,
    required this.isMine,
  })  : _uploadDownloadController = Get.put(
          UploadDownloadController(multimedia: multimedia, isMine: isMine),
          tag: multimedia.localId.toString(),
        ),
        _videoMessageController = Get.put(
          VideoMessageController(multimedia: multimedia, isMine: isMine),
          tag: multimedia.localId.toString(),
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: [
            //if the file is mine, and the file exists value is false, and the path exists
            if (multimedia.path != null &&
                !_uploadDownloadController.fileExists.value &&
                isMine)
              _uploadDownloadController.isCheckingFileExistance.value
                  ? const ImageVideoPlaceHolderWidget(
                      loadingPlaceHolder: true,
                    )
                  : const ImageVideoDeletedPlaceHolderWidget(
                      message: "Video deleted from your local device",
                    ),

            if ((multimedia.path != null &&
                    _uploadDownloadController.fileExists.value) ||
                (multimedia.url != null))
              buildVideoContianer(),
            if (multimedia.path == null ||
                (multimedia.url == null && isMine) ||
                (multimedia.path != null &&
                    !_uploadDownloadController.fileExists.value &&
                    !isMine))
              Positioned(
                bottom: 2,
                left: 2,
                child: buildDownloadContainer(),
              ),
            PressableCircularContianerWidget(
              childPadding: const EdgeInsets.all(5),
              onPress: _videoMessageController.playVideo,
              child: const Icon(
                Icons.play_arrow_sharp,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],

          // ),
        ),
      ),
    );
  }

  Widget buildVideoContianer() {
    return !_videoMessageController.thumbnailReady.value
        ? const ImageVideoPlaceHolderWidget()
        : Opacity(
            opacity: isMine ||
                    (multimedia.path != null &&
                        _uploadDownloadController.fileExists.value)
                ? 1
                : 0.5,
            child: InkWell(
              onTap: _videoMessageController.playVideo,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: _videoMessageController.memoryThumbnail != null
                    ? Image.memory(
                        _videoMessageController.memoryThumbnail!,
                        fit: BoxFit.contain,
                      )
                    : _videoMessageController.urlThumbnail != null
                        ? Image.file(
                            File(_videoMessageController.urlThumbnail!),
                            fit: BoxFit.contain,
                          )
                        : const ImageVideoPlaceHolderWidget(),
              ),
            ),
          );
  }

  Widget buildDownloadContainer() {
    return _uploadDownloadController.dowloading.value
        ? PressableCircularContianerWidget(
            onPress: _uploadDownloadController.cancelDownload,
            childPadding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DownloadinUploadingCicrularWidget(
                  onCancel: _uploadDownloadController.cancelDownload,
                ),
                const SizedBox(width: 5),
                Text(
                  "${(_uploadDownloadController.progress.value * 100).toStringAsFixed(2)}%",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          )
        : DownloadUploadIconWithSizeWidget(
            isMine: isMine,
            controller: _uploadDownloadController,
            size: multimedia.size,
          );
  }
}

class ReadyVideoMessageWidget extends StatelessWidget {
  final LocalMultimedia multimedia;
  final bool isMine;
  final VideoMessageController _videoMessageController;

  ReadyVideoMessageWidget({
    super.key,
    required this.multimedia,
    required this.isMine,
  }) : _videoMessageController = Get.put(
          VideoMessageController(multimedia: multimedia, isMine: isMine),
          tag: multimedia.localId.toString(),
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          multimedia.path == null
              ? const ImageVideoDeletedPlaceHolderWidget(
                  message: "Video deleted from your local device",
                )
              : FutureBuilder<bool>(
                  future: File(multimedia.path!).exists(),
                  builder: (_, snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return const ImageVideoPlaceHolderWidget(
                        loadingPlaceHolder: true,
                      );
                    } else {
                      if (snapShot.connectionState == ConnectionState.done &&
                          snapShot.hasData &&
                          snapShot.data != null &&
                          snapShot.data!) {
                        return buildVideoContianer();
                      } else {
                        return const ImageVideoDeletedPlaceHolderWidget(
                          message: "Video deleted from your local device",
                        );
                      }
                    }
                  },
                ),
          //if the file is mine, and the file exists value is false, and the path exists

          PlayVideoIconWidget(onPlayVideo: _videoMessageController.playVideo),
        ],

        // ),
      ),
    );
  }

  Widget buildVideoContianer() {
    return Obx(
      () => !_videoMessageController.thumbnailReady.value
          ? const ImageVideoPlaceHolderWidget()
          : InkWell(
              onTap: _videoMessageController.playVideo,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: _videoMessageController.memoryThumbnail != null
                    ? Image.memory(
                        _videoMessageController.memoryThumbnail!,
                        fit: BoxFit.contain,
                      )
                    : _videoMessageController.urlThumbnail != null
                        ? Image.file(
                            File(_videoMessageController.urlThumbnail!),
                            fit: BoxFit.contain,
                          )
                        : const ImageVideoPlaceHolderWidget(),
              ),
            ),
    );
  }
}
