import 'package:ashghal_app_frontend/app_library/public_request/search_request.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/convert_user_to_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/get_user_followers_followings_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/update_user_request.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/user_model.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getCurrentUserData();

  Future<Either<Failure, User>> getSpecificUserData(int userId);

  Future<Either<Failure, UserModel>> updateUser(UpdateUserRequest request);
  
  Future<Either<Failure, UserModel>> convertClientToProvider(ConvertClientToProviderRequest request);
  
  Future<Either<Failure, UserModel>> convertProviderToClient();
  
  Future<Either<Failure, bool>> checkPassword(String password);
  
  Future<Either<Failure, Success>> changePassword(String newPassword);

  Future<Either<Failure, List<User>>> getUserFollowers(GetUserFollowersFollowingsRequest request);

  Future<Either<Failure, List<User>>> getUserFollowing(GetUserFollowersFollowingsRequest request);

  Future<Either<Failure, Success>> followUser(int userId);

  Future<Either<Failure, Success>> unfollowUser(int userId);

  Future<Either<Failure, Success>> unfollowMe(int userId);

  Future<Either<Failure, List<User>>> searchForUsers(SearchRequest request);

  Future<Either<Failure, Success>> deleteUserImage();
  
  Future<Either<Failure, Success>> deleteAccount();

}
