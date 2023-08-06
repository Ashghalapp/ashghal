


import 'package:ashghal_app_frontend/features/auth/data/data_sources/remote_data_source.dart';
import 'package:ashghal_app_frontend/features/auth/data/repositories/user_provider_repository_impl.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/check_email_exist.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/forget_password.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/login.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/logout.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/register_provider_with_email.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/register_provider_with_phone.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/register_user_with_email.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/register_user_with_phone.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/resend_email_verification_code.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/resend_forget_password_code.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/reset_password.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/verify_email.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/verify_reset_password_code.dart';
import 'package:get_it/get_it.dart';
final getIt = GetIt.instance;

void setupDependencies() {

  //// core injection
 
  //=============================Start Auth Dependencey Injection==================================//
  //// Data sources injection
  getIt.registerLazySingleton<RemoteDataSource>(()=> RemoteDataSourceImpl());
  // getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  //// repository injection
  getIt.registerLazySingleton<UserProviderRepository>(() => UserProviderRepositoryImpl());

  //// usecases injection
  getIt.registerLazySingleton(() => RegisterUserWithEmailUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUserWithPhoneUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterProviderWithEmailUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterProviderWithPhoneUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyEmailUseCase(getIt()));
  getIt.registerLazySingleton(() => ResendEmailVerificationCodeUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckEmailExistUseCase(getIt()));
  getIt.registerLazySingleton(() => ForgetPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => ResendForgetPasswordCodeUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyResetPasswordCodeUseCase(getIt()));
  // getIt.registerLazySingleton(() => VerifyResetPasswordCodeUseCase(getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));
  //=============================End Auth Dependencey Injection==================================//


  //=============================Start Post Dependencey Injection==================================//

  //=============================End Post Dependencey Injection====================================//
}