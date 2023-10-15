import 'dart:io';

import 'package:ashghal_app_frontend/config/app_images.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/upload_download_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/video_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/sending_video_view_page.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/video_player_page.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:video_player/video_player.dart';

const ASPECT_RATIO = 3 / 2;

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
    // print(
    // "*******************************************************************");
    return SizedBox(
      width: double.infinity,
      // height: 170,
      child: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: [
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
              onPress: _videoMessageController.playVideo,
              child: const Icon(
                Icons.play_arrow_outlined,
                color: Colors.white,
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
        // ? const Center(
        //     child: CircularProgressIndicator(),
        //   )
        : Opacity(
            opacity: isMine ? 1 : 0.5,
            child: InkWell(
              onTap: _videoMessageController.playVideo,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: _videoMessageController.memoryThumbnail != null
                    ? Image.memory(
                        _videoMessageController.memoryThumbnail!,
                        // width: double.infinity,
                        // height: double.infinity,
                        fit: BoxFit.contain,
                      )
                    : _videoMessageController.urlThumbnail != null
                        ? Image.file(
                            File(_videoMessageController.urlThumbnail!),
                            // width: double.infinity,
                            // height: double.infinity,
                            fit: BoxFit.contain,
                          )
                        : const ImageVideoPlaceHolderWidget(),
              ),
            ),
          );
  }

  Widget buildDownloadContainer() {
    return
        //  IconButton(
        // onPressed: _uploadDownloadController.toggleDownload,
        // icon:
        _uploadDownloadController.dowloading.value
            ? PressableCircularContianerWidget(
                onPress: _uploadDownloadController.cancelDownload,
                childPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DownloadinUploadingCicrularWidget(
                        controller: _uploadDownloadController),
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Transform.scale(
//                         scale: 0.7,
//                         child: CircularProgressIndicator(
//                           // strokeWidth: ,
//                           // value: _uploadDownloadController.progress.value,
// // backgroundColor: ChatStyle.iconsBackColor,
//                           // backgroundColor: ChatStyle.iconsBackColor,
//                           backgroundColor: Colors.blueGrey,
//                           // color: Colors.blue,
//                           // color: Color.,
//                           // valueColor: const AlwaysStoppedAnimation<Color>(
//                           //   Colors.blue,
//                           // ),
//                         ),
//                       ),
//                       // CircularProgressIndicator(
//                       //   value: _uploadDownloadController.progress.value,
//                       //   strokeWidth: 1,
//                       //   backgroundColor: ChatStyle.iconsBackColor,
//                       //   valueColor: const AlwaysStoppedAnimation<Color>(
//                       //     Colors.blue,
//                       //   ),
//                       // ),

//                       const Icon(
//                         Icons.cancel,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                     ],
//                   ),

                    const SizedBox(width: 5),
                    Text(
                      "${(_uploadDownloadController.progress.value * 100).toStringAsFixed(2)}%",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ))
            : DownloadUploadIconWithSizeWidget(
                isMine: isMine,
                controller: _uploadDownloadController,
                size: multimedia.size);
    // );
  }

  // Widget buildNoVideoContianer(String? message) {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(5),
  //     child: Image.asset(
  //       AppImages.imagePlaceholder,
  //       fit: BoxFit.contain,
  //     ),
  //   );

  // Container(
  //   height: double.infinity,
  //   width: double.infinity,
  //   decoration: BoxDecoration(
  //     color: Colors.grey,
  //     borderRadius: BorderRadius.circular(8),
  //   ),
  //   child: message != null ? Center(child: Text(message)) : null,
  // );
  // }
}

// class ImagePlaceholderWidget extends StatelessWidget {
//   const ImagePlaceholderWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Image.asset(
//       AppImages.imagePlaceholder,
//       fit: BoxFit.contain,
//     );
//   }
// }




// class VideoMessageWidget extends StatelessWidget {
//   final LocalMultimedia multimedia;
//   final bool isMine;
//   final VideoMessageController _controller;

//   VideoMessageWidget({
//     super.key,
//     required this.multimedia,
//     required this.isMine,
//   }) : _controller = Get.put(
//           VideoMessageController(multimedia: multimedia, isMine: isMine),
//           tag: multimedia.localId.toString(),
//         );

//   // final UploadDownloadController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 170,
//       child: Obx(
//         () => Stack(
//           alignment: Alignment.center,
//           children: [
//             if (multimedia.path == null ||
//                 (multimedia.path != null &&
//                     !_controller.fileExists.value &&
//                     !isMine))
//               buildNoImageContianer(null),
//             if (multimedia.path != null &&
//                 !_controller.fileExists.value &&
//                 isMine)
//               buildNoImageContianer("Video does not exist"),
//             if ((multimedia.path != null && _controller.fileExists.value) ||
//                 (multimedia.url != null && _controller.isInitialized.value))
//               buildVideoContianer(),
//             if (multimedia.path == null ||
//                 (multimedia.url == null && isMine) ||
//                 (multimedia.path != null &&
//                     !_controller.fileExists.value &&
//                     !isMine))
//               Positioned(top: 2, left: 2, child: buildDownloadContainer()),
//             if (!_controller.isInitialized.value)
//               _controller.isLoading.value
//                   ? CircularProgressIndicator()
//                   : CircleAvatar(
//                       child: IconButton(
//                         onPressed: _controller.playVideo,
//                         icon: Icon(Icons.play_arrow_outlined),
//                       ),
//                     )
//           ],

//           // ),
//         ),
//       ),
//     );
//   }

//   Container buildVideoContianer() {
//     return Container(
//       height: double.infinity,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.grey,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: _controller.isLoading.value
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : Chewie(
//               controller: ChewieController(
//                 videoPlayerController: _controller.videoPlayerController,
//                 aspectRatio: ASPECT_RATIO,
//                 autoInitialize: false,
//                 autoPlay: false,
//                 deviceOrientationsAfterFullScreen: [
//                   DeviceOrientation.portraitUp
//                 ],
//                 materialProgressColors: ChewieProgressColors(
//                   playedColor: Colors.purple,
//                   handleColor: Colors.purple,
//                   backgroundColor: Colors.grey,
//                   bufferedColor: Colors.purple.shade100,
//                 ),
//                 placeholder: Container(
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//     );
//   }

//   IconButton buildDownloadContainer() {
//     return IconButton(
//       onPressed: _controller.toggleDownload,
//       icon: _controller.dowloading.value
//           ? Stack(
//               alignment: Alignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   value: _controller.progress.value,
//                   strokeWidth: 3,
//                   backgroundColor: Colors.grey,
//                   valueColor: const AlwaysStoppedAnimation<Color>(
//                     Colors.blue,
//                   ),
//                 ),
//                 const Icon(
//                   Icons.cancel_outlined,
//                   color: Colors.black,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 40),
//                   child: Text(
//                     (_controller.progress.value * 100).toStringAsFixed(2),
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ),
//               ],
//             )
//           : const CircleAvatar(
//               child: Icon(
//                 Icons.download,
//                 color: Colors.black,
//               ),
//             ),
//     );
//   }

//   Container buildNoImageContianer(String? message) {
//     return Container(
//       height: double.infinity,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.grey,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: message != null ? Center(child: Text(message)) : null,
//     );
//   }
// }