import 'package:ashghal_app_frontend/config/app_images.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/upload_download_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class FileMessageWidget extends StatelessWidget {
  final LocalMultimedia multimedia;
  final bool isMine;
  final UploadDownloadController _controller;
  FileMessageWidget({
    super.key,
    required this.multimedia,
    required this.isMine,
  }) : _controller = Get.put(
          UploadDownloadController(multimedia: multimedia, isMine: isMine),
          tag: multimedia.localId.toString(),
        );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (multimedia.path != null) {
          _controller.openfile();
        }
      },
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(5),
                  image: const DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                      AppImages.documentPlaceholder,
                    ),
                  ),
                ),
              ),
              //others undownloaded messages, or others downloaded messages but doeosn't exists in the specified path
              if (multimedia.path == null ||
                  (multimedia.path != null &&
                      !_controller.fileExists.value &&
                      !isMine))
                Obx(
                  () => _controller.dowloading.value
                      ? PressableCircularContianerWidget(
                          childPadding: const EdgeInsets.all(3),
                          onPress: _controller.cancelDownload,
                          child: DownloadinUploadingCicrularWidget(
                            onCancel: _controller.cancelDownload,
                            scaleCircular: 0.9,
                            iconSize: 18,
                          ),
                        )
                      : PressableCircularContianerWidget(
                          onPress: _controller.toggleDownload,
                          child: DownloadUploadIconWidget(
                            isMine: isMine,
                          ),
                        ),
                ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          multimedia.fileName,
                          softWrap: true,
                          // textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isMine
                                ? ChatStyle.ownMessageTextColor
                                : Get.isPlatformDarkMode
                                    ? ChatStyle.otherMessageTextDarkColor
                                    : ChatStyle.otherMessageTextLightColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      MultimediaSizeTextWidget(
                        size: multimedia.size,
                        isMine: isMine,
                      ),
                      const SizedBox(width: 5),
                      MultimediaExtentionTextWidget(
                        path: multimedia.path ?? multimedia.url ?? " . ",
                        isMine: isMine,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReadyFileMessageWidget extends StatelessWidget {
  final LocalMultimedia multimedia;
  final bool? isMine;
  final double leftBorderRaduis;
  openfile() {
    if (multimedia.path != null) {
      try {
        OpenFile.open(multimedia.path);
      } catch (e) {
        AppUtil.hanldeAndShowFailure(NotSpecificFailure(
            message: "Unable to open this file ${e.toString()}"));
      }
    } else {
      AppUtil.buildErrorDialog("File is deleted from local device");
    }
  }

  const ReadyFileMessageWidget({
    super.key,
    required this.multimedia,
    this.isMine,
    this.leftBorderRaduis = 5,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await openfile();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(leftBorderRaduis),
                      bottomLeft: Radius.circular(leftBorderRaduis)),
                  image: const DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                      AppImages.documentPlaceholder,
                    ),
                  ),
                ),
              ),
              //others undownloaded messages, or others downloaded messages but doeosn't exists in the specified path
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        multimedia.fileName,
                        softWrap: true,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isMine != null && isMine!
                              ? ChatStyle.ownMessageTextColor
                              : Get.isPlatformDarkMode
                                  ? ChatStyle.otherMessageTextDarkColor
                                  : ChatStyle.otherMessageTextLightColor,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      MultimediaSizeTextWidget(
                        size: multimedia.size,
                        isMine: isMine,
                      ),
                      const SizedBox(width: 5),
                      MultimediaExtentionTextWidget(
                        path: multimedia.path ?? multimedia.url ?? " . ",
                        isMine: isMine,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
