// import 'package:ashghal_app_frontend/features/post/presentation/getx/post_controller.dart';
// import 'package:ashghal_app_frontend/features/post/presentation/widget/post_widget.dart';
// import 'package:ashghal_app_frontend/features/post/presentation/widget/post_shimmer.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PostsBuilder extends StatelessWidget {
//   final PostController postController;
//   final ScrollController? scrollController;
//   final Widget onFaildGetData;
//   const PostsBuilder({
//     super.key,
//     required this.postController,
//     this.scrollController,
//     required this.onFaildGetData,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => postController.postList.isNotEmpty
//           ? ListView.builder(
//               controller: scrollController,
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 print("------------Posts number $index");
//                 if (index == postController.postList.length - 3 &&
//                     index != postController.lastIndexToGetNewPage) {
//                   postController.loadNextPageOfPosts();
//                   postController.lastIndexToGetNewPage = index;
//                 }
//                 if (index < postController.postList.length) {
//                   return PostWidget(
//                     post: postController.postList[index],
//                   );
//                 }
//                 return null;
//               },
//               itemCount: postController.postList.length,
//             )
//           : postController.isRequestFinishWithoutData
//               ? onFaildGetData
//               : PostShimmer(width: Get.width, shimmerNumber: 2),
//     );
//   }
// }