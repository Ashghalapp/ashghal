// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: type=lint
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/add_comment_or_reply_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_comment_replies_request%20copy.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_post_comments_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_user_comments_on_post_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_user_comments_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_user_replies_on_comment_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/update_comment_or_reply_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/comment.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/reply.dart';
import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';
import '../../../../core_api/success/success.dart';

abstract class CommentRepository {
  // Future<Either<Failure, List<Post>>> getCommentsAndReplies(PaginationRequest request);

  Future<Either<Failure, List<Comment>>> getPostComments(GetPostCommentsRequest request);
  
  Future<Either<Failure, List<Reply>>> getCommentReplies(GetCommentRepliesRequest request);
  
  Future<Either<Failure, List<Comment>>> getUserComments(GetUserCommentsRequest request);

  Future<Either<Failure, List<Comment>>> getUserCommentsOnPost(GetUserCommentsOnPostRequest request);

  Future<Either<Failure, List<Reply>>> getUserRepliesOnComment(GetUserRepliesOnCommentRequest request);

  Future<Either<Failure, Comment>> addComment(AddCommentRequest request);

  Future<Either<Failure, Reply>> addReply(AddReplyRequest request);

  Future<Either<Failure, Comment>> updateComment(UpdateCommentOrReplyRequest request);

  Future<Either<Failure, Reply>> updateReply(UpdateCommentOrReplyRequest request);

  Future<Either<Failure, Success>> deleteCommentOrReply(int id);

  Future<Either<Failure, Success>> deleteCommentOrReplyImage(int id);
}
//