import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/get_user_comments_on_post_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/comment.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserCommentsOnPostUseCase {
  final CommentRepository repository;

  GetUserCommentsOnPostUseCase(this.repository);

  Future<Either<Failure, List<Comment>>> call(GetUserCommentsOnPostRequest request) async {
    return await repository.getUserCommentsOnPost(request);
  }
}