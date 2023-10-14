import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';
import '../../Requsets/post_request/get_user_posts_request.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';

class GetUserPostsUseCase {
  final PostRepository repository;

  GetUserPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call(GetUserPostsRequest request) async {
    return await repository.getUserPosts(request);
  }
}