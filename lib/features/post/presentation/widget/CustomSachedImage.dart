// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// // صفحة مهمه للتعامل مع الصورة في الكاش ولكن لم يتم استخدامها
// Widget cachedImage(String url,
//     {double? height,
//     double? width,
//     BoxFit? fit,
//     AlignmentGeometry? alignment,
//     bool usePlaceholderIfUrlEmpty = true,
//     double? radius,
//     Color? color}) {
//   if (url.isEmpty) {
//     return placeHolderWidget(height: height, width: width);
//   } else if (GetUtils.isURL(url)) {
//     return CachedNetworkImage(
//       imageUrl: url,
//       height: height,
//       width: width,
//       fit: fit,
//       filterQuality: FilterQuality.medium,
//       alignment: alignment as Alignment? ?? Alignment.center,
//       errorWidget: (_, s, d) {
//         return placeHolderWidget(
//             height: height,
//             width: width,
//             fit: fit,
//             alignment: alignment,
//             radius: radius);
//       },
//       placeholder: (_, s) {
//         if (!usePlaceholderIfUrlEmpty) return const SizedBox();
//         return placeHolderWidget(
//             height: height,
//             width: width,
//             fit: fit,
//             alignment: alignment,
//             radius: radius);
//       },
//     );
//   } else if (url.startsWith('/data')) {
//     return Image.file(
//       File(url),
//       height: height,
//       width: width,
//       fit: fit,
//       alignment: alignment ?? Alignment.center,
//     );
//   } else if (url.contains("img")) {
//     return CachedNetworkImage(
//       imageUrl: url,
//       height: height,
//       width: width,
//       fit: fit,
//       filterQuality: FilterQuality.high,
//       alignment: alignment as Alignment? ?? Alignment.center,
//       errorWidget: (_, s, d) {
//         return placeHolderWidget(
//             height: height,
//             width: width,
//             fit: fit,
//             alignment: alignment,
//             radius: radius);
//       },
//       placeholder: (_, s) {
//         if (!usePlaceholderIfUrlEmpty) return const SizedBox();
//         return placeHolderWidget(
//             height: height,
//             width: width,
//             fit: fit,
//             alignment: alignment,
//             radius: radius);
//       },
//     );
//   } else {
//     return Image.asset(
//       url,
//       height: height,
//       width: width,
//       fit: fit,
//       alignment: alignment ?? Alignment.center,
//       color: color,
//     );
//   }
// }

// Widget placeHolderWidget(
//     {double? height,
//     double? width,
//     BoxFit? fit,
//     AlignmentGeometry? alignment,
//     double? radius}) {
//   return Placeholder(
//       fallbackHeight: height!, fallbackWidth: width!, color: Colors.red);
// }
