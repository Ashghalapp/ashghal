import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/add_address_to_user_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class AddAddrressToUserUseCase {
  final UserRepository repository;

  AddAddrressToUserUseCase(this.repository);

  Future<Either<Failure, UserModel>> call(AddAddressToUserRequest request) async {
    return await repository.addAddressToUser(request);
  }
}
