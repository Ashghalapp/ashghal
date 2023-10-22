import 'package:ashghal_app_frontend/features/post/presentation/getx/image_display_controller.dart';
import 'package:ashghal_app_frontend/core/widget/cashed_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// عرض الصورة بشكل منفصل اثناء الضغط عليها
class ImagePage extends StatelessWidget {
  final String imageUrl;
  final ImageDisplayController displayController =
      Get.put(ImageDisplayController());
  ImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    PopupMenuButton<String>(
                      onSelected: (choice) => displayController
                          .saveImageToGallaryStorage(choice, imageUrl),
                      itemBuilder: (BuildContext context) {
                        return {'Save Image'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: CashedNetworkImageWidget(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                onTap: () => Get.to(() => ImagePage(imageUrl: imageUrl)),
                errorAssetImagePath: "assets/images/unKnown",
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
