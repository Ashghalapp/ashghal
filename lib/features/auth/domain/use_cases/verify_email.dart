import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/verify_email_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

class VerifyEmailUseCase {
  final UserProviderRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<Either<Failure, Success>> call(VerifyEmailRequest request) async {
    return await repository.verifyEmail(request);
  }
}
