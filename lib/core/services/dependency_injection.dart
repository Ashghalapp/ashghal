import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
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
import 'package:ashghal_app_frontend/features/chat/data/repositories/conversation_repository_imp.dart';
import 'package:ashghal_app_frontend/features/chat/data/repositories/message_repository_imp.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/block_unblock_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/clear_chat.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/conversation_messages_read.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/delete_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/get_all_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/send_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/start_conversation_with.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/synchronize_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_all_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversation_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversation_messages_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversations_last_message_and_count.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  //// core injection
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  //=============================Start Auth Dependencey Injection==================================//
  //// Data sources injection
  // getIt.registerLazySingleton<RemoteDataSource>(()=> RemoteDataSourceImpl());
  // getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  //// repository injection
  getIt.registerLazySingleton<UserProviderRepository>(
      () => UserProviderRepositoryImpl());

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

  //=============================Start Chat Dependencey Injection==================================//
  getIt.registerLazySingleton(() => StartConversationWith(repository: getIt()));
  getIt.registerLazySingleton(() => WatchAllConversations(repository: getIt()));
  getIt.registerLazySingleton(
      () => WatchConversationMessages(repository: getIt()));
  getIt.registerLazySingleton(
      () => WatchConversationsLastMessageAndCount(repository: getIt()));

  getIt.registerLazySingleton(() => SendMessageUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => ConversationMessagesReadUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => SynchronizeConversations(repository: getIt()));
  // getIt.registerLazySingleton(
  //     () => DeleteConversationUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => GetAllConversationsUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => DeleteConversationUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => BlockUnblockConversationUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => WatchConversationMessagesMultimediaUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ClearChatUseCase(repository: getIt()));
  // getIt.registerLazySingleton(
  //     () => ConfirmGettenReceiveResponse(repository: getIt()));
  // getIt.registerLazySingleton(
  //     () => ConfirmGettenReadResponse(repository: getIt()));

  // repository injection
  getIt.registerLazySingleton<ConversationRepository>(
      () => ConversationRepositoryImp());
  getIt.registerLazySingleton<MessageRepository>(() => MessageRepositoryImp());
  //=============================End Chat Dependencey Injection====================================//
}
