// import 'package:ashghal/model/multimedea_model.dart';
import 'dart:io';

import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/directory_path.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
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

// // import '../../core/services/multimedia_services.dart';
// class CustomFile {
//   File file;
//   String name;
//   String path;
//   String type; // extension

//   CustomFile({
//     required this.file,
//     required this.name,
//     required this.path,
//     required this.type,
//   });
// }

class MultimediaController extends GetxController {
  // ConversationScreenController _screenController = Get.find();
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
            print("file path: $path");
            Get.find<ConversationScreenController>()
                .sendMultimediaMessage(path);
          }
        }
      }
    } catch (e) {
      return null;
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
    // required String fileUrl,
    required String filePath,
    required String fileType,
    required int messageLocalId,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      // String storePath = await directoryPath.getPath("${fileType}s");
      // String filePath = '$storePath/$fileName';
      // filePath = await getUniqueFileName(filePath);
      if (!await File(filePath).exists()) {
        AppUtil.buildErrorDialog("File doesn't exists");
        return false;
      }
      UploadRequest request = UploadRequest(
        // url: fileUrl,
        // savePath: filePath,
        messageLocalId: messageLocalId,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      // bool downloaded =
      return await _conversationController.upload(request);
      // return await _conversationController.download(request);
    } catch (e) {
      return false;
    }
  }

  Future<String> getUniqueFileName(String filePath) async {
    final originalFile = File(filePath);

    if (!await originalFile.exists()) {
      return filePath; // The file with the original name doesn't exist.
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

  // Future<void> pickCameraImage() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.camera);
  //   if (pickedImage != null) {
  //     // _image.value = File(pickedImage.path);
  //     // String message = messageText.text;
  //     // _screenController.conversationController
  //     //     .sendMultimediaMessage(messageTextEdittingController.text);
  //     // SendMessageRequest request = SendMessageRequest.withBodyAndMultimedia(
  //     //   conversationId: _conversationScreenController.conversationId,
  //     //   body: messageTextEdittingController.text,
  //     //   filePath: pickedImage.path,
  //     // );
  //     // _conversationScreenController.conversationController.sendMessage(request);
  //     // messageTextEdittingController.clear();
  //     // {
  //     //    // Clear the text field after sending the message
  //     //   update(); // Notify GetBuilder to rebuild the UI
  //     // }
  //   }
  // }
//   var multimediaList = <MultimediaModel>[].obs;

//   Future<void> getMultimediaList(String baseUrl) async {
//     try {
//       final result = await MultimediaService.getMultimediaList(baseUrl);
//       multimediaList.assignAll(result);
//     } catch (e) {
//       print(e);
//       throw Exception('Failed to load multimedia list');
//     }
//   }

//   Future<void> getMultimediaById(String baseUrl, int multimediaId) async {
//     try {
//       final result =
//           await MultimediaService.getMultimediaById(baseUrl, multimediaId);
//       multimediaList.add(result);
//     } catch (e) {
//       print(e);
//       throw Exception('Failed to load multimedia by id: $multimediaId');
//     }
//   }

//   Future<void> createMultimedia(
//       String baseUrl, MultimediaModel multimedia) async {
//     try {
//       await MultimediaService.createMultimedia(baseUrl, multimedia);
//       multimediaList.add(multimedia);
//     } catch (e) {
//       print(e);
//       throw Exception('Failed to create multimedia');
//     }
//   }

//   Future<void> updateMultimedia(
//       String baseUrl, MultimediaModel multimedia) async {
//     try {
//       await MultimediaService.updateMultimedia(baseUrl, multimedia);
//       final index = multimediaList.indexWhere((m) => m.id == multimedia.id);
//       if (index >= 0) {
//         multimediaList[index] = multimedia;
//       }
//     } catch (e) {
//       print(e);
//       throw Exception('Failed to update multimedia: ${multimedia.id}');
//     }
//   }

//   Future<void> deleteMultimedia(String baseUrl, int multimediaId) async {
//     try {
//       await MultimediaService.deleteMultimedia(baseUrl, multimediaId);
//       multimediaList.removeWhere((m) => m.id == multimediaId);
//     } catch (e) {
//       print(e);
//       throw Exception('Failed to delete multimedia: $multimediaId');
//     }
//   }

  // Future<void> uploadImage(
  //     File imageFile, String imageName, String imagePath) async {
  //   var stream = http.ByteStream(http.ByteStream(imageFile.openRead()));
  //   var length = await imageFile.length();

  //   var uri = Uri.parse(
  //       'http://192.168.5.196/ApiFileUploadTest/public/api/uploading-file-api');

  //   var request = http.MultipartRequest('POST', uri);

  //   // Add the file with a custom field name 'file'
  //   var multipartFile = http.MultipartFile('file', stream, length,
  //       filename: path.basename(imageFile.path));

  //   // Add additional fields (name, path, type) to the request
  //   request.fields['name'] = imageName;
  //   request.fields['path'] = imagePath;
  //   request.fields['type'] = 'image/jpeg'; // Replace with the actual file type

  //   // Add the file to the request
  //   request.files.add(multipartFile);

  //   try {
  //     var response = await request.send();
  //     if (response.statusCode == 200) {
  //       print('Image uploaded successfully');
  //       response.stream.transform(utf8.decoder).listen((value) {
  //         print(value);
  //       });
  //     } else {
  //       print('Image upload failed with status ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error uploading image: $error');
  //   }
  // }
}
