import 'package:ashghal_app_frontend/features/post/data/repositories/comment_repository_impl.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/add_comment_or_reply_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_post_comments_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/comment_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Tester extends StatelessWidget {
  const Tester({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.black,
              onTap: () {
                print("object");
              },
              highlightColor: Colors.red,
              hoverColor: Colors.amber,
              child: Container(
                width: double.infinity,
                height: 40,
                child: const Text(
                  "Reply",
                  textAlign: TextAlign.center,
                ),
              ),
              //   Row(
              // children: [

              // CircleAvatar(
              //   radius: 8,
              //   backgroundColor: Colors.grey,
              //   child: Text(
              //     "comment",
              //     style: Get.textTheme.bodySmall
              //         ?.copyWith(color: Colors.white),
              //   ),
              // )
              // ],
              // ),
            ),
            ElevatedButton(
                onPressed: () async {
                  CommentRepository cr = CommentRepositoryImpl();
                  var result = await cr.getPostComments(GetPostCommentsRequest(
                      postId: 114, perPage: 20, pageNumber: 1));
                  result.fold((l) {
                    printError(info: l.toString());
                  }, (r) {
                    printInfo(info: r.toString());
                  });
                },
                child: const Text("buutn1",
                    style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
