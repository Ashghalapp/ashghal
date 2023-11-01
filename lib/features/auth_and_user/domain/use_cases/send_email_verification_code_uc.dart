import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

/// عملية تستخدم لارسال الكود الى الايميل عند عند القيام بتغيير ايميل المستخدم 
class SendEmailVerificationCodeUseCase {
  final UserProviderRepository repository;

  SendEmailVerificationCodeUseCase(this.repository);

  Future<Either<Failure, Success>> call(String email) async {
    return await repository.sendEmailVerificationCode(email);
  }
}
