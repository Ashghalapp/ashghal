import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class ConvertProviderToClientUseCase {
  final UserRepository repository;

  ConvertProviderToClientUseCase(this.repository);

  Future<Either<Failure, UserModel>> call() async {
    return await repository.convertProviderToClient();
  }
}
