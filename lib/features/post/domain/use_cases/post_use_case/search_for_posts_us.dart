import 'package:ashghal_app_frontend/app_library/public_request/search_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';

/// the search will be on title, desc, add_city, add_street, and add_desc
class SearchForPostsUseCase {
  final PostRepository repository;

  SearchForPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call(SearchRequest request) async {
    return await repository.searchForPosts(request);
  }
}