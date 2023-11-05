// import 'package:ashghal/model/multimedea_model.dart';
import 'dart:io';

import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/directory_path.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/util/dialog_util.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/download_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/upload_request.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/camera_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/sending_image_view_page.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/sending_video_view_page.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/video_player_page.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

enum AttachmentOption { camera, gallery, video, file }

//An extension, To extract the enum values as strings without the enum type name.
extension AttachmentOptionExtension on AttachmentOption {
  String get value {
    switch (this) {
      case AttachmentOption.camera:
        return AppLocalization.camera;
      case AttachmentOption.gallery:
        return AppLocalization.gallery;
      case AttachmentOption.video:
        return AppLocalization.video;
      case AttachmentOption.file:
        return AppLocalization.file;
    }
  }
}

class MultimediaController extends GetxController {
  final ConversationController _conversationController = Get.find();

  DirectoryPath directoryPath = DirectoryPath();

  void handleAttachmentOption(AttachmentOption option) async {
    if (option == AttachmentOption.camera) {
      goToCameraScreen();
    } else if (option == AttachmentOption.gallery) {
      pickImagesFromGallery();
    } else if (option == AttachmentOption.video) {
      pickVideoFromGallery();
    } else if (option == AttachmentOption.file) {
      await pickFiles();
    }
    Get.back();
  }

  Future<void> pickVideoFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      Get.to(() => SendingVideoViewPage(path: pickedFile.path));
    }
  }

  void pickImagesFromGallery() async {
    try {
      final List<XFile> pickedImages = await ImagePicker().pickMultiImage();
      if (pickedImages.isNotEmpty) {
        List<String> paths =
            pickedImages.map((pickedImage) => pickedImage.path).toList();
        Get.to(() => SendingImageViewPage(paths: paths));
      }
    } catch (e) {}
  }

  void goToCameraScreen() async {
    Get.to(() => CameraScreen());
  }

  Future<void> pickFiles() async {
    try {
      List<String> allowedExtensions =
          allowedExtensionsByType.values.expand((ext) => ext).toList();

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true, // Set to true to allow selecting multiple files
      );

      if (result != null) {
        List<String> pickedFilesPaths =
            result.files.map((file) => file.path ?? "").toList();
        for (String path in pickedFilesPaths) {
          if (path != "") {
            Get.find<ConversationScreenController>()
                .sendMultimediaMessage(path);
          }
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<bool> downloadFile({
    required String fileUrl,
    required String fileName,
    required String fileType,
    required int multimediaLocalId,
    required int messageLocalId,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      String storePath = await directoryPath.getPath(fileType);
      String filePath = '$storePath/$fileName';
      filePath = await getUniqueFileName(filePath);
      DownloadRequest request = DownloadRequest(
        url: fileUrl,
        savePath: filePath,
        multimediaLocalId: multimediaLocalId,
        messageLocalId: messageLocalId,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return await _conversationController.download(request);
    } catch (e) {
      return false;
    }
  }

  Future<bool> uploadFile({
    required String filePath,
    required String fileType,
    required int messageLocalId,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      if (!await File(filePath).exists()) {
        DialogUtil.showErrorDialog("File doesn't exists");
        return false;
      }
      UploadRequest request = UploadRequest(
        messageLocalId: messageLocalId,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return await _conversationController.upload(request);
    } catch (e) {
      return false;
    }
  }

  Future<String> getUniqueFileName(String filePath) async {
    final originalFile = File(filePath);

    if (!await originalFile.exists()) {
      return filePath;
    }

    final directory = originalFile.parent;
    final originalFileName = originalFile.path.split('/').last;
    final originalFileNameWithoutExtension = originalFileName.split('.').first;
    final originalFileExtension = originalFileName.split('.').last;
    int suffix = 0;

    String newFilePath;
    do {
      final newFileName =
          '$originalFileNameWithoutExtension($suffix).$originalFileExtension';
      newFilePath = '${directory.path}/$newFileName';
      suffix++;
    } while (await File(newFilePath).exists());

    return newFilePath;
  }

  playVideo(LocalMultimedia multimedia) {
    Get.to(
      () => VideoPlayerPage(
        multimedia: multimedia,
      ),
    );
  }
}
