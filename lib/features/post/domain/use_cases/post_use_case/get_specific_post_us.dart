import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';

class GetSpecificPostUseCase {
  final PostRepository repository;

  GetSpecificPostUseCase(this.repository);

  Future<Either<Failure, Post>> call(int postId) async {
    return await repository.getSpecificPost(postId);
  }
}