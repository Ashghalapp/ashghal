import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/post/data/data_sources/comment_remote_data_source.dart';
import 'package:ashghal_app_frontend/features/post/data/data_sources/post_local_data_source.dart';
import 'package:ashghal_app_frontend/features/post/data/models/comment_model.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/add_comment_or_reply_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_comment_replies_request%20copy.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_post_comments_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_user_comments_on_post_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_user_comments_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_user_replies_on_comment_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/update_comment_or_reply_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/comment.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/reply.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class CommentRepositoryImpl extends CommentRepository {
  CommentRemoteDataSource commentRemoteDS = CommentRemoteDataSourceImpl();
  PostCommentLocalDataSource postCommentLocalDS =
      PostCommentLocalDataSourceImpl();
  NetworkInfo networkInfo = NetworkInfoImpl();

  // @override
  // Future<Either<Failure, List<Post>>> getCommentsAndReplies(PaginationRequest request) async{
  //   try {
  //     if (await networkInfo.isConnected) {
  //       List<PostModel> posts = await postCommentRemoteDS.getAllPosts(request);
  //       postCommentLocalDS.cashePosts(posts);
  //       return Right(posts);
  //     } else {
  //       return Right(postCommentLocalDS.getCashedPosts());
  //     }
  //   } on AppException catch (e) {
  //     return Left(e.failure);
  //   } catch (e) {
  //     print(">>>>>>>>>>Exception in repository: $e");
  //     return Left(NotSpecificFailure(message: e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, Comment>> addComment(AddCommentRequest request) async {
    var result = await _handleErrors(() async {
      return await commentRemoteDS.addComment(request);
    });
    return result is Comment ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Reply>> addReply(AddReplyRequest request) async {
    var result = await _handleErrors(() async {
      return await commentRemoteDS.addReply(request);
    });
    return result is Reply ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Comment>> updateComment(
      UpdateCommentOrReplyRequest request) async {
    var result = await _handleErrors(() async {
      return await commentRemoteDS.updateComment(request);
    });
    return result is Comment ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Reply>> updateReply(
      UpdateCommentOrReplyRequest request) async {
    var result = await _handleErrors(() async {
      return await commentRemoteDS.updateReply(request);
    });
    return result is Reply ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, List<Comment>>> getPostComments(
      GetPostCommentsRequest request) async {
    try {
      if (await networkInfo.isConnected) {
        List<CommentModel> comments =
            await commentRemoteDS.getPostComments(request);
        postCommentLocalDS.cashePostComments(comments);
        return Right(comments);
      } else {
        return Right(postCommentLocalDS.getCashePostComments());
      }
    } on AppException catch (e) {
      return Left(e.failure);
    } catch (e) {
      print(">>>>>>>>>>Exception in repository: $e");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getUserComments(
      GetUserCommentsRequest request) async {
    var result = await _handleErrors(() async {
      return await commentRemoteDS.getUserComments(request);
    });
    return result is List<Comment> ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, List<Comment>>> getUserCommentsOnPost(
      GetUserCommentsOnPostRequest request) async {
    var result = await _handleErrors(() async {
      return await commentRemoteDS.getUserCommentsOnPost(request);
    });
    return result is List<Comment> ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, List<Reply>>> getCommentReplies(
      GetCommentRepliesRequest request) async {
    var result = await _handleErrors(() async {
      return await commentRemoteDS.getCommentReplies(request);
    });
    return result is List<Reply> ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, List<Reply>>> getUserRepliesOnComment(
      GetUserRepliesOnCommentRequest request) async {
    var result = await _handleErrors(() async {
      return await commentRemoteDS.getUserRepliesOnComment(request);
    });
    return result is List<Reply> ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Success>> deleteCommentOrReply(int id) async {
    var result = await _handleErrors(() async {
      return await commentRemoteDS.deleteCommentOrReply(id);
    });
    return result is Success ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Success>> deleteCommentOrReplyImage(int id) async {
    var result = await _handleErrors(() async {
      return await commentRemoteDS.deleteCommentOrReplyImage(id);
    });
    return result is Success ? Right(result) : Left(result);
  }

  Future _handleErrors(Function function) async {
    try {
      if (await networkInfo.isConnected) {
        return await function();
      }
      return OfflineFailure(message: ErrorString.OFFLINE_ERROR);
    } on AppException catch (e) {
      return (e.failure as ServerFailure);
    } catch (e) {
      print(">>>>>>>>>>Exception in repository: $e");
      return NotSpecificFailure(message: e.toString());
    }
  }
}
