import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';
import '../../../../../app_library/public_request/pagination_request.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';

class GetRecentPostsUseCase {
  final PostRepository repository;

  GetRecentPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call(PaginationRequest request) async {
    return await repository.getRecentPosts(request);
  }
}
