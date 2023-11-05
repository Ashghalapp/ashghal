import 'dart:convert';

import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/post/data/models/comment_model.dart';
import 'package:ashghal_app_frontend/features/post/data/models/reply_model.dart';

// لكل implement الكلاس الاساسي والي يحتوي العمليات الاساسية حتى يتم منه عمل
// تقنية مستخدمة حتى تمثل مصدر البيانات، وهكذا تسهل عملية التعديل وايضا التغيير
abstract class CommentLocalDataSource {
  void cashePostComments(List<CommentModel> comments);

  List<CommentModel> getCashedPostComments();

  void casheCommentReplies(List<ReplyModel> replies);

  List<ReplyModel> getCashedCommentReplies();
}

class CommentLocalDataSourceImpl implements CommentLocalDataSource {
  DioService dio = DioService();
  static String postCommentsKey = "cached_post_comments";
  static String commentRepliesKey = "cached_comment_replies";

  @override
  void cashePostComments(List<CommentModel> comments) async {
    final commentsJson = comments
        .map<Map<String, dynamic>>((commentModel) => commentModel.toJson())
        .toList();
    _casheCommentsReplies(commentsJson, postCommentsKey);
    // var result =
    //     await SharedPref.setString(postCommentsKey, jsonEncode(commentsJson));
    // result
    //     ? print(
    //         "::::::::::::::::::::Done cashed post comments: ${jsonEncode(commentsJson)}::::::::::::::::::")
    //     : print(
    //         "::::::::::::::::::::Faild cashed post comments::::::::::::::::::");
  }

  @override
  List<CommentModel> getCashedPostComments() {
    final commentsJson = _getCashedCommentsReplies(postCommentsKey);
    List<CommentModel> comments =
        commentsJson.map((json) => CommentModel.fromJson(json)).toList();
    return comments;
    // final String? dataString = SharedPref.getString(postCommentsKey);
    // // print(":::::::::Post Comments Cashed are: $dataString");
    // if (dataString != null && dataString != "") {
    //   List commentsJson = jsonDecode(dataString);
    //   List<CommentModel> comments =
    //       commentsJson.map((json) => CommentModel.fromJson(json)).toList();
    //   return comments;
    // }
    // throw AppException(OfflineFailure(message: ErrorString.OFFLINE_ERROR));
  }

  @override
  void casheCommentReplies(List<ReplyModel> replies) async {
    final repliesJson = replies.map((reply) => reply.toJson()).toList();
    _casheCommentsReplies(repliesJson, commentRepliesKey);
    // var result =
    //     await SharedPref.setString(commentRepliesKey, jsonEncode(repliesJson));
    // result
    //     ? print(
    //         "::::::::::::::::::::Done cashed comment replies::::::::::::::::::")
    //     : print(
    //         "::::::::::::::::::::Faild cashed comment replies::::::::::::::::::");
  }

  @override
  List<ReplyModel> getCashedCommentReplies() {
    final repliesJson = _getCashedCommentsReplies(commentRepliesKey);
    List<ReplyModel> replies =
        repliesJson.map((json) => ReplyModel.fromJson(json)).toList();
    return replies;
    // print("::::::::::Get comment replies from cashe::::::::::::");
    // final String? dataString = SharedPref.getString(commentRepliesKey);
    // if (dataString != null && dataString != "") {
    //   List repliesJson = jsonDecode(dataString);
    //   List<ReplyModel> replies =
    //       repliesJson.map((json) => ReplyModel.fromJson(json)).toList();
    //   return replies;
    // }
    // throw AppException(OfflineFailure(message: ErrorString.OFFLINE_ERROR));
  }

  // ================== helper fnctions ===================================
  void _casheCommentsReplies(
      List<Map<String, dynamic>> data, String key) async {
    // List commentsJson = comments.map((comment) => comment.toJson()).toList();
    var result = await SharedPref.setString(key, jsonEncode(data));
    result
        ? print("::::::::::::::Done cashe Comments::::::::::::::")
        : print("::::::::::::::Faild cashed Comment:::::::::::::");
  }

  List<Map<String, dynamic>> _getCashedCommentsReplies(String key) {
    print("::::::::::: Get comments/replies from cashe:::::::::::::::");
    final String? dataString = SharedPref.getString(key);
    if (dataString != null && dataString != "") {
      final dataList = jsonDecode(dataString);
      // List<CommentModel> comments =
      //     commentsJson.map((json) => CommentModel.fromJson(json)).toList();
      return dataList;
    }
    throw AppException(OfflineFailure(message: ErrorString.OFFLINE_ERROR));
  }
}
