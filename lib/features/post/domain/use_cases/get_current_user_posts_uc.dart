import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';
import '../Requsets/get_posts_request.dart';
import '../entities/post.dart';
import '../repositories/post_comment_repository.dart';

class GetCurrentUserPostsUseCase {
  final PostCommentRepository repository;

  GetCurrentUserPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call(GetPostsRequest request) async {
    return await repository.getCurrentUserPosts(request);
  }
}