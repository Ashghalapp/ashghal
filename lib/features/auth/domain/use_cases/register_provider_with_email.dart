import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/register_user_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/provider.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterProviderWithEmailUseCase {
  final UserProviderRepository repository;

  RegisterProviderWithEmailUseCase(this.repository);

  Future<Either<Failure, Provider>> call(RegisterProviderRequest request) async {
    return await repository.registerProviderWithEmail(request);
  }
}
