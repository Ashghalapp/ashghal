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
    final String? languageCode = Get.locale?.languageCode;
    return Scaffold(
        // backgroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.867),
        body: Stack(children: [
          Positioned(
            left: languageCode == 'en'? null: 0,
            right: languageCode == 'ar'? null: 0,
            top: MediaQuery.of(context).viewPadding.top,
            child: PopupMenuButton<String>(
              color: Colors.white,
              onSelected: (choice) =>
                  displayController.saveImageToGallaryStorage(choice, imageUrl),
              itemBuilder: (BuildContext context) {
                return {'Save Image'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
          Positioned(
            left: languageCode == 'en'? 0: null,
            right: languageCode == 'ar'? 0: null,
            top: MediaQuery.of(context).viewPadding.top,
            child: IconButton(
              onPressed: () async {
                Get.back();
              },
              icon: Icon(
                languageCode == 'ar' ? Icons.arrow_forward : Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            alignment: AlignmentDirectional.center,
            child: CashedNetworkImageWidget(
              imageUrl: imageUrl,
              fit: BoxFit.fill,
              onTap: () => Get.to(() => ImagePage(imageUrl: imageUrl)),
              errorAssetImagePath: "assets/images/unKnown",
            ),
          ),
        ]));
    //     Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Expanded(
    //             flex: 2,
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.end,
    //               children: <Widget>[
    //                 PopupMenuButton<String>(
    //                   onSelected: (choice) => displayController
    //                       .saveImageToGallaryStorage(choice, imageUrl),
    //                   itemBuilder: (BuildContext context) {
    //                     return {'Save Image'}.map((String choice) {
    //                       return PopupMenuItem<String>(
    //                         value: choice,
    //                         child: Text(choice),
    //                       );
    //                     }).toList();
    //                   },
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Expanded(
    //             flex: 8,
    //             child: CashedNetworkImageWidget(
    //               imageUrl: imageUrl,
    //               fit: BoxFit.fill,
    //               onTap: () => Get.to(() => ImagePage(imageUrl: imageUrl)),
    //               errorAssetImagePath: "assets/images/unKnown",
    //             ),
    //           ),
    //           // Expanded(
    //           //   flex: 1,
    //           //   child: Container(
    //           //     color: Colors.blue,
    //           //   ),
    //           // ),
    //         ],
    //       ),
    //     ),
    //   )
  }
}
