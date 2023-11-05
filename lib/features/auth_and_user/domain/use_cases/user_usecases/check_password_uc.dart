import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class CheckPasswordUseCase {
  final UserRepository repository;

  CheckPasswordUseCase(this.repository);

  Future<Either<Failure, bool>> call(String password) async {
    return await repository.checkPassword(password);
  }
}
