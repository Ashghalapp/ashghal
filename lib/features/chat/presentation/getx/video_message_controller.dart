// import 'dart:io';

// import 'package:ashghal_app_frontend/core/services/directory_path.dart';
// import 'package:ashghal_app_frontend/core/services/video_controller_service.dart';
// import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
// import 'package:ashghal_app_frontend/features/chat/domain/requests/download_request.dart';
// import 'package:ashghal_app_frontend/features/chat/domain/requests/upload_request.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:get/get.dart';
// import 'package:open_file/open_file.dart';
// import 'package:video_player/video_player.dart';

// class VideoMessageController extends GetxController {
//   RxBool dowloading = false.obs;
//   RxBool isLoading = false.obs;
//   RxBool isInitialized = false.obs;
//   RxBool fileExists = false.obs;

//   RxDouble progress = 0.0.obs;
//   final MultimediaController _controller = Get.find();
//   // final String fileName;

//   // RxString filePath = "".obs;

//   // RxString fileUrl = "".obs;

//   late CancelToken cancelToken;

//   late VideoPlayerController videoPlayerController;

//   var getPathFile = DirectoryPath();
//   final CachedVideoControllerService _videoControllerService =
//       CachedVideoControllerService(DefaultCacheManager());

//   final LocalMultimedia multimedia;
//   final bool isMine;

//   VideoMessageController({required this.multimedia, required this.isMine});

//   @override
//   void onInit() {
//     super.onInit();
//     if (multimedia.path != null) {
//       checkFileExit().then((value) => playVideo());
//     }
//   }

//   Future<void> playVideo() async {
//     isLoading.value = true;
//     if (multimedia.path != null && fileExists.value) {
//       print("File Video");
//       videoPlayerController =
//           VideoPlayerController.file(File(multimedia.path!));
//     } else if (!isMine && multimedia.url != null) {
//       print("Url Video");
//       videoPlayerController =
//           await _videoControllerService.getControllerForVideo(multimedia.url!);
//     }
//     print("before initializing");
//     await videoPlayerController.initialize().then((_) {
//       if (videoPlayerController.value.hasError) {
//         print(
//             "****************************************************////////////////////****************");
//         print('Error: ${videoPlayerController.value.errorDescription}');
//       }
//     }, onError: (error) {
//       print(
//           "****************************************************////////////////////****************");
//       print('Error: ${videoPlayerController.value.errorDescription}');
//       print('Error: ${error.toString()}');
//     });
//     // await videoPlayerController.initialize();
//     isLoading.value = false;
//     isInitialized.value = true;
//     videoPlayerController.pause();
//   }

//   startDownload() async {
//     cancelToken = CancelToken();
//     dowloading.value = true;
//     progress.value = 0;
//     try {
//       print("Download Started");
//       print("multimediaLocalId ${multimedia.localId}");
//       bool downloaded = await _controller.downloadFile(
//         fileUrl: multimedia.url!,
//         fileName: multimedia.fileName,
//         fileType: multimedia.type,
//         multimediaLocalId: multimedia.localId,
//         cancelToken: cancelToken,
//         onReceiveProgress: (count, total) {
//           progress.value = (count / total);
//         },
//       );

//       dowloading.value = false;
//       // checkFileExit();
//       fileExists.value = downloaded;
//       print(multimedia);
//     } catch (e) {
//       dowloading.value = false;
//     }
//   }

//   startUploading() async {
//     cancelToken = CancelToken();
//     dowloading.value = true;
//     progress.value = 0;
//     try {
//       bool uploaded = await _controller.uploadFile(
//         filePath: multimedia.path!,
//         fileType: multimedia.type,
//         messageLocalId: multimedia.messageId,
//         cancelToken: cancelToken,
//         onSendProgress: (count, total) {
//           progress.value = (count / total);
//         },
//       );
//       dowloading.value = false;
//       fileExists.value = true;
//     } catch (e) {
//       dowloading.value = false;
//     }
//   }

//   cancelDownload() {
//     cancelToken.cancel();
//     dowloading.value = false;
//   }

//   toggleDownload() {
//     if (dowloading.value) {
//       cancelDownload();
//     } else if (isMine) {
//       startUploading();
//     } else {
//       startDownload();
//     }
//   }

//   Future<void> checkFileExit() async {
//     print("checkFileExit ${multimedia.path}");
//     if (multimedia.path != null) {
//       bool fileExistCheck = await File(multimedia.path!).exists();
//       // print(fileExistCheck.toString());
//       fileExists.value = fileExistCheck;
//     } else {
//       fileExists.value = false;
//     }
//     print(fileExists.value);
//   }

//   openfile() {
//     if (multimedia.path != null) {
//       OpenFile.open(multimedia.path);
//     }
//   }

//   @override
//   void onClose() {
//     videoPlayerController.dispose();
//     super.onClose();
//   }
// }

import 'dart:io';
import 'dart:typed_data';

import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/video_player_page.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoMessageController extends GetxController {
  RxBool thumbnailReady = false.obs;

  // late VideoPlayerController videoPlayerController;

  final LocalMultimedia multimedia;
  final bool isMine;

  VideoMessageController({required this.multimedia, required this.isMine});

  @override
  void onInit() {
    super.onInit();
    // print("a----------------------------------------------");
    // playVideo();
    if (multimedia.path != null) {
      File(multimedia.path!).exists().then((value) {
        if (value) {
          thumbnailFromFile();
        }
      });
    } else if (multimedia.url != null) {
      thumbnailFromUrl();
    }
  }

  Future<void> thumbnailFromFile() async {
    print("Thumnail file starteded");
    try {
      memoryThumbnail = await VideoThumbnail.thumbnailData(
        video: multimedia.path!,
        imageFormat: ImageFormat.JPEG,
        // maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        // quality: 25,
      );
      print("Thumnail file created");
      thumbnailReady.value = true;
    } catch (e) {
      thumbnailReady.value = false;
    }
  }

  Future<void> thumbnailFromUrl() async {
    print("Thumnail url starteded");
    try {
      urlThumbnail = await VideoThumbnail.thumbnailFile(
        video: multimedia.url!,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP,
        // maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        // quality: 75,
      );
      AppPrint.printSuccess("Thumnail Url created");
      thumbnailReady.value = true;
    } catch (e) {
      thumbnailReady.value = false;
      AppPrint.printError("Error getting thumbnail from url: ${e.toString()}");
    }
  }

  Uint8List? memoryThumbnail;
  String? urlThumbnail;
  playVideo() {
    Get.to(
      () => VideoPlayerPage(
        multimedia: multimedia,
        isMine: isMine,
      ),
    );
  }

  @override
  void onClose() {
    // videoPlayerController.dispose();
    super.onClose();
  }
}
