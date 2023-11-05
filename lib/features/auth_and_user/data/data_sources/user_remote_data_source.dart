import 'package:ashghal_app_frontend/app_library/public_request/search_request.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core_api/api_constant.dart';
import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/add_address_to_user_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/convert_user_to_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/get_user_followers_followings_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/update_user_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';

abstract class UserRemoteDataSource {
  Future<User> getCurrentUserData();

  Future<User> getSpecificUserData(int userId);

  Future<User> updateUser(UpdateUserRequest request);

  Future<User> convertClientToProvider(ConvertClientToProviderRequest request);

  Future<User> convertProviderToClient();
  
  Future<bool> checkPassword(String password);

  Future<Success> changePassword(String newPassword);

  Future<List<User>> getUserFollowers(GetUserFollowersFollowingsRequest request);

  Future<List<User>> getUserFollowing(GetUserFollowersFollowingsRequest request);

  Future<Success> followUser(int userId);

  Future<Success> unfollowUser(int userId);

  /// cancel user from following you (current user)
  Future<Success> unfollowMe(int userId);

  Future<List<UserModel>> searchForUsers(SearchRequest request);

  Future<Success> deleteUserImage();

  Future<Success> deleteAccount();

  Future<UserModel> addAddressToUser(AddAddressToUserRequest request);

  // Future<User> registerUserWithEmail(RegisterUserRequest request);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<User> getCurrentUserData() async {
    final currentUser = UserModel.fromJson((await _sendRequest(
      method: 'get',
      endpoint: ApiConstants.GET_CURRENT_USER,
    )).data);
    SharedPref.setCurrentUserData(currentUser);
    return currentUser;
  }

  @override
  Future<User> getSpecificUserData(int userId) async {
    return UserModel.fromJson((await _sendRequest(
      method: 'get',
      endpoint: "${ApiConstants.GET_SPECIFIC_USER}$userId",
    )).data);
  }

  @override
  Future<User> updateUser(UpdateUserRequest request) async {
    
    return UserModel.fromJson((await _sendRequest(
      method: 'post',
      endpoint: ApiConstants.UPDATE_USER,
      data: await request.toJson(),
    )).data);
  }
 
  @override
  Future<User> convertClientToProvider(ConvertClientToProviderRequest request) async {
    return UserModel.fromJson((await _sendRequest(
      method: 'post',
      endpoint: ApiConstants.CONVERT_CLIENT_TO_PROVIDER,
      data: request.toJson(),
    )).data);
  }

  @override
  Future<User> convertProviderToClient() async {
    return UserModel.fromJson((await _sendRequest(
      method: 'post',
      endpoint: ApiConstants.CONVERT_PROVIDER_TO_CLIENT,
    )).data);
  }

  @override
  Future<Success> changePassword(String newPassword) async {
    return ServerSuccess((await _sendRequest(
      method: 'post',
      endpoint: ApiConstants.CHANGE_PASSWORD,
      data: {'new_password': newPassword},
    )).message);
  }

  @override
  Future<bool> checkPassword(String password) async {
    return (await _sendRequest(
      method: 'post',
      endpoint: "${ApiConstants.CHECK_PASSWORD}$password",
    )).data;
  }

  @override
  Future<List<User>> getUserFollowers(GetUserFollowersFollowingsRequest request) async {
    return UserModel.fromJsonList((await _sendRequest(
      method: 'get',
      endpoint: ApiConstants.GET_USER_FOLLOWERS,
      data: request.toJson(),
    )).data);
  }

  @override
  Future<List<User>> getUserFollowing(GetUserFollowersFollowingsRequest request) async {
    return UserModel.fromJsonList((await _sendRequest(
      method: 'get',
      endpoint: ApiConstants.GET_USER_FOLLOWINGS,
      data: request.toJson(),
    )).data);
  }

  @override
  Future<Success> followUser(int userId) async {
    return ServerSuccess((await _sendRequest(
      method: 'post',
      endpoint: "${ApiConstants.FOLLOW_USER}$userId",
    )).message);
  }

  @override
  Future<Success> unfollowUser(int userId) async {
    return ServerSuccess((await _sendRequest(
      method: 'post',
      endpoint: "${ApiConstants.UNFOLLOW_USER}$userId",
    )).message);
  }

  @override
  Future<Success> unfollowMe(int userId) async {
    return ServerSuccess((await _sendRequest(
      method: 'post',
      endpoint: "${ApiConstants.UNFOLLOW_ME}$userId",
    )).message);
  }

  @override
  Future<List<UserModel>> searchForUsers(SearchRequest request) async {
    return UserModel.fromJsonList((await _sendRequest(
      method: 'get',
      endpoint: ApiConstants.SEARCH_FOR_USERS,
      data: request.toJson(),
    )).data);
  }
  
  @override
  Future<UserModel> addAddressToUser(AddAddressToUserRequest request) async {
    return UserModel.fromJson((await _sendRequest(
      method: 'post',
      endpoint: ApiConstants.ADD_ADDRESS_TO_USER,
      data: request.toJson(),
    )).data);
  }
  
  @override
  Future<Success> deleteUserImage() async {
    return ServerSuccess((await _sendRequest(
      method: 'post',
      endpoint: ApiConstants.DELETE_USER_IMAGE,
    )).message);
  }
 
  @override
  Future<Success> deleteAccount() async {
    return ServerSuccess((await _sendRequest(
      method: 'delete',
      endpoint: ApiConstants.DELETE_ACCOUNT,
    )).message);
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
      print("::: S End sendRequest func in user_remote_datasource");
      return response;
    }
    print(
        "::: F End sendRequest func in comment_remote_datasource: ${response.message}");
    throw AppException(ServerFailure(
      code: response.code,
      message: response.message,
      errors: response.errors,
    ));
  }
}
