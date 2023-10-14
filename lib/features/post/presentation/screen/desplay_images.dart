import 'package:ashghal_app_frontend/features/post/presentation/getx/image_display_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/cached_networkimage.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/downalod_cashed_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/display_image_on_tap.dart';

//صفحة عرض كل الصور الموجوده في البوست ان كانت اكثر من 4 صور
class ImageDisplayPage extends StatelessWidget {
  final ImageDisplayController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = controller.imageUrls;

    return Scaffold(
      appBar: AppBar(
        title: Text('Image Display'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              child: DownloadCashedImage(
                imageUrl: imageUrls[index],
                fit: BoxFit.cover,
                onTap: () =>
                    Get.to(() => ImagePage(imageUrl: imageUrls[index])),
                errorAssetImagePath: "assets/images/unKnown",
              ),
            );
          },
        ),
      ),
    );
  }
}
