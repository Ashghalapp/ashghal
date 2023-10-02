import 'dart:io';

import 'package:ashghal_app_frontend/core/services/directory_path.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/download_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/upload_request.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class UploadDownloadController extends GetxController {
  RxBool dowloading = false.obs;

  RxBool fileExists = false.obs;

  RxDouble progress = 0.0.obs;

  final String fileName;

  String filePath;

  String fileUrl;

  late CancelToken cancelToken;

  var getPathFile = DirectoryPath();

  final LocalMultimedia multimedia;
  final bool isMine;

  final ConversationController _conversationController = Get.find();
  @override
  void onInit() {
    super.onInit();
    checkFileExit();
  }

  UploadDownloadController({required this.multimedia, required this.isMine})
      : fileName = multimedia.fileName,
        filePath = multimedia.path ?? "",
        fileUrl = multimedia.url ?? "";

  // @override
  // void initState() {
  //   super.initState();
  //   fileName = widget.multimedia.fileName;
  //   filePath = widget.multimedia.path ?? "";
  //   fileUrl = widget.multimedia.url ?? "";
  // }

  startDownload() async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getImagesPath();
    filePath = '$storePath/$fileName';
    // setState(() {
    dowloading.value = true;
    progress.value = 0;
    // });

    try {
      // await Dio().download(
      //   fileUrl,
      //   filePath,
      //   onReceiveProgress: (count, total) {
      //     setState(() {
      //       progress = (count / total);
      //     });
      //   },
      //   cancelToken: cancelToken,
      // );
      DownloadRequest request = DownloadRequest(
        url: fileUrl,
        savePath: filePath,
        multimediaLocalId: multimedia.localId,
        onReceiveProgress: (count, total) {
          progress.value = (count / total);
        },
        cancelToken: cancelToken,
      );
      // bool downloaded =
      await _conversationController.download(request);

      dowloading.value = false;
      fileExists.value = true;
    } catch (e) {
      dowloading.value = false;
    }
  }

  startUploading() async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getImagesPath();
    filePath = '$storePath/$fileName';
    // setState(() {
    dowloading.value = true;
    progress.value = 0;
    // });

    try {
      // await Dio().download(
      //   fileUrl,
      //   filePath,
      //   onReceiveProgress: (count, total) {
      //     setState(() {
      //       progress = (count / total);
      //     });
      //   },
      //   cancelToken: cancelToken,
      // );
      UploadRequest request = UploadRequest(
        // url: fileUrl,
        // savePath: filePath,
        messageLocalId: multimedia.messageId,
        onSendProgress: (count, total) {
          progress.value = (count / total);
        },
        cancelToken: cancelToken,
      );
      // bool downloaded =
      await _conversationController.upload(request);

      dowloading.value = false;
      fileExists.value = true;
    } catch (e) {
      dowloading.value = false;
    }
  }

  cancelDownload() {
    cancelToken.cancel();

    dowloading.value = false;
  }

  toggleDownload() {
    if (dowloading.value) {
      cancelDownload();
    } else {
      startUploading();
    }
  }

  checkFileExit() async {
    // var storePath = await getPathFile.getImagesPath();
    // if(fileName.trim()!=""){
    // filePath = '$storePath/$fileName';
    bool fileExistCheck = await File(filePath).exists();
    fileExists.value = fileExistCheck;
    // }
  }

  openfile() {
    OpenFile.open(filePath);
    print("fff $filePath");
  }
}
