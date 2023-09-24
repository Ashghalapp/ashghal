import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/conversation_last_message_and_count.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/block_unblock_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/start_conversation_request.dart';
import 'package:dartz/dartz.dart';

abstract class ConversationRepository {
  ///A function for synchronizing conversations local changes with remote
  ///
  Future<void> synchronizeConversations();

  Future<Either<Failure, LocalConversation>> startConversationWith(
      StartConversationRequest request);

  Stream<List<LocalConversation>> watchAllConversations();

  Future<Either<Failure, List<LocalConversation>>> getAllConversations();

  Stream<List<ConversationlastMessageAndCount>>
      watchConversationsLastMessageAndCount();
  Future<Either<Failure, bool>> deleteConversation(
      DeleteConversationRequest request);

  Future<Either<Failure, bool>> blockUnblockConversation(
      BlockUnblockConversationRequest request);
}
