
import 'package:ashghal/features/auth/data/repositories/user_provider_repository_impl.dart';
import 'package:ashghal/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:ashghal/features/auth/domain/use_cases/login.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;

void setup() {

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

  // repository injection
  //  getIt.registerLazySingleton<PostRepository>(()=> PostRepositoryImpl());
getIt.registerLazySingleton<UserProviderRepository>(() => UserProviderRepositoryImpl());
}