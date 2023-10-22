// import 'package:ashghal_app_frontend/config/app_routes.dart';
// import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
// import 'package:ashghal_app_frontend/features/account/widgets/header_widgets/provider_data_widget.dart';
// import 'package:ashghal_app_frontend/features/account/widgets/header_widgets/statistics_widget.dart';
// import 'package:ashghal_app_frontend/features/account/widgets/header_widgets/user_image_with_back_shape_widget.dart';
// import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HeaderAccountWidget extends StatelessWidget {
//   final User userData;

//   // final Map<String, dynamic>? userDataOffline;
//   const HeaderAccountWidget({
//     super.key,
//     required this.userData,
//     // this.userDataOffline,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = SharedPref.getCurrentUserData()['id'];

//     return Column(
//       children: [
//         // صورة المستخدم مع الشكل الخلفي للصورة
//         UserImageWithBackShapeWidget(
//           imageUrl: userData.imageUrl,
//           aboveWidget: [
//             if (userData.id != currentUserId)
//               Container(
//                 alignment: AlignmentDirectional.topStart,
//                 padding: const EdgeInsets.all(8.0),
//                 child: IconButton(
//                     onPressed: () => Get.back(),
//                     icon: const Icon(Icons.arrow_back)),
//               ),

//             Container(
//               alignment: userData.id == currentUserId
//                   ? AlignmentDirectional.topStart
//                   : AlignmentDirectional.topEnd,
//               padding: const EdgeInsets.all(8.0),
//               child:
//                   IconButton(onPressed: () {}, icon: const Icon(Icons.details)),
//             ),

//             // ايقونة الاعدادات
//             if (userData.id == currentUserId)
//               Container(
//                 // padding: EdgeInsets.only(top: Get.mediaQuery.viewPadding.top),
//                 alignment: AlignmentDirectional.topEnd,
//                 padding: const EdgeInsets.all(8.0),
//                 child: IconButton(
//                   onPressed: () {
//                     SharedPref.setUserLoggedIn(false);
//                     Get.offAllNamed(AppRoutes.logIn);
//                     // Get.to(() => const Setting());
//                   },
//                   icon: const Icon(Icons.settings),
//                   style: IconButton.styleFrom(
//                     elevation: 20,
//                     // shadowColor: ,
//                     // backgroundColor: Colors.green,
//                   ),
//                 ),
//               ),
//           ],
//         ),

//         // buildBackAndCircleAvatorStack(userData.imageUrl),

//         SizedBox(
//           // height: 190,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     userData.name,
//                     style: Get.textTheme.titleMedium,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),

//               // build the statistics widget
//               StatisticsWidget(
//                 followers: userData.followersUsers.length,
//                 followings: userData.followingUsers.length,
//                 likes: 37,
//               ),
//               const SizedBox(height: 14),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               //   children: [
//               //     // buildButtonWidget(
//               //     //     text: "Edit Profile",
//               //     //     onClick: () => Get.to(() => EditAccountScreen())),
//               //     buildButtonWidget(text: "Add Friends", onClick: () {}),
//               //   ],
//               // ),

//               // about user widget
//               if (userData.provider != null)
//                 ProviderDataWidget(provider: userData.provider!),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget _buildAboutUserWidget() {
//   //   return SizedBox(
//   //     width: double.infinity,
//   //     // color: Colors.grey,
//   //     child: Padding(
//   //       padding: const EdgeInsets.only(right: 4, left: 4, bottom: 8),
//   //       child: Column(
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           Text("Provider Data", style: Get.textTheme.titleMedium),
//   //           Text(
//   //             userData.provider!.jobName!,
//   //             style: Get.textTheme.bodyLarge
//   //                 ?.copyWith(fontWeight: FontWeight.bold),
//   //           ),
//   //           if (userData.provider!.jobDesc != null)
//   //             Text(
//   //               userData.provider!.jobDesc!,
//   //               style: Get.textTheme.bodyMedium,
//   //             ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   // دالة لبناء صورة المستخدم مع الشكل الخلفي لها
//   // Stack buildBackAndCircleAvatorStack(String? imageUrl) {
//   //   final currentUserId = SharedPref.getCurrentUserData()['id'];
//   //   return Stack(
//   //     fit: StackFit.passthrough,
//   //     children: <Widget>[
//   //       // stack تحجيم ارتفاع الـ
//   //       // const SizedBox(height: 250),

//   //       // الشكل الخلفي للصورة
//   //       ClipPath(
//   //         clipper: WaveClipper(),
//   //         child: SizedBox(
//   //           height: 180,
//   //           width: double.infinity,
//   //           child: Image.asset(
//   //             "assets/images/chatbg12.jpg",
//   //             fit: BoxFit.fitWidth,
//   //           ),
//   //         ),
//   //       ),

//   //       // صورة المستخدم
//   //       Container(
//   //         padding: const EdgeInsets.only(top: 115, bottom: 8),
//   //         child: Row(
//   //           mainAxisAlignment: MainAxisAlignment.center,
//   //           children: [
//   //             CircleCachedImageWidget(imageUrl: imageUrl, radius: 150),
//   //           ],
//   //         ),
//   //       ),

//   //       if (userData.id != currentUserId)
//   //         Container(
//   //           alignment: AlignmentDirectional.topStart,
//   //           padding: const EdgeInsets.all(8.0),
//   //           child: IconButton(
//   //               onPressed: () => Get.back(),
//   //               icon: const Icon(Icons.arrow_back)),
//   //         ),

//   //       Container(
//   //         alignment: userData.id == currentUserId
//   //             ? AlignmentDirectional.topStart
//   //             : AlignmentDirectional.topEnd,
//   //         padding: const EdgeInsets.all(8.0),
//   //         child: IconButton(onPressed: () {}, icon: const Icon(Icons.details)),
//   //       ),

//   //       // ايقونة الاعدادات
//   //       if (userData.id == currentUserId)
//   //         Container(
//   //           // padding: EdgeInsets.only(top: Get.mediaQuery.viewPadding.top),
//   //           alignment: AlignmentDirectional.topEnd,
//   //           padding: const EdgeInsets.all(8.0),
//   //           child: IconButton(
//   //             onPressed: () {
//   //               SharedPref.setUserLoggedIn(false);
//   //               Get.offAllNamed(AppRoutes.logIn);
//   //               // Get.to(() => const Setting());
//   //             },
//   //             icon: const Icon(Icons.settings),
//   //             style: IconButton.styleFrom(
//   //               elevation: 20,
//   //               // shadowColor: ,
//   //               // backgroundColor: Colors.green,
//   //             ),
//   //           ),
//   //         ),
//   //     ],
//   //   );
//   // }
// }

// ElevatedButton buildButtonWidget(
//     {required String text, required void Function() onClick}) {
//   return ElevatedButton(
//     onPressed: onClick,
//     style: const ButtonStyle().copyWith(
//       backgroundColor: const MaterialStatePropertyAll(Colors.indigo),
//     ),
//     child: Text(text,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 15,
//           fontWeight: FontWeight.bold,
//         )),
//   );
// }

// // دالة لبناء صف يحتوي على عدد المتابعين والمتابعات والاعجابات
// // Row _buildStatisticsRow(
// //     {required int followers, required int followings, required int likes}) {
// //   return Row(
// //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //     children: [
// //       _buildStatisticColumn(text: "followers", count: followers),
// //       _buildStatisticColumn(text: "following", count: followings),
// //       _buildStatisticColumn(text: "likes", count: likes),
// //     ],
// //   );
// // }

// // Column _buildStatisticColumn({required String text, required int count}) {
// //   return Column(
// //     children: [
// //       Text(
// //         count.toString(),
// //         style: Get.textTheme.titleMedium?.copyWith(
// //             color: Get.theme.primaryColor, fontWeight: FontWeight.bold),
// //       ),
// //       Text(text, style: Get.textTheme.bodyMedium),
// //     ],
// //   );
// // }

// // class WaveClipper extends CustomClipper<Path> {
// //   @override
// //   Path getClip(Size size) {
// //     debugPrint(size.width.toString());
// //     debugPrint(size.height.toString());

// //     double width = size.width;
// //     double height = size.height;

// //     var path = Path();
// //     path.lineTo(0, height); // start path with this if you are
// //     path.lineTo(width / 8, height); // start path with this if you are

// //     var firstStart = Offset(width / 5, height);
// //     var firstEnd = Offset(width / 4 + width / 20, height - height / 6);
// //     path.quadraticBezierTo(
// //         firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

// //     var middleStart = Offset(width / 2, height / 2 - 30);
// //     var middleEnd = Offset(width / 2 + width / 5, height - height / 6);
// //     path.quadraticBezierTo(
// //         middleStart.dx, middleStart.dy, middleEnd.dx, middleEnd.dy);

// //     var secondStart = Offset(width - width / 5, height);
// //     var secondEnd = Offset(width - width / 8, height);
// //     path.quadraticBezierTo(
// //         secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

// //     path.lineTo(width, height); //end with this path if you
// //     path.lineTo(width, 0); //end with this path if you
// //     path.close();
// //     return path;
// //   }

// //   @override
// //   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
// //     return true;
// //   }
// // }
