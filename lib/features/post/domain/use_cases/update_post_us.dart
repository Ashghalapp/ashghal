import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';
import '../Requsets/add_update_post_request.dart';
import '../entities/post.dart';
import '../repositories/post_comment_repository.dart';

class UpdatePostUseCase {
  final PostCommentRepository repository;

  UpdatePostUseCase(this.repository);

  Future<Either<Failure, Post>> call(UpdatePostRequest request) async {
    return await repository.updatePost(request);
  }
}
