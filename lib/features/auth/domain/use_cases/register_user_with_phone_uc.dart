import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/register_user_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterUserWithPhoneUseCase {
  final UserProviderRepository repository;

  RegisterUserWithPhoneUseCase(this.repository);

  Future<Either<Failure, User>> call(RegisterUserRequest request) async {
    return await repository.registerUserWithPhone(request);
  }
}