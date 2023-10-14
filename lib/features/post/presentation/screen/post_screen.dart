import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/post_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_card_widget.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../getx/comment_input_controller.dart';

class PostsScreen extends StatelessWidget {
  final PostController postController = Get.put(PostController());
  PostsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: postController.getAlivePosts,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 224, 227, 232),
        // appBar: AppBar(
        //   title: const Text("ASHGHAL APP"),
        //   centerTitle: true,
        // ),
        body: 
        Obx(
          () => postController.postList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    print("------------Posts number $index");
                    if (index == postController.postList.length - 3 &&
                        index != postController.lastIndexToGetNewPage) {
                      postController.loadNextPageOfPosts();
                      postController.lastIndexToGetNewPage = index;
                    }
                    if (index < postController.postList.length) {
                      return PostCardWidget(
                          post: postController.postList[index]);
                    }
                    return null;
                  },
                  itemCount: postController.postList.length,
                )
              : postController.isRequestFinishWithoutData
                  ? buildFaildDownloadPostsWidget()
                  : PostShimmer(width: Get.width, shimmerNumber: 2),
        ),

        // floatingActionButton: FloatingActionButton(
        //     onPressed: () async{
        //       var r = postsController.trying();
        //       print("<<<<<<<<<<<<<<<<<<$r>>>>>>>>>>>>>>>>>>");
        //     }, child: Icon(Icons.add_a_photo)),
      ),
    );
  }

  Widget buildFaildDownloadPostsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalization.thereIsSomethingError),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: postController.refreshPosts,
            child: const Text(
              "Try again",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
