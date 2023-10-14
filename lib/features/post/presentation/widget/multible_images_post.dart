import 'package:ashghal_app_frontend/features/post/presentation/widget/cached_networkimage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'display_image_on_tap.dart';
import 'downalod_cashed_image_widget.dart'; // Import the cached_network_image package

class MultibleImagesPost extends StatelessWidget {
  final String imageUrl;

  MultibleImagesPost({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // width: Get.width / 2 - 10,
        // height: 200,
        child: DownloadCashedImage(
          imageUrl: imageUrl,
          onTap: () => Get.to(() => ImagePage(imageUrl: imageUrl)),
          errorAssetImagePath: "assets/images/unKnown.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
