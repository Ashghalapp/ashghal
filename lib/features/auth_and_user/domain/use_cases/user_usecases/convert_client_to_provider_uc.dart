import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/convert_user_to_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class ConvertClientToProviderUseCase {
  final UserRepository repository;

  ConvertClientToProviderUseCase(this.repository);

  Future<Either<Failure, UserModel>> call(ConvertClientToProviderRequest request) async {
    return await repository.convertClientToProvider(request);
  }
}
