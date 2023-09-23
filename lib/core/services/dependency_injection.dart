


import 'package:ashghal_app_frontend/features/auth/data/repositories/user_provider_repository_impl.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/check_email_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/forget_password_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/login_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/logout_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/register_user_with_email_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/register_user_with_phone_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/reset_password_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/verify_email_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/verify_reset_password_code_uc.dart';
import 'package:get_it/get_it.dart';
final getIt = GetIt.instance;

void setupDependencies() {

  //// core injection
 
  //=============================Start Auth Dependencey Injection==================================//
  //// Data sources injection
  // getIt.registerLazySingleton<RemoteDataSource>(()=> RemoteDataSourceImpl());
  // getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  //// repository injection
  getIt.registerLazySingleton<UserProviderRepository>(() => UserProviderRepositoryImpl());

  //// usecases injection
  getIt.registerLazySingleton(() => RegisterUserWithEmailUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUserWithPhoneUseCase(getIt()));
  // getIt.registerLazySingleton(() => RegisterProviderWithEmailUseCase(getIt()));
  // getIt.registerLazySingleton(() => RegisterProviderWithPhoneUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyEmailUseCase(getIt()));
  // getIt.registerLazySingleton(() => ResendEmailVerificationCodeUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckEmailUseCase(getIt()));
  getIt.registerLazySingleton(() => ForgetPasswordUseCase(getIt()));
  // getIt.registerLazySingleton(() => ResendForgetPasswordCodeUseCase(getIt()));
  getIt.registerLazySingleton(() => ValidateResetPasswordByEmailCode(getIt()));
  // getIt.registerLazySingleton(() => VerifyResetPasswordCodeUseCase(getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));
  //=============================End Auth Dependencey Injection==================================//


  //=============================Start Post Dependencey Injection==================================//

  //=============================End Post Dependencey Injection====================================//
}