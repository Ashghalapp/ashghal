import 'package:ashghal_app_frontend/app_library/public_request/search_request.dart';
import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/data/data_sources/user_remote_data_source.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/convert_user_to_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/get_user_followers_followings_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/update_user_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl implements UserRepository {
  UserRemoteDataSource userRemoteDS = UserRemoteDataSourceImpl();
  NetworkInfo networkInfo = NetworkInfoImpl();
  
  Future _handleErrors(Function function) async {
    try {
      if (await networkInfo.isConnected) {
        return await function();
      }
      print("<<<<<<<<<<<<<<<<<<<<<${await networkInfo.isConnected}>>>>>>>>>>>>>>>>>>>>>");
      return OfflineFailure(message: ErrorString.OFFLINE_ERROR);
    } on AppException catch (e) {
      return (e.failure as ServerFailure);
    } catch (e) {
      print(">>>>>>>>>>Exception in repository: $e");
      return NotSpecificFailure(message: e.toString());
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUserData() async {
    var result = await _handleErrors(userRemoteDS.getCurrentUserData);
    return result is User ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, User>> getSpecificUserData(int userId) async {
    var result = await _handleErrors(() => userRemoteDS.getSpecificUserData(userId));
    return result is User ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(UpdateUserRequest request) async {
    var result = await _handleErrors(() => userRemoteDS.updateUser(request));
    return result is UserModel ? Right(result) : Left(result);
  }  
  
  @override
  Future<Either<Failure, UserModel>> convertClientToProvider(ConvertClientToProviderRequest request) async {
    var result = await _handleErrors(() => userRemoteDS.convertClientToProvider(request));
    return result is UserModel ? Right(result) : Left(result);
  }  
  
  @override
  Future<Either<Failure, UserModel>> convertProviderToClient() async {
    var result = await _handleErrors(() => userRemoteDS.convertProviderToClient());
    return result is UserModel ? Right(result) : Left(result);
  } 

  @override
  Future<Either<Failure, bool>> checkPassword(String password) async {
    var result = await _handleErrors(() => userRemoteDS.checkPassword(password));
    return result is bool ? Right(result) : Left(result);
  } 

  @override
  Future<Either<Failure, Success>> changePassword(String newPassword) async {
    var result = await _handleErrors(() => userRemoteDS.changePassword(newPassword));
    return result is Success ? Right(result) : Left(result);
  }  
  
  @override
  Future<Either<Failure, List<User>>> getUserFollowers(GetUserFollowersFollowingsRequest request) async {
    var result = await _handleErrors(() => userRemoteDS.getUserFollowers(request));
    return result is List<User> ? Right(result): Left(result);
  }
  
  @override
  Future<Either<Failure, List<User>>> getUserFollowing(GetUserFollowersFollowingsRequest request) async {
    var result = await _handleErrors(() => userRemoteDS.getUserFollowing(request));
    return result is List<User> ? Right(result): Left(result);
  }

  @override
  Future<Either<Failure, Success>> followUser(int userId) async {
    var result = await _handleErrors(() => userRemoteDS.followUser(userId));
    return result is Success ? Right(result): Left(result);
  }  
  
  @override
  Future<Either<Failure, Success>> unfollowUser(int userId) async {
    var result = await _handleErrors(() => userRemoteDS.unfollowUser(userId));
    return result is Success ? Right(result): Left(result);
  }

  @override
  Future<Either<Failure, Success>> unfollowMe(int userId) async {
    var result = await _handleErrors(() => userRemoteDS.unfollowMe(userId));
    return result is Success ? Right(result): Left(result);
  }
  
  @override
  Future<Either<Failure, List<User>>> searchForUsers(SearchRequest request) async{
    var result = await _handleErrors(() async {
      return await userRemoteDS.searchForUsers(request);
    });
    return result is List<User> ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Success>> deleteUserImage() async{
    var result = await _handleErrors(() async {
      return await userRemoteDS.deleteUserImage();
    });
    return result is Success ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Success>> deleteAccount() async{
    var result = await _handleErrors(() async {
      return await userRemoteDS.deleteAccount();
    });
    return result is Success ? Right(result) : Left(result);
  }

}
