import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';

class SearchForPostsUseCase {
  final PostRepository repository;

  SearchForPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call(String data) async {
    return await repository.searchForPost(data);
  }
}