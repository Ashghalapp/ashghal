//================================================================
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/localization/app_localization.dart';
import '../../../../../core/util/app_util.dart';
import '../../../domain/entities/reply.dart';
import '../../getx/reply_controller.dart';
import '../buttomsheet_widget.dart';
import 'comment_reply_widget_abstract.dart';

///////////////////////////Reply Widget ////////////////////////
class ReplyWidget extends CommentReplyWidgetAbstract {
  final Reply reply;
  final ReplyController replyController;

  ReplyWidget({
    super.key,
    // required this.parentCommentId,
    required this.reply,
    required this.replyController,
    super.status,
    super.setCurrentTime,
    // required this.onReply,
    // required this.resendFunction,
  }) : super(
          userId: int.parse(reply.basicUserData['id'].toString()),
          userName: reply.basicUserData['name'].toString(),
          userImageUrl: reply.imageUrl,
          content: reply.content,
          // replyController: replyController,
          imageUrl: reply.imageUrl,
        );

  // String getCommentOwnerName(int commentId){
  //   replyController.repliesList.where((comment) => comment.id == commentId);
  // }

  @override
  Widget onReplyTap() {
    getMentionUserData();
    return showTextFieldToWriteReply(
      parentId: reply.parentCommentId,
      userData: reply.basicUserData,
      onTapOutside: () {
        print("<<<<<<<<<<<<<Implement onTapOutSide Function>>>>>>>>>>>>>");
        isAddReply.value = !isAddReply.value;
        focusedController.isAddCommentFocused.value = !isAddReply.value;
        isNextTapToHideField = true;
      },
      onSend: (content) => replyController.submitAddReplyButton(
          reply.parentCommentId, reply.id, content),
      onImageIconTap: (String content, String imagePath) async {
        print("<<<<<<<<<<<<<<<<<<<<$imagePath>>>>>>>>>>>>>>>>>>>>");
        replyController.submitAddReplyButton(
          reply.parentCommentId,
          reply.id,
          content,
          imagePath: imagePath,
        );
        Get.back();
        // _getReplyInstance(parentCommentId, content,replyToCommentId, imagePath: imagePath));
      },
    );
  }

  @override
  void onSendingFaildTap() {
    replyController.submitAddReplyButton(
      reply.parentCommentId,
      reply.replyToCommentId,
      reply.content,
      imagePath: imageUrl,
      widgetCreatedAt: super.currentTimeWidget,
    );
  }

  @override
  void onDelete() {
    AppUtil.buildDialog(
      AppLocalization.warning,
      AppLocalization.areYouSureToDeleteYourReply,
      () async {
        Get.back();
        replyController.submitDeleteReplyButton(reply.id);
      },
    );
  }

  @override
  void onEdit() {
    buildButtomSheetToEditField(
      title: AppLocalization.editYourReply,
      initialValue: reply.content,
      onSendFunc: (newContent) async {
        if (await replyController.updateReply(reply.id, newContent)) {
          Get.back();
        }
      },
    );
  }

  @override
  Map<String, dynamic>? getMentionUserData() {
    Map<String, dynamic>? userData =
        replyController.getMentionUserData(reply.replyToCommentId);
    return userData;
  }
}
