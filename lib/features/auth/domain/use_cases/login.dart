import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/login_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

import '../entities/user.dart';

class LoginUseCase {
  final UserProviderRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(LoginRequest loginRequest) async {
    return await repository.login(loginRequest);
  }
}
