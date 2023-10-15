import 'package:ashghal_app_frontend/config/app_images.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/upload_download_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 90,
                width: 90,
                // padding: EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(5),
                  image: const DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                      AppImages.documentPlaceholder,
                    ),
                  ),
                  // borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(5),
                  //     bottomLeft: Radius.circular(5)),
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
                          onPress: _controller.cancelDownload,
                          child: DownloadinUploadingCicrularWidget(
                            controller: _controller,
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    multimedia.fileName,
                    softWrap: true,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      MultimediaSizeTextWidget(
                        size: multimedia.size,
                      ),
                      const SizedBox(width: 5),
                      MultimediaExtentionTextWidget(
                        path: multimedia.path ?? multimedia.url ?? " . ",
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          // const Icon(
          //   Icons.insert_drive_file,
          //   size: 24.0,
          //   color: Colors.white, // Replace with your desired icon color
          // ),
          // const SizedBox(width: 8.0),
          // Text(
          //   multimedia.fileName,
          //   style: const TextStyle(
          //     color: Colors.white, // Replace with your desired text color
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ],
      ),
    );
  }
}
