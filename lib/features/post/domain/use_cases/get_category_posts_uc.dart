import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';
import '../Requsets/get_category_posts_request.dart';
import '../entities/post.dart';
import '../repositories/post_comment_repository.dart';

class GetCategoryPostsUseCase {
  final PostCommentRepository repository;

  GetCategoryPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call(GetCategoryPostsRequest request) async {
    return await repository.getCategoryPosts(request);
  }
}