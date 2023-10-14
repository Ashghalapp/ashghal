import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path_provider/path_provider.dart';

class ImageDisplayController extends GetxController {
  final RxList<String> imageUrls = <String>[].obs;

  void setImageUrls(List<String> urls) {
    imageUrls.assignAll(urls);
  }

  void saveImageToGallaryStorage(String choice, String imageUrl) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        DefaultCacheManager cacheManager = DefaultCacheManager();
        FileInfo? fileInfo = await cacheManager.getFileFromCache(imageUrl);

        if (fileInfo != null && fileInfo.file.existsSync()) {
          final externalDirectory = await getExternalStorageDirectory();

          // Define your custom album name
          const albumName = 'AshghalApp';

          // Construct the full path to your custom album
          final albumPath = '${externalDirectory?.path}/$albumName';

          // Create the custom album if it doesn't exist
          final albumDirectory = Directory(albumPath);
          if (!albumDirectory.existsSync()) {
            albumDirectory.createSync(recursive: true);
          }

          final fileName = imageUrl.split('/').last;
          final savePath = '$albumPath/$fileName';

          await fileInfo.file.copy(savePath);

          Get.snackbar(
            'Image Saved',
            'Image has been saved to the custom album.',
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          Get.snackbar(
            'Image Not Cached',
            'You should cache the image first.',
            backgroundColor: Colors.yellow,
            snackPosition: SnackPosition.TOP,
          );
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      Get.snackbar(
        'Permission Denied',
        'You need to grant storage permission to save the image.',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
