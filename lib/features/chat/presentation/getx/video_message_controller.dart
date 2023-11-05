import 'dart:io';
import 'dart:typed_data';

import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/video_player_page.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoMessageController extends GetxController {
  RxBool thumbnailReady = false.obs;

  final LocalMultimedia multimedia;
  final bool isMine;

  VideoMessageController({required this.multimedia, required this.isMine});

  @override
  void onInit() {
    super.onInit();

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
      ),
    );
  }
}
