import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/features/auth/data/data_sources/user_remote_data_source.dart';
import 'package:ashghal_app_frontend/features/auth/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/user_requests.dart/update_user_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl implements UserRepository {
  UserRemoteDataSource userRemoteDS = UserRemoteDataSourceImpl();
  NetworkInfo networkInfo = NetworkInfoImpl();

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

  Future _handleErrors(Function function) async {
    try {
      if (await networkInfo.isConnected) {
        return await function();
      }
      return OfflineFailure(message: ErrorString.OFFLINE_ERROR);
    } on AppException catch (e) {
      return (e.failure as ServerFailure);
    } catch (e) {
      print(">>>>>>>>>>Exception in repository: $e");
      return NotSpecificFailure(message: e.toString());
    }
  }
  
  
}
