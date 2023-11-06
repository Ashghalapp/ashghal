import 'package:ashghal_app_frontend/core/widget/cashed_image_widget.dart';
import 'package:flutter/material.dart';

// حفظ الصورة في الكاش الخاصة بالبروفايل وتكون دائرية وحالاتها كرابط غير صالح او الصورة لم يتم تحميلها بعد
class CircleCachedNetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String? onErrorImagePath;
  final double radius;
  final BoxFit fit;
  final void Function()? onTap;
  const CircleCachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.onErrorImagePath,
    this.radius = 55,
    this.fit = BoxFit.cover,
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
          child: CashedNetworkImageWidget(
            imageUrl: imageUrl ?? "",
            onWaiting: () => Image.asset("assets/images/unKnown.jpg"),
            errorAssetImagePath:
                onErrorImagePath ?? "assets/images/unKnown.jpg",
            fit: fit,
          ),
        ),
      ),
    );
  }
}

// Widget CircleCachedImageWidget({
//   required String? imageUrl,
//   double radius = 55.0,
//   String? onErrorImagePath,
// }) {
//   return Container(
//     width: radius,
//     height: radius,
//     decoration: const BoxDecoration(
//       shape: BoxShape.circle,
//     ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(radius),
//       child: CashedImageWidget(
//         imageUrl: imageUrl ?? "",
//         onWaiting: () => Image.asset("assets/images/unKnown.jpg"),
//         errorAssetImagePath: onErrorImagePath ?? "assets/images/unKnown.jpg",
//         fit: BoxFit.cover,
//       ),
//     ),
//   );
// }
