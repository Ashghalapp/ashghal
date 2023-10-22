import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/add_or_change_email_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/add_or_change_phone_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/check_email_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/register_user_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/reset_password_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/login_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/verify_email_request.dart';
import 'package:dartz/dartz.dart';

import '../entities/user.dart';

abstract class UserProviderRepository{
  Future<Either<Failure, Success>> checkEmail(CheckEmailRequest request);

  Future<Either<Failure, User>> registerUserWithEmail(RegisterUserRequest request);

  Future<Either<Failure, User>> registerUserWithPhone(RegisterUserRequest request);

  // Future<Either<Failure, Provider>> registerProviderWithEmail(RegisterProviderRequest request);

  // Future<Either<Failure, Provider>> registerProviderWithPhone(RegisterProviderRequest request);

  /// الخاص به token تسجيل الدخول للمستخدم مع الاحتفاظ بالـ
  Future<Either<Failure, User>> login(LoginRequest request);

  Future<Either<Failure, Success>> logout();

  /// دالة تستخدم لارسال الكود الى الايميل عند عند القيام بعملية تغيير ايميل المستخدم 
  Future<Either<Failure, Success>>  sendEmailVerificationCode(String email);

  /// دالة تستخدم للتحقق من الكود المرسل الى الايميل عند القيام بعملية تغيير ايميل المستخدم 
  Future<Either<Failure, Success>>  validateEmailVerificationCode(VerifyEmailRequest request);

  // Future<Either<Failure, Success>> resendEmailVerificationCode(String email);
  
  /// ارسال طلب بتغيير كلمة السر وبناء عليه سيتم ارسال الكود الى الايميل او الهاتف
  Future<Either<Failure, Success>> forgetPassword(ForgetPasswordRequest request);

  // Future<Either<Failure, Success>> resendForgetPasswordCode(ForgetPasswordRequest request);

  Future<Either<Failure, Success>> validateResetPasswordByEmailCode(ValidateResetPasswordCodeRequest request);
  
  Future<Either<Failure, Success>> validateResetPasswordByPhoneCode(ValidateResetPasswordCodeRequest request);
    
  Future<Either<Failure, Success>> resetPassword(ResetPasswordRequest request);
  
  Future<Either<Failure, Success>> addOrChangePhone(AddOrChangePhoneRequest request);
  
  /// تستخدم هذه الدالة لتغيير البريد الالكتروني للمستخدم بحيث يتم التاكد من البريد اولا والتاكد 
  /// من كود التاكد من البريد ثم بعدها يتم استخدام هذه الدالة
  Future<Either<Failure, Success>> addOrChangeEmail(AddOrChangeEmailRequest request);



  
}