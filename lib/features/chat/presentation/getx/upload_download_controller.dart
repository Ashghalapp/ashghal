import 'dart:io';

import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/directory_path.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
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

  // Future<void> _checkMultimediaUploadDownloadState() async {
  //   if (isMine && multimedia.url == null && !multimedia.isCanceled) {
  //     startUploading();
  //   } else if (!isMine && multimedia.path == null && !multimedia.isCanceled) {
  //     startDownload();
  //   }
  // }

  Future<void> _checkMultimediaUploadDownloadState() async {
    // ConversationController conversationController =
    int index = Get.find<ConversationController>().messages.indexWhere(
        (element) => element.message.localId == multimedia.messageId);

    if (isMine && multimedia.url == null && index == 0) {
      startUploading();
    } else if (!isMine && multimedia.path == null && index == 0) {
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
      await _controller.uploadFile(
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
    if (multimedia.path != null) {
      bool fileExistCheck = await File(multimedia.path!).exists();
      fileExists.value = fileExistCheck;
    } else {
      fileExists.value = false;
    }
    isCheckingFileExistance.value = false;
  }

  openfile() {
    if (multimedia.path != null) {
      try {
        OpenFile.open(multimedia.path);
      } catch (e) {
        AppUtil.hanldeAndShowFailure(
          NotSpecificFailure(message: AppLocalization.unableToOpenThisFile.tr),
        );
      }
    }
  }
}
