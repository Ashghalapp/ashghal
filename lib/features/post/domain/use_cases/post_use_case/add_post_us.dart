import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';
import '../../Requsets/post_request/add_update_post_request.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';

class AddPostUseCase {
  final PostRepository repository;

  AddPostUseCase(this.repository);

  Future<Either<Failure, Post>> call(AddPostRequest request) async {
    return await repository.addPost(request);
  }
}