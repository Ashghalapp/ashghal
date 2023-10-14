import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/add_comment_or_reply_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_post_comments_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/update_comment_or_reply_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/add_comment_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/delete_comment_or_reply_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/get_post_comments_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/update_comment_us.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/display_sending_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app_library/app_data_types.dart';
import '../../domain/entities/comment.dart';
import '../../../../core/services/dependency_injection.dart' as di;
import '../widget/comment_reply_widgets/comment_widget.dart';

// ignore: constant_identifier_names
const int PER_PAGE_COMMENT = 5;

class CommentController extends GetxController {
  // late final TextEditingController commentTextEditingController;

  // متغير يحمل قيمة الصفحة من البوستات التي سيتم طلبها من قاعدة البيانات
  int pageNumber = 1;

  // التي سيتم عرضها مباشرة في الشاشة comments متغير سيحمل الـ
  RxList<Comment> commentsList = <Comment>[].obs;

  //
  RxList<CommentWidget> sendingComments = <CommentWidget>[].obs;

  // variable to decide if the request gets data or finish with no data
  bool isRequestFinishWithoutData = false;

  // متغير يمثل عدد التعليقات التي يتم اضافتها وذلك حتى يتم التحكم
  // بعدد التعليقات للبوست عند اضافة تعليقات
  RxInt sentCommentCounts = 0.obs;

  /// للتحكم في تمرير الشاشة
  final commentScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // commentTextEditingController = TextEditingController();

    isRequestFinishWithoutData = false;
  }

  /// function to refresh the posts and get it from api
  void refreshComments(int postId) {
    commentsList.value = [];
    isRequestFinishWithoutData = false;
    getPostComments(postId);
  }

  final GetPostCommentUseCase _getPostCommentsUS = di.getIt();

  /// function to get the post comments from api
  Future<void> getPostComments(int postId) async {
    pageNumber = 1;
    final result = _getPostCommentsUS.call(GetPostCommentsRequest(
        postId: postId, pageNumber: pageNumber, perPage: PER_PAGE_COMMENT));
    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      isRequestFinishWithoutData = true;
      commentsList.value = [];
    }, (comments) {
      isRequestFinishWithoutData = comments.isEmpty;
      commentsList.value = comments;
      sentCommentCounts.value = 0;
      printInfo(info: ">>>>>>Done get Post comments>>>>>");
    });
  }

  Future<void> loadNextPageOfComments(int postId) async {
    if (await NetworkInfoImpl().isConnected) {
      printInfo(info: "Call loadNextPageOfComments");
      pageNumber++;
      final result = _getPostCommentsUS.call(GetPostCommentsRequest(
          postId: postId, pageNumber: pageNumber, perPage: PER_PAGE_COMMENT));
      (await result).fold((failure) {
        AppUtil.hanldeAndShowFailure(failure);
      }, (comments) {
        commentsList.addAll(comments);
        printInfo(info: ">>>>>>Done get page $pageNumber of comments>>>>>");
      });
    } else {
      AppUtil.showMessage(
          AppLocalization.noInternet, Get.theme.colorScheme.error);
    }
  }

  List<Comment> filterComments(List<Comment> comments) {
    String currentUserId =
        SharedPref.getCurrentUserData()['id']?.toString() ?? "";
    for (var element in comments) {
      if (element.basicUserData['id'] == currentUserId) {
        comments.insert(0, element);
        comments.remove(element);
      }
    }
    return comments;
  }

  /// function to get object of Comment class by only post id and content
  Comment _getCommentInstance(int postId, String content, {String? imagepath}) {
    return Comment(
      id: 0,
      parentPostId: postId,
      content: content,
      imageUrl: imagepath,
      basicUserData: SharedPref.getCurrentUserData(),
      repliesCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// function to change the status of comment widge
  void _replaceSendingCommentWidgetStatus({
    required DateTime widgetTime,
    required Comment comment,
    required CommentStatus status,
  }) {
    // remove tha faild sending widget to replace it with sending widget
    sendingComments
        .removeWhere((element) => element.currentTimeWidget == widgetTime);

    sendingComments.insert(
      0,
      CommentWidget(
        comment: comment,
        status: status,
        setCurrentTime: widgetTime,
      ),
    );
  }

  /// function to submit the event of send commnet button
  Future<void> submitSendCommentButton(int postId, String content,
      {String? imagePath, DateTime? widgetCreatedAt}) async {
    Get.focusScope?.unfocus();
    if (content.isNotEmpty && await NetworkInfoImpl().isConnected) {
      Comment commentToSend =
          _getCommentInstance(postId, content, imagepath: imagePath);

      // give the widget current datetime if the comment sending to first time
      // to controll it easily
      widgetCreatedAt = widgetCreatedAt ?? DateTime.now();

      // remove tha faild sending widget to replace it with sending widget
      _replaceSendingCommentWidgetStatus(
          widgetTime: widgetCreatedAt,
          comment: commentToSend,
          status: CommentStatus.sending);

      // jump to top of scrren
      commentScrollController.animateTo(
        commentScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 5),
        curve: Curves.fastOutSlowIn,
      );

      sendComment(commentToSend, widgetCreatedAt: widgetCreatedAt);
      // commentTextEditingController.clear();
    } else {
      printInfo(info: "Not connected to enternet");
      AppUtil.showMessage(
          AppLocalization.noInternet, Get.theme.colorScheme.error);
    }
  }

  /// function to send the comment data to api
  Future<void> sendComment(Comment commentToSend,
      {DateTime? widgetCreatedAt}) async {
    final AddCommentUseCase addComment = di.getIt();
    final result = addComment.call(AddCommentRequest(
      postId: commentToSend.parentPostId,
      content: commentToSend.content,
      imagePath: commentToSend.imageUrl,
    ));

    (await result).fold((failure) {
      // remove tha sending widget to replace it with faild sending widget
      _replaceSendingCommentWidgetStatus(
        widgetTime: widgetCreatedAt!,
        comment: commentToSend,
        status: CommentStatus.faild,
      );
      AppUtil.hanldeAndShowFailure(failure);
    }, (comment) {
      // remove tha sending widget to replace it with sent widget
      sentCommentCounts.value++;
      sendingComments.removeWhere(
          (element) => element.currentTimeWidget == widgetCreatedAt);
      commentsList.insert(0, comment);
      printInfo(info: "<<<<< Done add comment >>>>>>");
    });
  }

  Future<bool> updateComment(int id, String content) async {
    UpdateCommentUseCase updateCommentUS = di.getIt();
    final result = updateCommentUS
        .call(UpdateCommentOrReplyRequest(id: id, content: content));

    EasyLoading.show(status: AppLocalization.loading);
    bool isUpdated = (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      return false;
    }, (comment) {
      final commentIndex =
          commentsList.indexWhere((element) => element.id == id);
      if (commentIndex != -1) {
        commentsList[commentIndex] = comment;
      }
      AppUtil.showMessage(AppLocalization.success, Colors.green);
      printInfo(info: "<<<<< Done delete comment >>>>>>");
      return true;
    });
    EasyLoading.dismiss();
    return isUpdated;
  }

  /// function to submit the event of delete commnet button
  Future<void> submitDeleteCommentButton(int commentId) async {
    if (await deleteCommentOrReply(commentId)) {
      commentsList.removeWhere((element) => element.id == commentId);
    }
  }

  /// function to delete the specific comment or reply
  Future<bool> deleteCommentOrReply(int commentId) async {
    final DeleteCommentOrReplyUseCase deleteComment = di.getIt();
    final result = await deleteComment.call(commentId);

    EasyLoading.show(status: AppLocalization.loading);
    bool isDeleted = result.fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      return false;
    }, (success) {
      AppUtil.showMessage(success.message, Colors.green);
      printInfo(info: "<<<<< Done delete comment >>>>>>");
      return true;
    });
    EasyLoading.dismiss();
    return isDeleted;
  }

  // void casheCommentToSend(Comment commentToSend) {
  //   String commentJson =
  //       jsonEncode((CommentModel.copyWith(commentToSend)).toJson());
  //   SharedPref.setString(sendingCommentCasheKey, commentJson);
  //   printError(info: commentJson);
  // }

  Future pickImage(int postId) async {
    final imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Get.to(() => DisplaySendingImageWidget(
            imageUrl: pickedFile.path,
            onSend: (String content, String imagePath) async {
              submitSendCommentButton(postId, content, imagePath: imagePath);
              Get.back();
              // sendComment(_getCommentInstance(postId, content, imagepath: imagePath));
            },
          ));
    }
  }

  List<Comment> commentsListToTry = [
    Comment(
      id: 1,
      content:
          "Great job on the coding task! The solution looks clean and well-structured. Great job on the coding task! The solution looks clean and well-structured.",
      basicUserData: {'id': 73, 'name': 'hezbr al-humaidi', 'image_url': null},
      repliesCount: 10,
      imageUrl:
          "https://i.pinimg.com/originals/84/45/e6/8445e6b18141aae9a9814cebe229e36c.jpg",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      parentPostId: 1,
    ),
    Comment(
      id: 2,
      content: "Great job on the coding task!",
      basicUserData: {'id': 73, 'name': 'hezbr al-humaidi', 'image_url': null},
      imageUrl:
          "https://i.pinimg.com/originals/93/13/71/9313716ba2961b4acddc05fa1d902dfe.jpg",
      repliesCount: 2,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      parentPostId: 1,
    ),
    Comment(
      id: 1,
      content:
          "Great job on the coding task! The solution looks clean and well-structured.",
      basicUserData: {'id': 73, 'name': 'hezbr al-humaidi', 'image_url': null},
      imageUrl:
          "https://i.pinimg.com/originals/93/13/71/9313716ba2961b4acddc05fa1d902dfe.jpg",
      repliesCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      parentPostId: 2,
    ),
    Comment(
      id: 1,
      content:
          "Great job on the coding task! The solution looks clean and well-structured.",
      basicUserData: {'id': 73, 'name': 'hezbr al-humaidi', 'image_url': null},
      imageUrl:
          "https://i.pinimg.com/originals/93/13/71/9313716ba2961b4acddc05fa1d902dfe.jpg",
      repliesCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      parentPostId: 3,
    ),
    Comment(
      id: 2,
      content:
          "I have a few suggestions for optimization. Let's discuss it further.",
      basicUserData: {'id': 73, 'name': 'hezbr al-humaidi', 'image_url': null},
      repliesCount: 5,
      imageUrl:
          "https://i.pinimg.com/originals/93/13/71/9313716ba2961b4acddc05fa1d902dfe.jpg",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      parentPostId: 2,
    ),
  ];
}
