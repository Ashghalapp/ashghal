// import 'package:get/get.dart';

import 'package:dio/dio.dart';

/// comment and reply كلاس اساسي يحتوي على الخصائص المشتركة في طلبات الاضافة لـ
abstract class _AddCommentOrReplyRequestAbstract {
  final String content;
  final String? imagePath;
  final int parentId;
  final bool isComment;

  _AddCommentOrReplyRequestAbstract({
    required this.content,
    this.imagePath,
    required this.parentId,
    required this.isComment,
  });

  /// Map ارجاع البيانات على شكل
  Map<String, Object?> getCommonDataAsMap() {
    return {
      'content': content,
      'parent_id': parentId,
      'is_comment': isComment? 1: 0,
    };
  }
}

/// request that use to add new post
class AddCommentRequest extends _AddCommentOrReplyRequestAbstract {
  AddCommentRequest({
    required int postId,
    required super.content,
    super.imagePath,
  }) : super(parentId: postId, isComment: true);

   Future<FormData> toJson() async {
    MultipartFile? imageFile;
    if (imagePath != null) {
      imageFile = await MultipartFile.fromFile(imagePath!);
    }

    print(">>>>>>>>>>>>>>>>${super.getCommonDataAsMap()}");
    print("????????????????????${FormData.fromMap({
      ...(super.getCommonDataAsMap()),
      if (imageFile != null) 'image': imageFile,
    }, ListFormat.multiCompatible)}");
    return FormData.fromMap({
      ...(super.getCommonDataAsMap()),
      if (imageFile != null) 'image': imageFile,
    }, ListFormat.multiCompatible);
    //   {
    //     ...super.toJson(),
    //     'reply_to_comment_id': replyToUserId,
    //   };
    // }
  }
}

/// request that use to update post
class AddReplyRequest extends _AddCommentOrReplyRequestAbstract {
  final int replyToUserId;
  AddReplyRequest({
    required int commentId,
    required super.content,
    super.imagePath,
    required this.replyToUserId,
  }) : super(parentId: commentId, isComment: false);

  Future<FormData> toJson() async {
    MultipartFile? imageFile;
    if (imagePath != null) {
      imageFile = await MultipartFile.fromFile(imagePath!);
    }
    return FormData.fromMap({
      ...(super.getCommonDataAsMap()),
      if (imageFile != null) 'image': imageFile,
      'reply_to_comment_id': replyToUserId,
    }, ListFormat.multiCompatible);
    //   {
    //     ...super.toJson(),
    //     'reply_to_comment_id': replyToUserId,
    //   };
    // }
  }
}
