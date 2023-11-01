import 'package:ashghal_app_frontend/core_api/api_constant.dart';
import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/post/data/models/comment_model.dart';
import 'package:ashghal_app_frontend/features/post/data/models/reply_model.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/add_comment_or_reply_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_comment_replies_request%20copy.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_post_comments_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_user_comments_on_post_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_user_comments_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_user_replies_on_comment_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/update_comment_or_reply_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/comment.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/reply.dart';

import '../../../../app_library/public_request/pagination_request.dart';

// لكل implement الكلاس الاساسي والي يحتوي العمليات الاساسية حتى يتم منه عمل
// تقنية مستخدمة حتى تمثل مصدر البيانات، وهكذا تسهل عملية التعديل وايضا التغيير
abstract class CommentRemoteDataSource {
  // Future< List<Post>>> getCommentsAndReplies(PaginationRequest request);

  Future<List<CommentModel>> getPostComments(GetPostCommentsRequest request);

  Future<List<ReplyModel>> getCommentReplies(GetCommentRepliesRequest request);

  Future<List<Comment>> getUserComments(GetUserCommentsRequest request);

  Future<List<Comment>> getUserCommentsOnPost(
      GetUserCommentsOnPostRequest request);

  Future<List<Reply>> getUserRepliesOnComment(
      GetUserRepliesOnCommentRequest request);

  Future<Comment> addComment(AddCommentRequest request);

  Future<Reply> addReply(AddReplyRequest request);

  Future<Comment> updateComment(UpdateCommentOrReplyRequest request);

  Future<Reply> updateReply(UpdateCommentOrReplyRequest request);

  Future<Success> deleteCommentOrReply(int id);

  Future<Success> deleteCommentOrReplyImage(int id);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  DioService dio = DioService();

  @override
  Future<Comment> addComment(AddCommentRequest request) async {
    print("<<<<<<<<<<<<<<${(await request.toJson()).fields}>>>>>>>>>>>>>>");
    return CommentModel.fromJson((await _sendRequest(
      method: "post",
      endpoint: ApiConstants.ADD_COMMENT_OR_REPLY,
      data: await request.toJson(),
    )).data);
  }

  @override
  Future<Reply> addReply(AddReplyRequest request) async {
    return ReplyModel.fromJson((await _sendRequest(
      method: "post",
      endpoint: ApiConstants.ADD_COMMENT_OR_REPLY,
      data: await request.toJson(),
    )).data);
  }

  @override
  Future<Success> deleteCommentOrReply(int id) async {
    return ServerSuccess((await _sendRequest(
      method: "delete",
      endpoint: "${ApiConstants.DELETE_COMMENT_OR_REPLY}$id",
    )).message);
  }

  @override
  Future<Success> deleteCommentOrReplyImage(int id) async {
    return ServerSuccess((await _sendRequest(
      method: "post",
      endpoint: "${ApiConstants.DELETE_COMMENT_OR_REPLY_IMAGE}$id",
    )).message);
  }

  @override
  Future<List<ReplyModel>> getCommentReplies(GetCommentRepliesRequest request) async {
    return ReplyModel.fromJsonList((await _sendRequest(
      method: "get",
      endpoint: ApiConstants.GET_COMMENT_REPLIES,
      data: request.toJson(),
    )).data);
  }

  @override
  Future<List<CommentModel>> getPostComments(PaginationRequest request) async {
    return CommentModel.fromJsonList((await _sendRequest(
      method: "get",
      endpoint: ApiConstants.GET_POST_COMMENTS,
      data: request.toJson(),
    )).data);
  }

  @override
  Future<List<Comment>> getUserComments(GetUserCommentsRequest request) async {
    return CommentModel.fromJsonList((await _sendRequest(
      method: "get",
      endpoint: ApiConstants.GET_USER_COMMENTS,
      data: request.toJson(),
    )).data);
    // ApiResponseModel response =
    //     await dio.get(ApiConstants.GET_USER_COMMENTS, request.toJson());
    // if (response.status) {
    //   print("::: S End getUserComments func in post_comment_remote_datasource");
    //   return CommentModel.fromJsonList(response.data);
    // }
    // throw AppException(
    //     ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<List<Comment>> getUserCommentsOnPost(GetUserCommentsOnPostRequest request) async {
    return CommentModel.fromJsonList((await _sendRequest(
      method: "get",
      endpoint: ApiConstants.GET_USER_COMMENTS_ON_POST,
      data: request.toJson(),
    )).data);
    // ApiResponseModel response =
    //     await dio.get(ApiConstants.GET_USER_COMMENTS_ON_POST, request.toJson());
    // if (response.status) {
    //   print(
    //       "::: S End getUserCommentsOnPost func in post_comment_remote_datasource");
    //   return CommentModel.fromJsonList(response.data);
    // }
    // throw AppException(
    //     ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<List<Reply>> getUserRepliesOnComment(GetUserRepliesOnCommentRequest request) async {
    return ReplyModel.fromJsonList((await _sendRequest(
      method: "get",
      endpoint: ApiConstants.GET_USER_REPLIES_ON_COMMENT,
      data: request.toJson(),
    )).data);
    // ApiResponseModel response = await dio.get(
    //     ApiConstants.GET_USER_REPLIES_ON_COMMENT, request.toJson());
    // if (response.status) {
    //   print(
    //       "::: S End getUserRepliesOnComment func in post_comment_remote_datasource");
    //   return ReplyModel.fromJsonList(response.data);
    // }
    // throw AppException(
    //     ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Comment> updateComment(UpdateCommentOrReplyRequest request) async {
    return CommentModel.fromJson((await _sendRequest(
      method: "post",
      endpoint: ApiConstants.UPDATE_COMMENT_OR_REPLY,
      data: request.toJson(),
    )).data);
    // ApiResponseModel response =
    //     await dio.post(ApiConstants.UPDATE_COMMENT_OR_REPLY, request.toJson());
    // if (response.status) {
    //   print("::: S End updateComment func in post_comment_remote_datasource");
    //   return CommentModel.fromJson(response.data);
    // }
    // throw AppException(
    //     ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Reply> updateReply(UpdateCommentOrReplyRequest request) async {
    return ReplyModel.fromJson((await _sendRequest(
      method: "post",
      endpoint: ApiConstants.UPDATE_COMMENT_OR_REPLY,
      data: request.toJson(),
    )).data);
    // ApiResponseModel response =
    //     await dio.get(ApiConstants.UPDATE_COMMENT_OR_REPLY, request.toJson());
    // if (response.status) {
    //   print("::: S End updateReply func in post_comment_remote_datasource");
    //   return ReplyModel.fromJson(response.data);
    // }
    // throw AppException(
    //     ServerFailure(message: response.message, errors: response.errors));
  }

  Future<ApiResponseModel> _sendRequest({required String method, required String endpoint, Object? data}) async{
    ApiResponseModel response;
    if (method == "get") {
      response = await dio.get(endpoint, data);
    } else if (method == "post") {
      response = await dio.post(endpoint, data);
    } else if (method == "delete") {
      response = await dio.delete(endpoint);
    } else{
      response = ApiResponseModel(status: false, message: "Not Specific method to send request");
    }
    
    if (response.status) {
      print("::: S End sendRequest func in comment_remote_datasource");
      return response;
    }
    print("::: F End sendRequest func in comment_remote_datasource: ${response.message}");
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }
}
