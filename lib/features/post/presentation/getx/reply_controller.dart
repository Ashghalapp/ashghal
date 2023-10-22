import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/add_comment_or_reply_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_comment_replies_request%20copy.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/reply.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/add_reply_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/get_comment_replies_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/update_reply_us.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app_library/app_data_types.dart';
import '../../../../core/services/dependency_injection.dart' as di;
import '../../../../core/util/app_util.dart';
import '../../domain/Requsets/comment_request/update_comment_or_reply_request.dart';
import '../widget/comment_reply_widgets/reply_widget.dart';
import '../widget/display_sending_image_widget.dart';

// ignore: constant_identifier_names
const PER_PAGE_REPLIES = 5;

class ReplyController extends GetxController {
  // متغير يحمل قيمة الصفحة من البوستات التي سيتم طلبها من قاعدة البيانات
  int pageNumber = 1;

  // التي سيتم عرضها مباشرة في الشاشة comments متغير سيحمل الـ
  RxList<Reply> repliesList = <Reply>[].obs;

  // قائمة تحتوي على الردود الجاري ارسالها لتسهيل التحكم بالردود المرسلة وعرضها
  RxList<ReplyWidget> sendingReplies = <ReplyWidget>[].obs;

  bool isRequestFinishWithoutData = false;

  // متغير يمثل عدد التعليقات التي يتم اضافتها وذلك حتى يتم التحكم
  // بعدد التعليقات للبوست عند اضافة تعليقات
  RxInt sentRepliesCounts = 0.obs;

  final GetCommentRepliesUseCase _getCommentRepliesUS = di.getIt();
  Future<void> getCommentReplies(int commentId) async {
    pageNumber = 1;
    final result = _getCommentRepliesUS.call(
      GetCommentRepliesRequest(
          commentId: commentId,
          pageNumber: pageNumber,
          perPage: PER_PAGE_REPLIES),
    );
    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      isRequestFinishWithoutData = true;
      repliesList.value = [];
    }, (replies) {
      // sentRepliesCounts.value = 0;
      isRequestFinishWithoutData = replies.isEmpty;
      repliesList.value = replies;
      printInfo(info: "<<<<<< Done get Post comments >>>>>>");
    });
  }

  Future<void> loadNextPageOfCommentReplies(int commentId) async {
    if (await NetworkInfoImpl().isConnected) {
      printInfo(info: "Call loadNextPageOfComments");
      pageNumber++;
      final result = _getCommentRepliesUS.call(GetCommentRepliesRequest(
          commentId: commentId,
          pageNumber: pageNumber,
          perPage: PER_PAGE_REPLIES));
      (await result).fold((failure) {
        AppUtil.hanldeAndShowFailure(failure);
      }, (comments) {
        repliesList.addAll(comments);
        printInfo(info: ">>>>>>Done get page $pageNumber of replies>>>>>");
      });
    } else {
      AppUtil.showMessage(
          AppLocalization.noInternet, Get.theme.colorScheme.error);
    }
  }

  /// function to get object of Comment class by only post id and content
  Reply _getReplyInstance(int parentId, String content, int replyToCommentId,
      {String? imagePath}) {
    //  Map<String, dynamic>? currentUserData= SharedPref.getCurrentUserData();
    // if (currentUserData == null){
    //   Get.offAllNamed(AppRoutes.logIn);
    // }
    Map<String, dynamic>? currentUserData= SharedPref.getCurrentUserBasicData();
    return Reply(
      id: 0,
      parentCommentId: parentId,
      content: content,
      imageUrl: imagePath,
      basicUserData: currentUserData,
      replyToCommentId: replyToCommentId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// function to change the status of comment widge
  void _replaceSendingReplyWidgetStatus({
    required DateTime widgetTime,
    required Reply reply,
    required CommentStatus status,
  }) {
    // remove tha faild sending widget to replace it with sending widget
    sendingReplies
        .removeWhere((element) => element.currentTimeWidget == widgetTime);
    // var replyControllerOfWidget= sendingReplies[replyWidgetIndex].replyController;
    // sendingReplies.removeAt(replyWidgetIndex);

    sendingReplies.add(ReplyWidget(
      key: GlobalObjectKey(widgetTime),
      reply: reply,
      status: status,
      setCurrentTime: widgetTime,
      replyController: this,
    ));
    SchedulerBinding.instance.addPostFrameCallback(
      (_) =>
          Scrollable.ensureVisible(GlobalObjectKey(widgetTime).currentContext!),
    );
  }

  /// function to submit the event of send reply button
  Future<void> submitAddReplyButton(
      int commentId, int replyToCommentId, String content,
      {String? imagePath, DateTime? widgetCreatedAt}) async {
    Get.focusScope?.unfocus();
    if (content.isNotEmpty && await NetworkInfoImpl().isConnected) {
      Reply replyToSend = _getReplyInstance(
          commentId, content, replyToCommentId,
          imagePath: imagePath);

      // give the widget current datetime if the comment sending to first time
      // to controll it easily
      widgetCreatedAt = widgetCreatedAt ?? DateTime.now();

      // remove tha faild sending widget to replace it with sending widget
      _replaceSendingReplyWidgetStatus(
        widgetTime: widgetCreatedAt,
        reply: replyToSend,
        status: CommentStatus.sending,
      );

      sendReply(replyToSend, widgetCreatedAt: widgetCreatedAt);
    } else {
      printInfo(info: "Not connected to enternet");
      AppUtil.showMessage(
          AppLocalization.noInternet, Get.theme.colorScheme.error);
    }
  }

  /// function to send the reply data to api
  Future<void> sendReply(Reply replyToSend, {DateTime? widgetCreatedAt}) async {
    final AddReplyUseCase addComment = di.getIt();
    final result = addComment.call(AddReplyRequest(
      commentId: replyToSend.parentCommentId,
      content: replyToSend.content,
      replyToUserId: replyToSend.replyToCommentId,
      imagePath: replyToSend.imageUrl,
    ));
    sentRepliesCounts.value++;
    (await result).fold((failure) {
      // remove tha sending widget to replace it with faild sending widget
      _replaceSendingReplyWidgetStatus(
        widgetTime: widgetCreatedAt!,
        reply: replyToSend,
        status: CommentStatus.faild,
      );
      AppUtil.hanldeAndShowFailure(failure);
    }, (comment) {
      // remove tha sending widget to replace it with sent widget
      sendingReplies.removeWhere(
          (element) => element.currentTimeWidget == widgetCreatedAt);

      repliesList.add(comment);
      printInfo(info: "<<<<< Done add reply >>>>>>");
    });
  }

  Future<bool> updateReply(int id, String content) async {
    UpdateReplyUseCase updateCommentUS = di.getIt();
    final result = updateCommentUS
        .call(UpdateCommentOrReplyRequest(id: id, content: content));

    EasyLoading.show(status: AppLocalization.loading);
    bool isUpdated = (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      return false;
    }, (reply) {
      final commentIndex =
          repliesList.indexWhere((element) => element.id == id);
      if (commentIndex != -1) {
        repliesList[commentIndex] = reply;
      }
      AppUtil.showMessage(AppLocalization.success, Colors.green);
      printInfo(info: "<<<<< Done delete comment >>>>>>");
      return true;
    });
    EasyLoading.dismiss();
    return isUpdated;
  }

  Future<bool> submitDeleteReplyButton(int replyId) async {
    if (await CommentController().deleteCommentOrReply(replyId)) {
      repliesList.removeWhere((element) => element.id == replyId);
      return true;
    }
    return false;
  }

  Map<String, dynamic>? getMentionUserData(int mentionReplyId) {
    int mentionReplyIndex =
        repliesList.indexWhere((reply) => reply.id == mentionReplyId);
    if (mentionReplyIndex == -1) return null;
    return {
      'id': repliesList[mentionReplyIndex].basicUserData['id'],
      'name': repliesList[mentionReplyIndex].basicUserData['name']
    };
  }

  Future pickImage(int parentCommentId, int replyToCommentId) async {
    final imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Get.to(
        () => DisplaySendingImageWidget(
          imageUrl: pickedFile.path,
          onSend: (String content, String imagePath) async {
            print("<<<<<<<<<<<<<<<<<<<<$imagePath>>>>>>>>>>>>>>>>>>>>");
            submitAddReplyButton(parentCommentId, replyToCommentId, content,
                imagePath: imagePath);
            Get.back();
            // _getReplyInstance(parentCommentId, content,replyToCommentId, imagePath: imagePath));
          },
        ),
      );
    }
  }
}
