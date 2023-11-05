import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class FollowUserUseCase {
  final UserRepository repository;

  FollowUserUseCase(this.repository);

  Future<Either<Failure, Success>> call(int userId) async {
    return await repository.followUser(userId);
  }
}
