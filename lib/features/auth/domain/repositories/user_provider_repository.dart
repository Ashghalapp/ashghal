import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/register_user_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/reset_password_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/login_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/verify_email_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/provider.dart';
import 'package:dartz/dartz.dart';

import '../entities/user.dart';

abstract class UserProviderRepository{
  Future<Either<Failure, User>> registerUserWithEmail(RegisterUserRequest request);

  Future<Either<Failure, User>> registerUserWithPhone(RegisterUserRequest request);

  Future<Either<Failure, Provider>> registerProviderWithEmail(RegisterProviderRequest request);

  Future<Either<Failure, Provider>> registerProviderWithPhone(RegisterProviderRequest request);

  Future<Either<Failure, Success>>  verifyEmail(VerifyEmailRequest request);

  Future<Either<Failure, Success>> resendEmailVerificationCode();

  Future<Either<Failure, User>> login(LoginRequest request);

  Future<Either<Failure, Success>> logout();
  
  Future<Either<Failure, Success>> forgetPassword(ForgetPasswordRequest request);

  Future<Either<Failure, Success>> resendForgetPasswordCode(ForgetPasswordRequest request);

  Future<Either<Failure, Success>> verifyResetPasswordCode(VerifyResetPasswordCodeRequest request);
    
  Future<Either<Failure, Success>> resetPassword(ResetPasswordRequest request);
}