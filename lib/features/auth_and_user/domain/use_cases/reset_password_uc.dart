import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/reset_password_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

class ResetPasswordUseCase {
  final UserProviderRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, Success>> call(ResetPasswordRequest resetPasswordRequest) async {
    return await repository.resetPassword(resetPasswordRequest);
  }
}