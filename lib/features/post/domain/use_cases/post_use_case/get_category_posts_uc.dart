import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';
import '../../Requsets/post_request/get_category_posts_request.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';

class GetCategoryPostsUseCase {
  final PostRepository repository;

  GetCategoryPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call(GetCategoryPostsRequest request) async {
    return await repository.getCategoryPosts(request);
  }
}