import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';
import '../../../../core_api/success/success.dart';
import '../repositories/post_comment_repository.dart';

class DeletePostUseCase {
  final PostCommentRepository repository;

  DeletePostUseCase(this.repository);

  Future<Either<Failure, Success>> call(int id) async {
    return await repository.deletePost(id);
  }
}