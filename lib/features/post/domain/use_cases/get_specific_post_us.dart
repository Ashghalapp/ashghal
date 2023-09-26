import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';
import '../entities/post.dart';
import '../repositories/post_comment_repository.dart';

class GetSpecificPostUseCase {
  final PostCommentRepository repository;

  GetSpecificPostUseCase(this.repository);

  Future<Either<Failure, Post>> call(int postId) async {
    return await repository.getSpecificPost(postId);
  }
}