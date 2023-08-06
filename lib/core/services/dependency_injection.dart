


import 'package:ashghal_app_frontend/features/auth/domain/use_cases/resend_forget_password_code.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/reset_password.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/verify_reset_password_code.dart';

import '../../features/auth/data/repositories/user_provider_repository_impl.dart';
import '../../features/auth/domain/repositories/user_provider_repository.dart';
import '../../features/auth/domain/use_cases/forget_password.dart';
import '../../features/auth/domain/use_cases/login.dart';
import 'package:get_it/get_it.dart';
final getIt = GetIt.instance;

void setupDependencies(){

  // core injection
  // getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
 
  
  // Data sources injection
  // getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
  // getIt.registerLazySingleton<RemoteDataSource>(()=> RemoteDataSourceImpl());

  // usecases injection
  // getIt.registerLazySingleton(() => AddPostUsecase(getIt()));
  // getIt.registerLazySingleton(() => GetAllPostsUsecase(getIt()));
  // getIt.registerLazySingleton(() => UpdatePostUsecase(getIt()));
  // getIt.registerLazySingleton(() => DeletePostUsecase(getIt()));
getIt.registerLazySingleton(() => LoginUseCase(getIt()));
getIt.registerLazySingleton(() => ForgetPasswordUseCase (getIt()));
getIt.registerLazySingleton(() => VerifyResetPasswordCodeUseCase (getIt()));
getIt.registerLazySingleton(() => ResendForgetPasswordCodeUseCase (getIt()));
getIt.registerLazySingleton(() => ResetPasswordUseCase (getIt()));

  // repository injection
  //  getIt.registerLazySingleton<PostRepository>(()=> PostRepositoryImpl());
getIt.registerLazySingleton<UserProviderRepository>(() => UserProviderRepositoryImpl());
}