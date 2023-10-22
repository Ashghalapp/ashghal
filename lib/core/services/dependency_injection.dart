import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/features/auth/data/repositories/user_provider_repository_impl.dart';
import 'package:ashghal_app_frontend/features/auth/data/repositories/user_repository_impl.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_provider_repository.dart';
import 'package:ashghal_app_frontend/features/auth/domain/repositories/user_repository.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/check_email_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/forget_password_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/login_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/logout_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/register_user_with_email_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/register_user_with_phone_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/reset_password_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/user_usecases/get_current_user_data_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/user_usecases/get_specific_user_data_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/user_usecases/update_user_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/verify_email_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/verify_reset_password_code_uc.dart';
import 'package:ashghal_app_frontend/features/post/data/repositories/comment_repository_impl.dart';
import 'package:ashghal_app_frontend/features/post/data/repositories/post_repository_impl.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/comment_repository.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/post_repository.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/add_comment_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/add_reply_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/delete_comment_or_reply_image_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/delete_comment_or_reply_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/get_comment_replies_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/get_post_comments_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/get_user_comments_on_post_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/get_user_comments_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/get_user_replies_on_comment_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/update_comment_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/comment_use_case/update_reply_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/add_post_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/delete_post_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/delete_some_post_multimedia_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_all_alive_post_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_all_complete_post_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_all_posts_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_category_posts_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_current_user_posts_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_specific_post_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_user_posts_uc.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/search_for_posts_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/update_post_us.dart';
import 'package:ashghal_app_frontend/features/chat/data/repositories/conversation_repository_imp.dart';
import 'package:ashghal_app_frontend/features/chat/data/repositories/message_repository_imp.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/block_unblock_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/clear_chat.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/conversation_messages_read.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/delete_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/dispatch_typing_event.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/download_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/get_all_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/get_conversation_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/search_in_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/send_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/start_conversation_with.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/subscribe_to_chat_channels.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/synchronize_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/unsubscribe_from_chat_channels.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/upload_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_all_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversation_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversation_messages_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversations_last_message_and_count.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  //// core injection
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  ///=============================================================================================//
  //=============================Start Auth and User Dependencey Injection==================================//
  //// Data sources injection

  //// repository injection
  getIt.registerLazySingleton<UserProviderRepository>(
      () => UserProviderRepositoryImpl());
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());

  //// usecases injection
  getIt.registerLazySingleton(() => RegisterUserWithEmailUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUserWithPhoneUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyEmailUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckEmailUseCase(getIt()));
  getIt.registerLazySingleton(() => ForgetPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => ValidateResetPasswordByEmailCode(getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));

  getIt.registerLazySingleton(() => GetCurrentUserDataUseCase(getIt()));
  getIt.registerLazySingleton(() => GetSpecificUserDataUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(getIt()));

  //=============================End Auth Dependencey Injection==================================//
  ///=============================================================================================//
  ///=============================================================================================//
  //=============================Start Post Dependencey Injection==================================//
  //// repository injection
  getIt.registerLazySingleton<PostRepository>(() => PostRepositoryImpl());

  //// usecases injection
  getIt.registerLazySingleton(() => AddPostUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdatePostUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllAlivePostsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllCompletePostsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllPostsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetSpecificPostUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUserPostsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserPostsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCategoryPostsUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchForPostsUseCase(getIt()));
  getIt.registerLazySingleton(() => DeletePostUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteSomePostMultimediaUseCase(getIt()));
  //=============================End Post Dependencey Injection====================================//

  ///=============================================================================================//
  //=============================Start Comment Dependencey Injection==================================//
  //// repository injection
  getIt.registerLazySingleton<CommentRepository>(() => CommentRepositoryImpl());

  //// usecases injection
  getIt.registerLazySingleton(() => GetPostCommentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCommentRepliesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUserCommentsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUserCommentsOnPostUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUserRepliesOnCommentsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddCommentUseCase(getIt()));
  getIt.registerLazySingleton(() => AddReplyUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateCommentUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateReplyUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteCommentOrReplyUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteCommentOrReplyImageUseCase(getIt()));
  //=============================End Comment Dependencey Injection====================================//
  ///=============================================================================================//

  //=============================Start Chat Dependencey Injection==================================//
  getIt.registerLazySingleton(
      () => StartConversationWithUseCase(repository: getIt()));
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
  getIt.registerLazySingleton(
      () => UnsubscribeFromRemoteChannelsUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => GetConversationMessagesUsecase(repository: getIt()));

  getIt.registerLazySingleton(
      () => UploadMultimediaUseCase(repository: getIt()));

  getIt.registerLazySingleton(
      () => DownloadMultimediaUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => SubscribeToChatChannelsUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => DispatchTypingEventUseCase(repository: getIt()));

  getIt.registerLazySingleton(
      () => SearchInConversationsUseCase(repository: getIt()));
  // repository injection
  getIt.registerLazySingleton<ConversationRepository>(
      () => ConversationRepositoryImp());
  getIt.registerLazySingleton<MessageRepository>(() => MessageRepositoryImp());
  //=============================End Chat Dependencey Injection====================================//

  ///=============================================================================================//
}
