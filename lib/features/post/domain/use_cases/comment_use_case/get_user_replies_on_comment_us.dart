import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_user_replies_on_comment_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/reply.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserRepliesOnCommentsUseCase {
  final CommentRepository repository;

  GetUserRepliesOnCommentsUseCase(this.repository);

  Future<Either<Failure, List<Reply>>> call(GetUserRepliesOnCommentRequest request) async {
    return await repository.getUserRepliesOnComment(request);
  }
}