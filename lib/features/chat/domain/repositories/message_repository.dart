import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_messages_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';
import 'package:dartz/dartz.dart';

import '../requests/clear_chat_request.dart';

abstract class MessageRepository {
  Stream<List<LocalMessage>> watchConversationMessages(int conversationId);

  Stream<List<LocalMultimedia>> watchConversationMessagesMultimedia(
      int conversationId);

  Future<Either<Failure, LocalMessage>> sendMessage(SendMessageRequest request);

  Future<Either<Failure, bool>> deleteMessages(DeleteMessagesRequest request);

  Future<Either<Failure, bool>> clearChat(ClearChatRequest request);

  Future<void> conversationMessagesRead(int conversationId);
  // Future<Either<Failure, List<LocalMessage>>> sendSomeMessages(
  //     SendSomeMessageRequest request);

  // Future<Either<Failure, RecieveReadConfirmation>> confirmMessagesReceive(
  //     ReceiveReadConfirmationRequest request);

  // Future<Either<Failure, RecieveReadConfirmation>> confirmMessagesRead(
  //     ReceiveReadConfirmationRequest request);

  // Future<Either<Failure, RecieveReadGotConfirmation>>
  //     confirmGettenReceiveResponse(List<String> messagesIds);

  // Future<Either<Failure, RecieveReadGotConfirmation>> confirmGettenReadResponse(
  //     List<String> messagesIds);
}
