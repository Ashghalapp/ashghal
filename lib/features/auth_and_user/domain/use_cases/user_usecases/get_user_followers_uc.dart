import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/get_user_followers_followings_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserFollowersUseCase {
  final UserRepository repository;

  GetUserFollowersUseCase(this.repository);

  Future<Either<Failure, List<User>>> call(GetUserFollowersFollowingsRequest request) async {
    return await repository.getUserFollowers(request);
  }
}
