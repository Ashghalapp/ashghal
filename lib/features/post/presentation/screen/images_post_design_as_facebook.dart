import 'package:ashghal_app_frontend/core/app_functions.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/multimedia.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/image_display_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/desplay_images.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/blurring_image_stack.dart';
import 'package:ashghal_app_frontend/core/widget/cashed_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/display_image_on_tap.dart';

/// عرض الصور الخاصة بالبوست حسب عدد الصور وتنسيقاتها
class ImagesPostDesignAsFacebook extends StatelessWidget {
  final List<Multimedia> multimedia;

  final ImageDisplayController imageDisplayController =
      Get.put(ImageDisplayController());
  ImagesPostDesignAsFacebook({super.key, required this.multimedia});

  final double rowHeightConstant = 220;

  @override
  Widget build(BuildContext context) {
    var imagePaths = multimedia
        .map((e) => AppFunctions.handleImagesToEmulator(e.url.toString()))
        .toList();

    if (imagePaths.isEmpty) {
      return const SizedBox.shrink();
    } else if (imagePaths.length == 1) {
      return showOneImageAsRow(imagePaths[0]);
    } else if (imagePaths.length == 2) {
      return showRowOfImages(imagePaths[0], imagePaths[1]);
    } else if (imagePaths.length == 3) {
      return Column(
        children: [
          showOneImageAsRow(imagePaths[2]),
          const SizedBox(height: 1.5),
          showRowOfImages(imagePaths[0], imagePaths[1]),
        ],
      );
    } else if (imagePaths.length == 4) {
      return Column(
        children: [
          showRowOfImages(imagePaths[0], imagePaths[1]),
          const SizedBox(height: 1.5),
          showRowOfImages(imagePaths[2], imagePaths[3]),
        ],
      );
    } else {
      return Card(
        child: SizedBox(
          // height: 440,
          child: Column(
            children: [
              showRowOfImages(imagePaths[0], imagePaths[1]),
              const SizedBox(height: 1.5),
              SizedBox(
                height: rowHeightConstant,
                child: Row(
                  children: [
                    showOneImage(imagePaths[2]),
                    // MultibleImagesPost(imageUrl: imagePaths[2]),
                    InkWell(
                      onTap: () {
                        // تهيئة مصفوفة الصور في الكنترولر وفتح الصفحة التي تعرض كل الصور التي يحتويها البوست
                        Get.find<ImageDisplayController>()
                            .setImageUrls(imagePaths);
                        Get.to(() => ImageDisplayPage());
                      },
                      //استداء خاص بوضع عدد الصور التي لم تعرض في البوست فوق الصورة الرابعه بشكل ضبابي
                      child: BlurringImageStackWidget(
                        fourthImageUrl: imagePaths[3],
                        totalImages: imagePaths.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget showRowOfImages(String path1, String path2) {
    return SizedBox(
      height: rowHeightConstant,
      child: Row(
        children: [
          showOneImage(path1),
          const SizedBox(width: 1),
          showOneImage(path2),
        ],
      ),
    );
  }

  Widget showOneImage(String path) {
    return Expanded(
      child: CashedNetworkImageWidget(
        imageUrl: path,
        onTap: () => Get.to(() => ImagePage(imageUrl: path)),
        errorAssetImagePath: "assets/images/unKnown.jpg",
        fit: BoxFit.cover,
        height: rowHeightConstant,
      ),
    );
  }

  Widget showOneImageAsRow(String path) {
    return SizedBox(
      height: rowHeightConstant,
      child: Row(
        children: [
          showOneImage(path),
        ],
      ),
    );
  }
}
