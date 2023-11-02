import 'dart:io';

import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/services/directory_path.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class UploadDownloadController extends GetxController {
  RxBool dowloading = false.obs;

  RxBool fileExists = false.obs;

  RxBool isCheckingFileExistance = true.obs;

  RxDouble progress = 0.0.obs;
  final MultimediaController _controller = Get.find();
  // final String fileName;

  // RxString filePath = "".obs;

  // RxString fileUrl = "".obs;

  late CancelToken cancelToken;

  var getPathFile = DirectoryPath();

  final LocalMultimedia multimedia;
  final bool isMine;
  UploadDownloadController({required this.multimedia, required this.isMine});

  @override
  void onInit() {
    super.onInit();
    checkFileExit();
    Future.delayed(const Duration(seconds: 1), () {
      _checkMultimediaUploadDownloadState();
    });
  }

  Future<void> _checkMultimediaUploadDownloadState() async {
    if (isMine && multimedia.url == null && !multimedia.isCanceled) {
      startUploading();
    } else if (!isMine && multimedia.path == null && !multimedia.isCanceled) {
      startDownload();
    }
  }

  startDownload() async {
    cancelToken = CancelToken();
    dowloading.value = true;
    progress.value = 0;
    try {
      print("Download Started");
      print("multimediaLocalId ${multimedia.localId}");
      bool downloaded = await _controller.downloadFile(
        fileUrl: multimedia.url!,
        fileName: multimedia.fileName,
        fileType: multimedia.type,
        multimediaLocalId: multimedia.localId,
        messageLocalId: multimedia.messageId,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          progress.value = (count / total);
        },
      );
      print(downloaded.toString());

      dowloading.value = false;
      // checkFileExit();
      fileExists.value = downloaded;
      print(multimedia);
    } catch (e) {
      dowloading.value = false;
    }
  }

  startUploading() async {
    cancelToken = CancelToken();
    dowloading.value = true;
    progress.value = 0;
    try {
      AppPrint.printInfo(multimedia.path!);
      AppPrint.printInfo(multimedia.type);
      AppPrint.printInfo(multimedia.url ?? "no Url");
      bool uploaded = await _controller.uploadFile(
        filePath: multimedia.path!,
        fileType: multimedia.type,
        messageLocalId: multimedia.messageId,
        cancelToken: cancelToken,
        onSendProgress: (count, total) {
          progress.value = (count / total);
        },
      );
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
    } else if (isMine) {
      startUploading();
    } else {
      startDownload();
    }
  }

  checkFileExit() async {
    print("checkFileExit ${multimedia.path}");
    if (multimedia.path != null) {
      bool fileExistCheck = await File(multimedia.path!).exists();
      // print(fileExistCheck.toString());
      fileExists.value = fileExistCheck;
    } else {
      fileExists.value = false;
    }
    isCheckingFileExistance.value = false;
    print(fileExists.value);
  }

  openfile() {
    if (multimedia.path != null) {
      try {
        OpenFile.open(multimedia.path);
      } catch (e) {
        AppUtil.hanldeAndShowFailure(
            const NotSpecificFailure(message: "Unable to open this file"));
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
