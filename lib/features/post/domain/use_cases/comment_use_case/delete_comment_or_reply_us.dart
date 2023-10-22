import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteCommentOrReplyUseCase {
  final CommentRepository repository;

  DeleteCommentOrReplyUseCase(this.repository);

  Future<Either<Failure, Success>> call(int id) async {
    return await repository.deleteCommentOrReply(id);
  }
}