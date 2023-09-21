import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/check_email_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';

class CheckEmailUseCase {
  final UserProviderRepository repository;

  CheckEmailUseCase(this.repository);

  Future<Either<Failure, Success>> call(CheckEmailRequest request) async {
    return await repository.checkEmail(request);
  }
}
