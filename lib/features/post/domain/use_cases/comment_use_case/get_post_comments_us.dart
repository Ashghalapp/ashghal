import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_post_comments_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/comment.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class GetPostCommentUseCase {
  final CommentRepository repository;

  GetPostCommentUseCase(this.repository);

  Future<Either<Failure, List<Comment>>> call(GetPostCommentsRequest request) async {
    return await repository.getPostComments(request);
  }
}