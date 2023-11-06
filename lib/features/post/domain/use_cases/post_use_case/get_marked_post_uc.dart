import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';
import '../../repositories/post_repository.dart';

class GetMarkedPostUseCase {
  final PostRepository repository;

  GetMarkedPostUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call() async {
    return await repository.getMarkedPosts();
  }
}