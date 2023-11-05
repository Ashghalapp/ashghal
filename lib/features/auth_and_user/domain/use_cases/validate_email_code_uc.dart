import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/validate_email_code_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

class ValidateEmailCodeUseCase {
  final UserProviderRepository repository;

  ValidateEmailCodeUseCase(this.repository);

  Future<Either<Failure, Success>> call(ValidateEmailCodeRequest request) async {
    return await repository.validateEmailVerificationCode(request);
  }
}
