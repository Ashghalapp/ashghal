import 'dart:io';

import 'package:ashghal_app_frontend/config/app_images.dart';
import 'package:ashghal_app_frontend/core/services/directory_path.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/upload_download_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/message_text_status_icon.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/video_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:open_file/open_file.dart';

// class ImageMessageWidget extends StatelessWidget {
//   final MessageAndMultimediaModel message;
//   final bool isMine;
//   const ImageMessageWidget({
//     super.key,
//     required this.message,
//     required this.isMine,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // print(
//     //     "created--------------------------------****************----------------------------");
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//       child:
//       Container(
//         constraints: BoxConstraints(
//             // maxWidth: MediaQuery.sizeOf(context).width / 1.7,
//             // minWidth: MediaQuery.sizeOf(context).width / 2,
//             // maxHeight: MediaQuery.sizeOf(context).height / 2.5,
//             // minHeight: MediaQuery.sizeOf(context).height / 3,
//             ),
//         // width: 200,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: isMine
//               ? ChatStyle.ownMessageColor
//               : ChatStyle.ownMessageColor.withOpacity(0.3),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             //     InkWell(
//             //       onTap: () {
//             //         /// TODO: Show image in full screen
//             //       },
//             //       child:
//             message.multimedia != null
//                 ?
//                 // Text("Image")
//                 ImageMessage(
//                     multimedia: message.multimedia!,
//                     isMine: isMine,
//                   )
//                 : Text("Null"),

//             //     ),

//             // MessageTextAndStatusIcon(
//             //   message: message.message,
//             //   isMine: isMine,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ImageMessage extends StatelessWidget {
  final LocalMultimedia multimedia;
  final bool isMine;
  final UploadDownloadController _controller;

  ImageMessage({
    super.key,
    required this.multimedia,
    required this.isMine,
  }) : _controller = Get.put(
          UploadDownloadController(multimedia: multimedia, isMine: isMine),
          tag: multimedia.localId.toString(),
        );

  // final UploadDownloadController _controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: 170,
      child: Obx(
        () => Stack(
          // clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            //others undownloaded messages, or others downloaded messages but doeosn't exists in the specified path
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
            child: DownloadinUploadingCicrularWidget(controller: _controller),
          )
        : DownloadUploadIconWithSizeWidget(
            isMine: isMine, controller: _controller, size: multimedia.size);
  }
}

// class ImageMessage extends StatefulWidget {
//   final LocalMultimedia multimedia;
//   final bool isMine;

//   const ImageMessage({
//     super.key,
//     required this.multimedia,
//     required this.isMine,
//   });
//   // : _controller = Get.put(
//   //         UploadDownloadController(multimedia: multimedia, isMine: isMine),
//   //         tag: multimedia.localId.toString(),
//   //       );

//   // final UploadDownloadController _controller;

//   @override
//   State<ImageMessage> createState() => _ImageMessageState();
// }

// class _ImageMessageState extends State<ImageMessage> {
//   bool dowloading = false;

//   bool fileExists = false;

//   double progress = 0.0;

//   late final String fileName;

//   String? filePath;

//   String? fileUrl;

//   late CancelToken cancelToken;

//   var getPathFile = DirectoryPath();

//   final MultimediaController _controller = Get.find();

//   @override
//   void initState() {
//     print("-----------------------------Created----------------------------");
//     fileName = widget.multimedia.fileName;
//     if (widget.multimedia.path != null) {
//       // setState(() {
//       //   filePath = widget.multimedia.path;
//       // });
//       print(filePath);
//       checkFileExists();
//     }
//     if (widget.multimedia.url != null) {
//       fileUrl = widget.multimedia.url;
//     }
//     super.initState();
//   }

//   Future<void> checkFileExists() async {
//     // if (filePath != null) {
//     //   bool exists = await File(filePath!).exists();
//     //   setState(() {
//     //     fileExists = exists;
//     //   });
//     // } else {
//     //   setState(() {
//     //     fileExists = false;
//     //   });
//     //   print(fileExists);
//     // }
//     if (widget.multimedia.path != null) {
//       bool exists = await File(widget.multimedia.path!).exists();
//       setState(() {
//         fileExists = exists;
//       });
//     } else {
//       setState(() {
//         fileExists = false;
//       });
//       print(fileExists);
//     }
//   }

//   startDownload() async {
//     cancelToken = CancelToken();
//     dowloading = true;
//     progress = 0;
//     try {
//       await _controller.downloadFile(
//         fileUrl: fileUrl!,
//         fileName: fileName,
//         fileType: widget.multimedia.type,
//         multimediaLocalId: widget.multimedia.localId,
//         cancelToken: cancelToken,
//         onReceiveProgress: (count, total) {
//           setState(() {
//             progress = (count / total);
//           });
//         },
//       );
//       setState(() {
//         dowloading = false;
//         fileExists = true;
//         // filePath = widget.multimedia.path;
//       });
//     } catch (e) {
//       setState(() {
//         dowloading = false;
//       });
//     }
//   }

//   startUploading() async {
//     cancelToken = CancelToken();
//     dowloading = true;
//     progress = 0;
//     try {
//       bool uploaded = await _controller.uploadFile(
//         filePath: widget.multimedia.path!,
//         fileType: widget.multimedia.type,
//         messageLocalId: widget.multimedia.messageId,
//         cancelToken: cancelToken,
//         onSendProgress: (count, total) {
//           setState(() {
//             progress = (count / total);
//           });
//         },
//       );
//       setState(() {
//         dowloading = false;
//         fileExists = true;
//       });
//     } catch (e) {
//       setState(() {
//         dowloading = false;
//       });
//     }
//   }

//   cancelOperation() async {
//     cancelToken.cancel();
//     // setState(() {
//     // dowloading = false;
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // filePath = widget.multimedia.path;
//     return
//         // ConstrainedBox(
//         //   constraints: BoxConstraints(
//         //     maxWidth: MediaQuery.sizeOf(context).width / 1.9,
//         //     // minWidth: MediaQuery.sizeOf(context).width / 2,
//         //     maxHeight: MediaQuery.sizeOf(context).height / 2.8,
//         //     // minHeight: MediaQuery.sizeOf(context).height / 3,
//         //   ),
//         //   // width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
//         //   child:
//         SizedBox(
//       width: double.infinity,
//       height: 170,
//       child: Stack(
//         // clipBehavior: Clip.none,
//         alignment: Alignment.center,
//         children: [
//           if (widget.multimedia.path == null ||
//               (widget.multimedia.path != null && !fileExists && !widget.isMine))
//             // Container(
//             //   height: double.infinity,
//             //   width: double.infinity,
//             //   decoration: BoxDecoration(
//             //     color: Colors.grey,
//             //     borderRadius: BorderRadius.circular(8),
//             //   ),
//             // ),
//             buildNoImageContianer(null),
//           if (widget.multimedia.path != null && !fileExists && widget.isMine)
//             buildNoImageContianer("Image does not exist"),
//           if (widget.multimedia.path != null && fileExists)
//             Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                   onError: (_, s) {},
//                   image: FileImage(File(widget.multimedia.path!)),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           // buildImageContainer(),

//           // ClipRRect(
//           //   borderRadius: BorderRadius.circular(8),
//           //   child: Image.file(
//           //     File(filePath!),
//           //     // height: 50,
//           //     // width: 70,
//           //   ),
//           //   // child: Image.file(File(
//           //   // "/storage/emulated/0/Android/data/com.example.ashghal_app_frontend/files/AshghalApp/media/images/IMG_0168 copy.jpg")),
//           //   // child: Image.file(File(
//           //   // "/data/user/0/com.example.ashghal_app_frontend/cache/2ef1fa1b-fe94-4fd5-9156-8ad740602240/IMG_20231002_005901.jpg")),
//           // ),
//           if (widget.multimedia.path == null ||
//               (widget.multimedia.url == null && widget.isMine) ||
//               (widget.multimedia.path != null && !fileExists && !widget.isMine))
//             buildDownloadContainer(),
//           // Container(
//           //   height: 25,
//           //   width: 25,
//           //   decoration: BoxDecoration(
//           //     color: ChatStyle.ownMessageColor,
//           //     shape: BoxShape.circle,
//           //   ),
//           //   child: const Icon(
//           //     Icons.play_arrow,
//           //     size: 16,
//           //     color: Colors.white,
//           //   ),
//           // )
//         ],

//         // ),
//       ),
//     );
//   }

//   IconButton buildDownloadContainer() {
//     return IconButton(
//       onPressed: () {
//         print(filePath);
//         print(widget.multimedia.path);
//         if (dowloading) {
//           cancelOperation();
//         } else if (widget.isMine) {
//           startUploading();
//         } else {
//           startDownload();
//         }
//         // checkFileExists();
//       },
//       icon: dowloading
//           ? Stack(
//               alignment: Alignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   value: progress,
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
//                   padding: const EdgeInsets.only(top: 20),
//                   child: Text(
//                     (progress * 100).toStringAsFixed(2),
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

//   Widget buildImageContainer() {
//     return FutureBuilder<File>(
//       future: File(filePath!).exists().then(
//         (exists) {
//           if (exists) {
//             // setState(() {
//             //   fileExists = true;
//             // });
//             print("exists");
//             return File(filePath!);
//           } else {
//             // setState(() {
//             //   fileExists = false;
//             // });
//             throw Exception('Image does not exist');
//           }
//         },
//       ),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           print("loading");
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           // return Container(
//           //   width: double.infinity,
//           //   height: ,
//           //   color: Colors.grey,
//           //   child: const Text("File does not exist"),
//           // );
//           // AppUtil.buildErrorDialog(snapshot.error!.toString());
//           return buildNoImageContianer('Image does not exist');
//         } else {
//           return InkWell(
//             onTap: () {
//               print("Open file");
//             },
//             child: Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                     image: FileImage(snapshot.data!), fit: BoxFit.cover),
//               ),
//             ),
//             // child: SizedBox(
//             //   width: double.infinity,
//             //   height: double.infinity,
//             //   child:
//             //       // Text("Mujahid"),
//             //       Image.file(
//             //     snapshot.data!,
//             //     fit: BoxFit.cover,
//             //     // fit: BoxFit.cover,
//             //     // width: 30,
//             //     // height: 40,
//             //   ),
//             // ),
//           );
//         }
//       },
//     );
//   }

// }

// Container(
//   // height: double.infinity,
//   // width: double.infinity,
//   decoration: BoxDecoration(
//       color: Colors.grey,
//       borderRadius: BorderRadius.circular(8),
//       image: DecorationImage(
//         image: FileImage(snapshot.data!),
//       )),
// ),
