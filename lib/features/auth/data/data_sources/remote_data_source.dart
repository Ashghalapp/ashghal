// لكل implement الكلاس الاساسي والي يحتوي العمليات الاساسية حتى يتم منه عمل
// تقنية مستخدمة حتى تمثل مصدر البيانات، وهكذا تسهل عملية التعديل وايضا التغيير
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core_api/api_constant.dart';
import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth/data/models/provider_model.dart';
import 'package:ashghal_app_frontend/features/auth/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/login_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/register_user_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/reset_password_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/verify_email_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/provider.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';

abstract class RemoteDataSource {  
  Future<User> registerUserWithEmail(RegisterUserRequest request);

  Future<User> registerUserWithPhone(RegisterUserRequest request);

  Future<Provider> registerProviderWithEmail(RegisterProviderRequest request);

  Future<Provider> registerProviderWithPhone(RegisterProviderRequest request);

  Future<Success> verifyEmail(VerifyEmailRequest request);

  Future<Success> resendEmailVerificationCode();

  Future<User> login(LoginRequest loginRequest);

  Future<Success> logout();

  Future<Success> forgetPassword(ForgetPasswordRequest forgetPasswordRequest);

  Future<Success> resendForgetPasswordCode(ForgetPasswordRequest forgetPasswordRequest);

  Future<Success> verifyResetPasswordCode(VerifyResetPasswordCodeRequest verifyResetPasswordCodeRequest);

  Future<Success> resetPassword(ResetPasswordRequest resetPasswordRequest);
}

class RemoteDataSourceImpl implements RemoteDataSource{
  static String authEndPoint= "user/";
  DioService dio = DioService();

  @override
  Future<User> registerUserWithEmail(RegisterUserRequest request) async {
    ApiResponseModel response = await dio.post(ApiConstants.REGISTER_USER, request.toJson());
    if (response.status) {
      print("::: S End registerUserWithEmail func in remote datasource");
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<User> registerUserWithPhone(RegisterUserRequest request) async {
    ApiResponseModel response = await dio.post(ApiConstants.REGISTER_USER, request.toJson());
    if (response.status) {
      print("::: S End registerUserWithPhone func in remote datasource");
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }
  
  @override
  Future<Provider> registerProviderWithEmail(RegisterProviderRequest request) async {
    ApiResponseModel response = await dio.post(ApiConstants.REGISTER_PROVIDER, request.toJson());
    if (response.status) {
      print("::: S End registerProviderWithEmail func in remote datasource");
      return ProviderModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Provider> registerProviderWithPhone(RegisterProviderRequest request) async {
    ApiResponseModel response = await dio.post(ApiConstants.REGISTER_PROVIDER, request.toJson());
    if (response.status) {
      print("::: S End registerProviderWithPhone func in remote datasource");
      return ProviderModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> verifyEmail(VerifyEmailRequest request) async {
    ApiResponseModel response = await dio.post(ApiConstants.VERIFY_EMAIL, request.toJson());
    if (response.status) {
      print("::: S End forgetPassword func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> resendEmailVerificationCode() async{
    ApiResponseModel response = await dio.post(ApiConstants.RESEND_EMAIL_VERIFICATION_CODE, null);
    if (response.status) {
      print("::: S End resendEmailVerificationCode func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<User> login(LoginRequest request) async {
    ApiResponseModel response = await dio.post(ApiConstants.LOGIN, request.toJson());
    if (response.status) {
      print("::: S End login func in remote datasource");
      SharedPref.setAuthorizationKey(response.data['token']);
      if (response.data != null && response.data['is_provider']){
        return ProviderModel.fromJson(response.data as Map<String, dynamic>);
      }
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> logout() async{
    ApiResponseModel response = await dio.get(ApiConstants.LOGOUT);
    if (response.status) {
      print("::: S End logout func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }
  
  @override
  Future<Success> forgetPassword(ForgetPasswordRequest request) async {
    ApiResponseModel response = await dio.post(ApiConstants.FORGET_PASSWORD, request.toJson());
    if (response.status) {
      print("::: S End forgetPassword func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> resendForgetPasswordCode(ForgetPasswordRequest request) async{
    ApiResponseModel response = await dio.post(ApiConstants.RESEND_FORGET_PASSWORD_CODE, request.toJson());
    if (response.status) {
      print("::: S End resendForgetPasswordCode func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> verifyResetPasswordCode(VerifyResetPasswordCodeRequest request) async {
    ApiResponseModel response = await dio.post(ApiConstants.VERIFY_RESET_PASSWORD_CODE, request.toJson());
    if (response.status) {
      print("::: S End verifyResetPasswordCode func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> resetPassword(ResetPasswordRequest request) async{
    ApiResponseModel response = await dio.post(ApiConstants.RESET_PASSWORD, request.toJson());
    if (response.status) {
      print("::: S End forgetPassword func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(ServerFailure(message: response.message, errors: response.errors));
  }
}
