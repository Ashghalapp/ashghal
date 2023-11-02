import 'dart:io';

import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/upload_download_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageMessageWidget extends StatelessWidget {
  final LocalMultimedia multimedia;
  final bool isMine;
  final UploadDownloadController _controller;

  ImageMessageWidget({
    super.key,
    required this.multimedia,
    required this.isMine,
  }) : _controller = Get.put(
          UploadDownloadController(multimedia: multimedia, isMine: isMine),
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
            //others undownloaded messages, or others downloaded messages but doeosn't
            //exists in the specified path
            if (multimedia.path == null ||
                (multimedia.path != null &&
                    !_controller.fileExists.value &&
                    !isMine))
              const ImageVideoPlaceHolderWidget(),

            //my messages that doesn't exists in the specified path
            if (multimedia.path != null &&
                !_controller.fileExists.value &&
                isMine)
              _controller.isCheckingFileExistance.value
                  ? const ImageVideoPlaceHolderWidget(
                      loadingPlaceHolder: true,
                    )
                  : const ImageVideoDeletedPlaceHolderWidget(
                      message: "Image deleted from your local device",
                    ),
            if (multimedia.path != null && _controller.fileExists.value)
              InkWell(
                onTap: _controller.openfile,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.file(
                    File(multimedia.path!),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            //others unDownloaded messages, or my unsent messages,
            //or others downloaded messages but doeosn't exists in the specified path
            if (multimedia.path == null ||
                (multimedia.url == null && isMine) ||
                (multimedia.path != null &&
                    !_controller.fileExists.value &&
                    !isMine))
              buildDownloadContainer(),
          ],

          // ),
        ),
      ),
    );
  }

  Widget buildDownloadContainer() {
    return _controller.dowloading.value
        ? PressableCircularContianerWidget(
            childPadding: const EdgeInsets.all(5),
            onPress: _controller.cancelDownload,
            child: DownloadinUploadingCicrularWidget(
              onCancel: _controller.cancelDownload,
              scaleCircular: 1,
              iconSize: 18,
            ),
          )
        : DownloadUploadIconWithSizeWidget(
            isMine: isMine,
            controller: _controller,
            size: multimedia.size,
          );
  }
}

class ReadyImageMessageWidget extends StatelessWidget {
  final LocalMultimedia multimedia;
  final bool isMine;

  const ReadyImageMessageWidget({
    super.key,
    required this.multimedia,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          multimedia.path == null
              ? const ImageVideoDeletedPlaceHolderWidget(
                  message: "Image deleted from your local device",
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
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.file(
                            File(multimedia.path!),
                            fit: BoxFit.contain,
                          ),
                        );
                      } else {
                        return const ImageVideoDeletedPlaceHolderWidget(
                          message: "Image deleted from your local device",
                        );
                      }
                    }
                  },
                ),
        ],
      ),
    );
  }
}
