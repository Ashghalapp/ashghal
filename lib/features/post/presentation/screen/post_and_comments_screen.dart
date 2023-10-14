import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/comment_controller.dart';

import 'package:ashghal_app_frontend/features/post/presentation/widget/comment_input_widget.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../getx/comment_input_controller.dart';
import '../widget/comment_reply_widgets/comment_widget.dart';

// الصفحة الخاصة بعرض البوست والتعليقات الخاصه به
// يتم استدعائها عندما يضغط المستخدم على زر تعليق في البوست
class PostCommentsScreen extends StatelessWidget {
  final Post post;
  PostCommentsScreen({super.key, required this.post});

  final CommentController commentController = Get.put(CommentController());
  // final ReplyController replyController = Get.put(ReplyController());
  final focusedController = Get.put(CommentInputController());

  /// متحكم يتم استخدامه في صندوق ادخال الرد لكل تعليق حتى يتم الاحتفاظ بالقيمة
  final TextEditingController textInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    commentController.getPostComments(post.id);

    return RefreshIndicator(
      onRefresh: () => commentController.getPostComments(post.id),
      child: Scaffold(
        backgroundColor: const Color(0xFFEDF0F6),
        // appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  // show the post
                  Obx(() {
                    post.commentsCount = post.commentsCount +
                        commentController.sentCommentCounts.value;
                    return PostCardWidget(post: post);
                  }),

                  // show the post's comments
                  _buildPostCommentsWidget(),
                ],
              ),
            ),

            // صندوق ادخال التعليق
            Obx(
              () => focusedController.isAddCommentFocused.value
                  ? CommentInputWidget(
                      parentId: post.id,
                      hintText: "Write a comment",
                      textController:
                          textInputController, //commentController.commentTextEditingController,
                      onTapOutside: () {},
                      onSend: (content) {
                        commentController.submitSendCommentButton(
                            post.id, content);
                        textInputController.clear();
                      },
                      onPrefixIconPressed: () => commentController.pickImage(post.id),
                    )
                  : const SizedBox(),
            ),
          ],
        ),

        // floatingActionButton: FloatingActionButton(onPressed: () {
        // final CommentInputController con = Get.find();
        //   con.textFieldKey1.currentState?.didUpdateWidget(TextFormField(
        //     readOnly: true,
        //     // decoration: ,
        //   ));// didChange('قيمة جديدة للحقل الأول');
        //   //  // تحديث خصائص الـ TextFormField عند النقر على الزر
        //   //           con.formKey.currentState?.setState(() {
        //   //             con.formKey.currentState?.fields.child.
        //   //           }); [con.formKey.toString()]?.decoration =
        //   //               InputDecoration(
        //   //             labelText: 'النص المحدث',
        //   //             // يمكنك تعديل خصائص أخرى هنا
        //   //           );
        // },),
      ),
    );
  }

  Widget _buildPostCommentsWidget() {
    return Obx(
      () => commentController.commentsList.isNotEmpty ||
              commentController.sendingComments.isNotEmpty
          ? Column(
              children: [
                for (int i = 0; i < commentController.commentsList.length; i++)
                  Container(
                    margin: const EdgeInsets.only(top: 9),
                    padding: const EdgeInsets.only(top: 9),
                    decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.white))),
                    child: CommentWidget(
                      comment: commentController.commentsList[i],
                    ),
                  ),
                for (int i = 0;
                    i < commentController.sendingComments.length;
                    i++)
                  Container(
                    margin: const EdgeInsets.only(top: 9),
                    padding: const EdgeInsets.only(top: 9),
                    decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.white))),
                    child: commentController.sendingComments[i],
                  ),

                // عرض الزر الخاص بعرض المزيد من التعليقات
                if (post.commentsCount > PER_PAGE_COMMENT &&
                    commentController.commentsList.length < post.commentsCount)
                  _buildShowMoreCommentsButton(),

                // عرض شريط الانتظار حتى يكتمل جلب المزيد من البيانات
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: commentController.isRequestFinishWithoutData
                  ? const Center(child: Text("Not found comments"))
                  : AppUtil.addProgressIndicator(30),
            ),
    );
  }

  Widget _buildShowMoreCommentsButton() {
    int moreCommentCounts =
        post.commentsCount - commentController.commentsList.length;
    return AppUtil.buildShowMoreCommentsRepliesButton(
      moreCounts: moreCommentCounts,
      onTap: () => commentController.loadNextPageOfComments(post.id),
      isReply: false,
    );
  }
}
