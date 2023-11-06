import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/post_request/mark_unmark_post_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';
import '../../repositories/post_repository.dart';

class MarkPostUseCase {
  final PostRepository repository;

  MarkPostUseCase(this.repository);

  Future<Either<Failure, Success>> call(MarkUnmarkPostRequest request) async {
    return await repository.markPost(request);
  }
}