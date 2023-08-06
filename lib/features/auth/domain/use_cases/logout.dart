import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

class LogoutUseCase {
  final UserProviderRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, Success>> call() async {
    return await repository.logout();
  }
}
