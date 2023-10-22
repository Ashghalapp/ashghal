import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/comment_request/update_comment_or_reply_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/reply.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/comment_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateReplyUseCase {
  final CommentRepository repository;

  UpdateReplyUseCase(this.repository);

  Future<Either<Failure, Reply>> call(UpdateCommentOrReplyRequest request) async {
    return await repository.updateReply(request);
  }
}