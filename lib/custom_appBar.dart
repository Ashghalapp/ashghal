import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/post/presentation/getx/post_controller.dart';
import 'features/post/presentation/widget/post_card_widget.dart';


class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scrollController = ScrollController();
  final PostController postController = Get.put(PostController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text("Hezbr Al-humaidi",
                  style: TextStyle(fontSize: 25)),
              centerTitle: true,
              expandedHeight: 180,
              
              leading: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.account_circle),
                    onPressed: (() {}),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: (() {}),
                    ),
                  ),
                ],
              ),

              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent,
                    Colors.pink,
                    Colors.deepPurpleAccent
                  ],
                )),
              ),

              actions: [
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: (() {}),
                ),
                IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: (() {}),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                // body contains
                Obx(
              () => postController.postList.isNotEmpty
                  ? ListView.builder(
                      controller: _scrollController,
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
                            key: GlobalObjectKey(
                                postController.postList[index].id),
                            post: postController.postList[index],
                          );
                        }
                        return null;
                      },
                      itemCount: postController.postList.length,
                    )
                  : Text("Hezbr")
            ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
