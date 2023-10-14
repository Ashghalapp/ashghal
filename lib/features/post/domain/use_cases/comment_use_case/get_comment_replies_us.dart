import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_comment_replies_request%20copy.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/reply.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class GetCommentRepliesUseCase {
  final CommentRepository repository;

  GetCommentRepliesUseCase(this.repository);

  Future<Either<Failure, List<Reply>>> call(GetCommentRepliesRequest request) async {
    return await repository.getCommentReplies(request);
  }
}