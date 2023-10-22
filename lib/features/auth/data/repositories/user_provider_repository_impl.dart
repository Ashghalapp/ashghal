import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth/data/data_sources/remote_data_source.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/add_or_change_email_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/add_or_change_phone_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/check_email_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/login_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/register_user_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/reset_password_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/verify_email_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:dartz/dartz.dart';

class UserProviderRepositoryImpl extends UserProviderRepository {
  RemoteDataSource remoteDataSource = RemoteDataSourceImpl();
  NetworkInfo networkInfo = NetworkInfoImpl();

  @override
  Future<Either<Failure, User>> registerUserWithEmail(RegisterUserRequest request) async {
    var result = await _handleErrors(() async {
      return await remoteDataSource.registerUserWithEmail(request);
    });
    return result is User ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, User>> registerUserWithPhone(RegisterUserRequest request) async {
    var result = await _handleErrors(() async {
      return await remoteDataSource.registerUserWithPhone(request);
    });
    return result is User ? Right(result) : Left(result);
  }

  // @override
  // Future<Either<Failure, Provider>> registerProviderWithEmail(RegisterProviderRequest request) async {
  //   var register = await _handleErrors(() async {
  //     return await remoteDataSource.registerProviderWithEmail(request);
  //   });
  //   return register is Provider ? Right(register) : Left(register);
  // }

  // @override
  // Future<Either<Failure, Provider>> registerProviderWithPhone(RegisterProviderRequest request) async {
  //   var register = await _handleErrors(() async {
  //     return await remoteDataSource.registerProviderWithPhone(request);
  //   });
  //   return register is Provider ? Right(register) : Left(register);
  // }

  // @override
  // Future<Either<Failure, Success>> resendEmailVerificationCode() async {
  //   var resendCode = await _handleErrors(()async{
  //     return  await remoteDataSource.resendEmailVerificationCode();
  //   });
  //   return resendCode is Success ? Right(resendCode): Left(resendCode);
  // }

  @override
  Future<Either<Failure, Success>> checkEmail(CheckEmailRequest request) async {
    var result = await _handleErrors(() async {
      return await remoteDataSource.checkEmail(request);
    });
    return result is Success ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, User>> login(LoginRequest request) async {
    var login = await _handleErrors(() async {
      return await remoteDataSource.login(request);
    });
    return login is User ? Right(login) : Left(login);
  }

  @override
  Future<Either<Failure, Success>> logout() async {
    var logout = await _handleErrors(() async {
      return await remoteDataSource.logout();
    });
    return logout is Success ? Right(logout) : Left(logout);
  }

  @override
  Future<Either<Failure, Success>> sendEmailVerificationCode(String email) async {
    var result = await _handleErrors(() async {
      remoteDataSource.sendEmailVerificationCode(email);
    });
    return result is Success? Right(result): Left(result);
  }

  @override
  Future<Either<Failure, Success>> validateEmailVerificationCode(VerifyEmailRequest request) async {
    var verify = await _handleErrors(() async {
      return await remoteDataSource.validateEmailVerificationCode(request);
    });
    return verify is Success ? Right(verify) : Left(verify);
  }

  @override
  Future<Either<Failure, Success>> forgetPassword(
      ForgetPasswordRequest request) async {
    var result = await _handleErrors(() async {
      return await remoteDataSource.forgetPassword(request);
    });
    return result is Success ? Right(result) : Left(result);
  }

  // @override
  // Future<Either<Failure, Success>> resendForgetPasswordCode(ForgetPasswordRequest request) async {
  //   var result = await _handleErrors(()async{
  //     return  await remoteDataSource.resendForgetPasswordCode(request);
  //   });
  //   return result is Success ? Right(result): Left(result);
  // }

  @override
  Future<Either<Failure, Success>> validateResetPasswordByEmailCode(ValidateResetPasswordCodeRequest request) async {
    var result = await _handleErrors(() async {
      return await remoteDataSource.validateResetPasswordByEmailCode(request);
    });
    return result is Success ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Success>> validateResetPasswordByPhoneCode(ValidateResetPasswordCodeRequest request) async {
    var result = await _handleErrors(() async {
      remoteDataSource.validateResetPasswordByPhoneCode(request);
    });
    return result is Success? Right(result): Left(result);
  }

  @override
  Future<Either<Failure, Success>> resetPassword(ResetPasswordRequest request) async {
    var result = await _handleErrors(() async {
      return await remoteDataSource.resetPassword(request);
    });
    return result is Success ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Success>> addOrChangeEmail(AddOrChangeEmailRequest request) async{
    var result= await _handleErrors(() async{
      remoteDataSource.addOrChangeEmail(request);
    });
    return result is Success? Right(result): Left(result);
  }

  @override
  Future<Either<Failure, Success>> addOrChangePhone(AddOrChangePhoneRequest request) async{
    var result= await _handleErrors(() async{
      remoteDataSource.addOrChangePhone(request);
    });
    return result is Success? Right(result): Left(result);
  }

  Future _handleErrors(Function registerFunc) async {
    try {
      if (await networkInfo.isConnected) {
        return await registerFunc();
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
