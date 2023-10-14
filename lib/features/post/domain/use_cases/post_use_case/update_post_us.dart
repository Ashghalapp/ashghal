import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';
import '../../Requsets/post_request/add_update_post_request.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';

class UpdatePostUseCase {
  final PostRepository repository;

  UpdatePostUseCase(this.repository);

  Future<Either<Failure, Post>> call(UpdatePostRequest request) async {
    return await repository.updatePost(request);
  }
}
