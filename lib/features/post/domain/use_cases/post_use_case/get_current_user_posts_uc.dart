import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';
import '../../Requsets/pagination_request.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';

class GetCurrentUserPostsUseCase {
  final PostRepository repository;

  GetCurrentUserPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call(PaginationRequest request) async {
    return await repository.getCurrentUserPosts(request);
  }
}