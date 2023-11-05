import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/register_user_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterUserWithEmailUseCase {
  final UserProviderRepository repository;

  RegisterUserWithEmailUseCase(this.repository);

  Future<Either<Failure, User>> call(RegisterUserRequest request) async {
    return await repository.registerUserWithEmail(request);
  }
}
