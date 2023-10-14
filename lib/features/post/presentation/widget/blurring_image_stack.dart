import 'package:flutter/material.dart';

import 'downalod_cashed_image_widget.dart';

class BlurringImageStackWidget extends StatelessWidget {
  final int totalImages;
  final String fourthImageUrl;

  const BlurringImageStackWidget({
    super.key,
    required this.fourthImageUrl,
    required this.totalImages,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DownloadCashedImage(
          imageUrl: fourthImageUrl,
          errorAssetImagePath: "assets/images/unKnown.jpg",
          fit: BoxFit.cover,
        ),
        Positioned(
          right: 0,
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            // width: double.infinity,
            // height: 200,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
              child: Text(
                '+ ${totalImages - 4}', // Number of additional images
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
