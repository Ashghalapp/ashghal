import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/user_requests.dart/update_user_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<Failure, UserModel>> call(UpdateUserRequest request) async {
    return await repository.updateUser(request);
  }
}
