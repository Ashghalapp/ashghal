// import 'dart:io';

// // import 'package:cached_network_image/cached_network_image.dart';
// import 'package:ashghal_app_frontend/features/post/presentation/getx/post_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:http/http.dart' as http;

// Future<bool> filterValidImages(String url) async {
//     try {
//       final response = await http.head(Uri.parse(url));
//       if (response.statusCode == 200) {
//         print(":::::::::::::::::::valid image::::::::::::::::::::::::");
//         return true;
//       }
//       print(":::::::::::::::::in valid image:::::::::::::::::");
//       return false;
//     } catch (e) {
//       print(":::::::::::::::::in valid image in catch:::::::::::::::::");
//       return false;
//     }
//   }

//   Future<String?> loadImage(String imageUrl) async {
//     try {
//       if (!(await filterValidImages(imageUrl))) return null;
//       DefaultCacheManager cacheManager = DefaultCacheManager();
//       FileInfo? fileInfo = await cacheManager.getFileFromCache(imageUrl);
//       if (fileInfo == null) {
//         // Image is not cached, download and store it locally.
//         await cacheManager.downloadFile(imageUrl, force: true);
//         fileInfo = await cacheManager.getFileFromCache(imageUrl);
//       }
//       return fileInfo?.file.path;
//     } catch (e) {
//       print("::::::::: Error: $e");
//       // AppUtil.showMessage(AppLocalization.thereIsSomethingError, Colors.green);
//     }
//     return null;
//   }
// // حفظ الصورة في الكاش وحالاتها كرابط غير صالح او الصورة لم يتم تحميلها بعد
// // واثناء الضغط على الصورة تفتح بصفحة جديدة
// Widget buildCachedNetworkImage({
//   required String? imageUrl,
//   double width = 200,
//   double height = 200.0,
//   bool isBoxFitCover = true,
// }) {
//   PostController postsController = Get.put(PostController());
//   return 
// //    Image.network('Your image url...',
// //     errorBuilder: (context, error, stackTrace) => Text('Your error widget...'),
// // );
  
//   // imageUrl!=null?FadeInImage(
//   //             image: NetworkImage(imageUrl,),
//   //             placeholder: AssetImage("assets/images/unKnown.jpg"),
//   //             imageErrorBuilder: (context, error, stackTrace) {
//   //               return Image.asset('assets/images/unKnown.jpg',
//   //                   fit: BoxFit.fitWidth);
//   //             },
//   //             fit: BoxFit.fitWidth,
//   //           ): Image.asset("assets/images/unKnown.jpg"); 

//   Container(
//     // width: Get.width - 10,
//     // height: Get.height / 2,
//     child: FutureBuilder<String?>(
//       future: loadImage(imageUrl!),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Container(
//               width: Get.width - 10,
//               height: Get.height / 2,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//           );
//         } else if (snapshot.hasError || snapshot.data == null) {
//           debugPrint('Invalid Image URL: ${snapshot.data}');
//           // return Text("HEEEEEEEEEEERe");
//           return Image.asset("assets/images/unKnown.jpg");
//         } else {
//           try {
//             // debugPrint('Invalid Image but inside get: ${snapshot.data}');
//             // Display the cached image.
//             var t = snapshot.data != null
//                 ? FadeInImage(
//                     image: FileImage(File(snapshot.data!)),
//                     placeholder: const AssetImage("assets/images/unKnown.jpg"),
//                     imageErrorBuilder: (context, error, stackTrace) {
//                       return Image.asset('assets/images/unKnown.jpg',
//                           fit: BoxFit.fitWidth);
//                     },
//                     fit: BoxFit.fitWidth,
//                   )
//                 : Image.asset("assets/images/unKnown.jpg");
//             var widget = InkWell(
//                 onTap: () {
//                   Get.to(() => ImagePage(imageUrl: imageUrl!));
//                 },
//                 child: Container(
//                   width: isBoxFitCover ? width : Get.width - 5,
//                   height: isBoxFitCover ? height : Get.height / 2,
//                   decoration: BoxDecoration(
//                       // borderRadius: BorderRadius.circular(25.0),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black45,
//                           offset: Offset(0, 5),
//                           blurRadius: 8.0,
//                         ),
//                       ],
//                       image: DecorationImage(
//                         image: FileImage(File(snapshot.data!)),
//                         fit: isBoxFitCover ? BoxFit.fill : BoxFit.cover,
//                       )),
//                 ));
//             return t;
//           } catch (e) {
//             print("::::::::::::::: Catch Errors in cashe images");
//             return const Text("Not found images in cashe");
//           }
//         }
//       },
//     ),
//   );
// }
