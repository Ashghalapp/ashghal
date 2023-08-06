import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';

class CheckEmailExistUseCase {
  final UserProviderRepository repository;

  CheckEmailExistUseCase(this.repository);

  Future<Either<Failure, bool>> call(String email) async {
    return await repository.checkEmailExist(email);
  }
}
