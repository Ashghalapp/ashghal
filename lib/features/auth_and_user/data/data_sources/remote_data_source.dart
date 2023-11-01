// لكل implement الكلاس الاساسي والي يحتوي العمليات الاساسية حتى يتم منه عمل
// تقنية مستخدمة حتى تمثل مصدر البيانات، وهكذا تسهل عملية التعديل وايضا التغيير
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core_api/api_constant.dart';
import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/data/models/user_model.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/add_or_change_email_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/add_or_change_phone_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/check_email_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/login_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/register_user_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/reset_password_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/validate_email_code_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';

abstract class RemoteDataSource {
  Future<Success> checkEmail(CheckEmailRequest request);

  Future<User> registerUserWithEmail(RegisterUserRequest request);

  Future<User> registerUserWithPhone(RegisterUserRequest request);

  // Future<Provider> registerProviderWithEmail(RegisterProviderRequest request);

  // Future<Provider> registerProviderWithPhone(RegisterProviderRequest request);

  Future<User> login(LoginRequest loginRequest);

  Future<Success> logout();

  /// دالة تستخدم لارسال الكود الى الايميل عند عند القيام بعملية تغيير ايميل المستخدم
  Future<Success> sendEmailVerificationCode(String email);

  /// دالة تستخدم للتحقق من الكود المرسل الى الايميل عند القيام بعملية تغيير ايميل المستخدم
  Future<Success> validateEmailVerificationCode(ValidateEmailCodeRequest request);

  /// ارسال طلب بتغيير كلمة السر وبناء عليه سيتم ارسال الكود الى الايميل او الهاتف
  /// ارسال طلب بتغيير كلمة السر وبناء عليه سيتم ارسال الكود الى الايميل او الهاتف
  Future<Success> forgetPassword(ForgetPasswordRequest request);

  // Future<Success> verifyEmail(VerifyEmailRequest request);

  // Future<Success> resendEmailVerificationCode();

  Future<Success> validateResetPasswordByEmailCode(
      ValidateResetPasswordCodeRequest request);

  Future<Success> validateResetPasswordByPhoneCode(
      ValidateResetPasswordCodeRequest request);

  Future<Success> resetPassword(ResetPasswordRequest request);

  // Future<Success> resendForgetPasswordCode(ForgetPasswordRequest request);

  // Future<Success> verifyResetPasswordCode(ValidateResetPasswordCodeRequest request);

  Future<Success> addOrChangePhone(AddOrChangePhoneRequest request);

  /// تستخدم هذه الدالة لتغيير البريد الالكتروني للمستخدم بحيث يتم التاكد من البريد اولا والتاكد
  /// من كود التاكد من البريد ثم بعدها يتم استخدام هذه الدالة
  Future<Success> addOrChangeEmail(AddOrChangeEmailRequest request);
  // Future<Success> resetPassword(ResetPasswordRequest resetPasswordRequest);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  static String authEndPoint = "user/";
  DioService dio = DioService();

  @override
  Future<Success> checkEmail(CheckEmailRequest request) async {
    ApiResponseModel response =
        await dio.post(ApiConstants.CHECK_EMAIL, request.toJson());
    if (response.status) {
      print("::: S End checkEmail func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<User> registerUserWithEmail(RegisterUserRequest request) async {
    print(":::::::: in registerUserWithEmail");

    ApiResponseModel response =
        await dio.post(ApiConstants.REGISTER_USER, request.toJson());
    if (response.status) {
      // SharedPref.setUserToken(response.data['token']);
      print("::: S End registerUserWithEmail func in remote datasource");
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<User> registerUserWithPhone(RegisterUserRequest request) async {
    // ApiResponseModel response = await dio.post(ApiConstants.REGISTER_USER, request.toJson());
    // if (response.status) {
    //   SharedPref.setAuthorizationKey(response.data['token']);
    //   print("::: S End registerUserWithPhone func in remote datasource");
    //   return UserModel.fromJson(response.data as Map<String, dynamic>);
    // }
    // throw AppException(ServerFailure(message: response.message, errors: response.errors));
    throw UnimplementedError();
  }

  // @override
  // Future<Provider> registerProviderWithEmail(
  //     RegisterProviderRequest request) async {
  //   ApiResponseModel response =
  //       await dio.post(ApiConstants.REGISTER_PROVIDER, request.toJson());
  //   if (response.status) {
  //     SharedPref.setAuthorizationKey(response.data['token']);
  //     print("::: S End registerProviderWithEmail func in remote datasource");
  //     return ProviderModel.fromJson(response.data as Map<String, dynamic>);
  //   }
  //   throw AppException(
  //       ServerFailure(message: response.message, errors: response.errors));
  // }

  // @override
  // Future<Provider> registerProviderWithPhone(
  //     RegisterProviderRequest request) async {
  //   ApiResponseModel response =
  //       await dio.post(ApiConstants.REGISTER_PROVIDER, request.toJson());
  //   if (response.status) {
  //     SharedPref.setAuthorizationKey(response.data['token']);
  //     print("::: S End registerProviderWithPhone func in remote datasource");
  //     return ProviderModel.fromJson(response.data as Map<String, dynamic>);
  //   }
  //   throw AppException(
  //       ServerFailure(message: response.message, errors: response.errors));
  // }

  // @override
  // Future<Success> verifyEmail(VerifyEmailRequest request) async {
  //   ApiResponseModel response =
  //       await dio.post(ApiConstants.VERIFY_EMAIL, request.toJson());
  //   if (response.status) {
  //     print("::: S End forgetPassword func in remote datasource");
  //     return ServerSuccess(response.message);
  //   }
  //   throw AppException(
  //       ServerFailure(message: response.message, errors: response.errors));
  // }

  // @override
  // Future<Success> resendEmailVerificationCode() async {
  //   ApiResponseModel response =
  //       await dio.post(ApiConstants.RESEND_EMAIL_VERIFICATION_CODE, null);
  //   if (response.status) {
  //     print("::: S End resendEmailVerificationCode func in remote datasource");
  //     return ServerSuccess(response.message);
  //   }
  //   throw AppException(
  //       ServerFailure(message: response.message, errors: response.errors));
  // }

  @override
  Future<User> login(LoginRequest request) async {
    print(">>>>>>>>>>>????????>${request.toJson()}");
    ApiResponseModel response =
        await dio.post(ApiConstants.LOGIN, request.toJson());
    if (response.status) {
      SharedPref.setUserToken(response.data['token']);
      var userModel = UserModel.fromJson(response.data as Map<String, dynamic>);

      SharedPref.setCurrentUserData(userModel);
      // SharedPref.setCurrentUserData({
      //   'id': userModel.id,
      //   'name': userModel.name,
      //   'image_url': userModel.imageUrl,
      //   'email': userModel.email,
      //   'phone': userModel.phone,
      // });
      SharedPref.setUserLoggedIn(true);
      print("::: S End login func in remote datasource");
      return userModel;
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> logout() async {
    ApiResponseModel response = await dio.get(ApiConstants.LOGOUT);
    if (response.status) {
      print("::: S End logout func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> sendEmailVerificationCode(String email) async {
    ApiResponseModel response =
        await dio.post(ApiConstants.SEND_EMAIL_VERIFICATION_CODE, {'email': email});
    if (response.status) {
      print("::: S End sendEmailVerificationCode func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> validateEmailVerificationCode(ValidateEmailCodeRequest request) async {
    ApiResponseModel response = await dio.post(
        ApiConstants.VALIDATE_EMAIL_VERIFICATION_CODE, request.toJson());
    if (response.status) {
      print(
          "::: S End validateEmailVerificationCode func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> forgetPassword(ForgetPasswordRequest request) async {
    ApiResponseModel response =
        await dio.post(ApiConstants.FORGET_PASSWORD, request.toJson());
    if (response.status) {
      print("::: S End forgetPassword func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  // @override
  // Future<Success> resendForgetPasswordCode(
  //     ForgetPasswordRequest request) async {
  //   ApiResponseModel response = await dio.post(
  //       ApiConstants.RESEND_FORGET_PASSWORD_CODE, request.toJson());
  //   if (response.status) {
  //     print("::: S End resendForgetPasswordCode func in remote datasource");
  //     return ServerSuccess(response.message);
  //   }
  //   throw AppException(
  //       ServerFailure(message: response.message, errors: response.errors));
  // }

  @override
  Future<Success> validateResetPasswordByEmailCode(
      ValidateResetPasswordCodeRequest request) async {
    ApiResponseModel response = await dio.post(
        ApiConstants.VALIDATE_RESET_PASSWORD_BY_EMAIL_CODE, request.toJson());
    if (response.status) {
      print("::: S End verifyResetPasswordCode func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> validateResetPasswordByPhoneCode(
      ValidateResetPasswordCodeRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<Success> resetPassword(ResetPasswordRequest request) async {
    ApiResponseModel response =
        await dio.post(ApiConstants.RESET_PASSWORD, request.toJson());
    if (response.status) {
      print("::: S End forgetPassword func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> addOrChangeEmail(AddOrChangeEmailRequest request) async {
    ApiResponseModel response =
        await dio.post(ApiConstants.ADD_OR_CHANGE_EMAIL, request.toJson());
    if (response.status) {
      print("::: S End addOrChangeEmail func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> addOrChangePhone(AddOrChangePhoneRequest request) async {
    ApiResponseModel response =
        await dio.post(ApiConstants.ADD_OR_CHANGE_PHONE, request.toJson());
    if (response.status) {
      print("::: S End addOrChangePhone func in remote datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }
}
