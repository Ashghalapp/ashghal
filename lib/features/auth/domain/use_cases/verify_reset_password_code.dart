import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/reset_password_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

class VerifyResetPasswordCodeUseCase {
  final UserProviderRepository repository;

  VerifyResetPasswordCodeUseCase(this.repository);

  Future<Either<Failure, Success>> call(VerifyResetPasswordCodeRequest verifyResetPasswordCodeRequest) async {
    return await repository.verifyResetPasswordCode(verifyResetPasswordCodeRequest);
  }
}
