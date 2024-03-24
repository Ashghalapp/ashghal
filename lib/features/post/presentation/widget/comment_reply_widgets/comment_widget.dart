import 'package:ashghal_app_frontend/core/util/bottom_sheet_util.dart';
import 'package:ashghal_app_frontend/core/util/dialog_util.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/comment.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/localization/app_localization.dart';
import '../../../../../core/util/app_util.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../getx/reply_controller.dart';
import '../functoin_widgets/functions_widgets.dart';
import 'comment_reply_widget_abstract.dart';
import 'reply_widget.dart';

///////////////////////////Comment Widget ////////////////////////
class CommentWidget extends CommentReplyWidgetAbstract {
  final Comment comment;
  CommentWidget({
    super.key,
    required this.comment,
    super.status,
    super.setCurrentTime,
  }) : super(
          userId: int.parse(comment.basicUserData['id'].toString()),
          userName: comment.basicUserData['name'].toString(),
          userImageUrl: comment.basicUserData['image_url'].toString(),
          content: comment.content,
          imageUrl: comment.imageUrl,
          time: comment.createdAt,
        );
  final CommentController commentController = Get.find<CommentController>();
  late ReplyController replyController;

  @override
  Widget onReplyTap() {
    replyController = Get.put(ReplyController(), tag: comment.id.toString());
    return showTextFieldToWriteReply(
      parentId: comment.id,
      userData: comment.basicUserData,
      onTapOutside: () {
        printInfo(info: "Implement onTapOutSide Function");
        isAddReply.value = !isAddReply.value;
        focusedController.isAddCommentFocused.value = !isAddReply.value;
        isNextTapToHideField = true;
      },
      onSend: (content) {
        replyController.submitAddReplyButton(comment.id, comment.id, content);
      },
      onImageIconTap: (String content, String imagePath) async {
        print("<<<<<<<<<<<<<<<<<<<<$imagePath>>>>>>>>>>>>>>>>>>>>");
        replyController.submitAddReplyButton(comment.id, comment.id, content,
            imagePath: imagePath);
        Get.back();
        // _getReplyInstance(parentCommentId, content,replyToCommentId, imagePath: imagePath));
      },
    );
  }

  @override
  void onSendingFaildTap() {
    commentController.submitSendCommentButton(
      comment.parentPostId,
      comment.content,
      imagePath: imageUrl,
      widgetCreatedAt: super.currentTimeWidget,
    );
  }

  /// زر عرض الردود للتعليقات فقط ولا يظهر للردود على التعليقات
  @override
  Widget? buildShowRepliesButton() {
    // تهيئة المتحكم في الاماكن التي تحتاج الى استخدام هذه المتحكم فقط وذلك لزيادة الاداء
    replyController = Get.put(ReplyController(), tag: comment.id.toString());
    return Obx(
      () {
        int repliesCount =
            comment.repliesCount + replyController.sentRepliesCounts.value;
        return repliesCount > 0
            ? CustomTextAndIconAndCircleCounterButton(
                text: Text("Show Replies ", style: Get.textTheme.bodyMedium),
                onPressed: () {
                  showReplies.value = !showReplies.value;
                  if (showReplies.value) {
                    replyController.getCommentReplies(comment.id);
                  }
                },
                icon: const Icon(Icons.comment, size: 0),
                count: repliesCount.toString(),
              )
            : const SizedBox();
      },
    );
  }

  @override
  Widget? buildRepliesWidgets() {
    return replyController.repliesList.isNotEmpty ||
            replyController.sendingReplies.isNotEmpty
        ? _getRepliesWidgets()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: replyController.isRequestFinishWithoutData
                ? Text(AppLocalization.thereIsSomethingError)
                : AppUtil.addProgressIndicator(20),
          );
  }

  @override
  void onDelete() {
    DialogUtil.showConfirmDialog(
      title: AppLocalization.warning,
      message: AppLocalization.areYouSureToDeleteYourComment,
      onSubmit: () async {
        Get.back();
        commentController.submitDeleteCommentButton(comment.id);
      },
    );
  }

  @override
  void onEdit() {
     BottomSheetUtil.buildButtomSheetToEditField(
      title: AppLocalization.editYourComment,
      initialValue: comment.content,
      onSave: (newContent) async {
        if (await commentController.updateComment(comment.id, newContent)) {
          Get.back();
        }
      },
    );
  }

  Column _getRepliesWidgets() {
    return Column(
      children: [
        for (int i = 0; i < replyController.repliesList.length; i++) ...{
          Divider(color: Get.theme.dividerColor, thickness: 2),
          ReplyWidget(
            reply: replyController.repliesList[i],
            replyController: replyController,
          ),
        },
        for (int i = 0; i < replyController.sendingReplies.length; i++)
          ...{
            Divider(color: Get.theme.dividerColor, thickness: 2),
            replyController.sendingReplies[i]
          }.toList(),

        // عرض الزر الخاص بعرض المزيد من الردود
        if (comment.repliesCount > PER_PAGE_REPLIES &&
            replyController.repliesList.length < comment.repliesCount)
          _buildShowMoreRepliesButton(),

        // عرض شريط الانتظار حتى يكتمل جلب المزيد من البيانات
      ],
    );
  }

  Widget _buildShowMoreRepliesButton() {
    int moreCommentCounts =
        comment.repliesCount - replyController.repliesList.length;
    return PostCommentsFunctionWidgets.buildShowMoreTextButton(
      moreCounts: moreCommentCounts,
      onTap: () => replyController.loadNextPageOfCommentReplies(comment.id),
      isReply: true,
    );
  }
}
