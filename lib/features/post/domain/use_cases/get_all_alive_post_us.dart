
import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';
import '../Requsets/get_posts_request.dart';
import '../entities/post.dart';
import '../repositories/post_comment_repository.dart';

class GetAllAlivePostsUseCase {
  final PostCommentRepository repository;

  GetAllAlivePostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call(GetPostsRequest request) async {
    return await repository.getAllAlivePosts(request);
  }
}