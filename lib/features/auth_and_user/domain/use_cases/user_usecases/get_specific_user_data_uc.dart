import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetSpecificUserDataUseCase {
  final UserRepository repository;

  GetSpecificUserDataUseCase(this.repository);

  Future<Either<Failure, User>> call(int useId) async {
    return await repository.getSpecificUserData(useId);
  }
}
