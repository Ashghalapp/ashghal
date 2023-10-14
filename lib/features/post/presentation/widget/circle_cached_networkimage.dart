import 'package:ashghal_app_frontend/features/post/presentation/widget/downalod_cashed_image_widget.dart';
import 'package:flutter/material.dart';

// حفظ الصورة في الكاش الخاصة بالبروفايل وتكون دائرية وحالاتها كرابط غير صالح او الصورة لم يتم تحميلها بعد

Widget buildCircleCachedNetworkImage(
    {required String? imageUrl, double radius = 55.0}) {
  return Container(
    width: radius,
    height: radius,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: DownloadCashedImage(
        imageUrl: imageUrl ?? "",
        onWaiting: () => Image.asset("assets/images/unKnown.jpg"),
        errorAssetImagePath: "assets/images/unKnown.jpg",
        fit: BoxFit.cover,
      ),
    ),
  );
}
