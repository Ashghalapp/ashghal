import 'dart:io';

import 'package:ashghal_app_frontend/core/widget/cashed_image_widget.dart';
import 'package:flutter/material.dart';

// حفظ الصورة في الكاش الخاصة بالبروفايل وتكون دائرية وحالاتها كرابط غير صالح او الصورة لم يتم تحميلها بعد
class CircleFileImageWidget extends StatelessWidget {
  final String imagePath;
  final String? onErrorImagePath;
  final double radius;
  final BoxFit fit;
  final void Function()? onTap;
  const CircleFileImageWidget({
    super.key,
    required this.imagePath,
    this.onErrorImagePath,
    this.radius = 55,
    this.fit = BoxFit.fill,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: radius,
        height: radius,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.file(
            File(imagePath),
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("assets/images/unKnown.jpg");
            },
          ),
        ),
      ),
    );
  }
}
