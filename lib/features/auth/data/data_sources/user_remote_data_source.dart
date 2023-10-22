import 'package:ashghal_app_frontend/core_api/api_constant.dart';
import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/user_requests.dart/update_user_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';

abstract class UserRemoteDataSource {
  Future<User> getCurrentUserData();

  Future<User> getSpecificUserData(int userId);

  Future<User> updateUser(UpdateUserRequest request);

  // Future<User> registerUserWithEmail(RegisterUserRequest request);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<User> getCurrentUserData() async {
    return UserModel.fromJson((await _sendRequest(
      method: 'get',
      endpoint: ApiConstants.GET_CURRENT_USER,
    ))
        .data);
  }

  @override
  Future<User> getSpecificUserData(int userId) async {
    return UserModel.fromJson((await _sendRequest(
      method: 'get',
      endpoint: "${ApiConstants.GET_SPECIFIC_USER}$userId",
    ))
        .data);
  }

  @override
  Future<User> updateUser(UpdateUserRequest request) async {
    return UserModel.fromJson((await _sendRequest(
            method: 'post',
            endpoint: ApiConstants.UPDATE_USER,
            data: await request.toJson()))
        .data);
  }

  Future<ApiResponseModel> _sendRequest(
      {required String method, required String endpoint, Object? data}) async {
    DioService dio = DioService();
    ApiResponseModel response;
    if (method == "get") {
      response = await dio.get(endpoint, data);
    } else if (method == "post") {
      response = await dio.post(endpoint, data);
    } else if (method == "delete") {
      response = await dio.delete(endpoint);
    } else {
      response = ApiResponseModel(
          status: false, message: "Not Specific method to send request");
    }

    if (response.status) {
      print("::: S End sendRequest func in comment_remote_datasource");
      return response;
    }
    print(
        "::: F End sendRequest func in comment_remote_datasource: ${response.message}");
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }
}
