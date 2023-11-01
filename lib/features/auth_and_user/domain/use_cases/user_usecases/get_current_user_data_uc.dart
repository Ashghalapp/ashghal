import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetCurrentUserDataUseCase {
  final UserRepository repository;

  GetCurrentUserDataUseCase(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.getCurrentUserData();
  }
}
