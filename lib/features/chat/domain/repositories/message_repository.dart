import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_messages_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/dispatch_typing_event_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/download_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/upload_request.dart';
import 'package:dartz/dartz.dart';

import '../requests/clear_chat_request.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<LocalMessage>>> getCoversationMessages(
      int conversationId);

  /// Streams updates to the messages in a conversation based on the provided [conversationId].
  ///
  /// Returns a [Stream] that emits a list of [LocalMessage] objects whenever there is a change
  /// in the messages of the specified conversation. The stream provides real-time updates
  /// to the conversation's messages.
  ///
  /// Use this method to observe changes in the messages of a specific conversation.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = MessageRepository();
  /// final conversationId = 123;
  /// final stream = repository.watchConversationMessages(conversationId);
  ///
  /// stream.listen((messages) {
  ///   print("Updated Messages: $messages");
  /// });
  /// ```
  ///
  /// - [conversationId]: The ID of the conversation for which to watch messages.
  Stream<List<LocalMessage>> watchConversationMessages(int conversationId);

  /// Streams updates to multimedia messages in a conversation based on the provided [conversationId].
  ///
  /// Returns a [Stream] that emits a list of [LocalMultimedia] objects whenever there is a change
  /// in the multimedia messages of the specified conversation. The stream provides real-time updates
  /// to the multimedia messages in the conversation.
  ///
  /// Use this method to observe changes in multimedia messages of a specific conversation.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = MessageRepository();
  /// final conversationId = 123;
  /// final stream = repository.watchConversationMessagesMultimedia(conversationId);
  ///
  /// stream.listen((multimediaMessages) {
  ///   print("Updated Multimedia Messages: $multimediaMessages");
  /// });
  /// ```
  ///
  /// - [conversationId]: The ID of the conversation for which to watch multimedia messages.
  Stream<List<LocalMultimedia>> watchConversationMessagesMultimedia(
      int conversationId);

  Future<Either<Failure, LocalMessage>> sendMessage(SendMessageRequest request);

  Future<Either<Failure, bool>> uploadMultimedia(UploadRequest request);

  Future<Either<Failure, bool>> downloadMultimedia(DownloadRequest request);

  Future<Either<Failure, bool>> deleteMessages(DeleteMessagesRequest request);

  Future<Either<Failure, bool>> clearChat(ClearChatRequest request);

  Future<void> conversationMessagesRead(int conversationId);

  /// Confirms the receipt of messages that were received locally to the remote server.
  ///
  /// This method retrieves messages that were marked as received locally,
  /// prepares a request containing the IDs and received timestamps of these messages,
  /// sends the confirmation request to the remote server, and updates the local state
  /// based on the server's response.
  ///
  /// Example usage:
  /// ```dart
  /// final messageRepository = MessageRepositoryImp();
  /// await messageManager.confermReceivedLocallyMessagesRemotely();
  /// ```
  Future<void> confirmReceivedLocallyMessagesRemotely();

  /// Confirms that locally read messages have been read to the remote server.
  ///
  /// This method retrieves messages that were marked as read locally,
  /// prepares a request containing the IDs and read timestamps of these messages,
  /// sends the confirmation request to the remote server, and updates the local state
  /// based on the server's response.
  ///
  /// Example usage:
  /// ```dart
  /// final messageRepository = MessageRepositoryImp();
  /// await messageRepository.confermReadLocallyMessagesRemotely();
  /// ```
  Future<void> confermReadLocallyMessagesRemotely();

  /// Sends a local message to the remote database.
  ///
  /// Given a [LocalMessage], this method constructs the necessary request object,
  /// sends the message to the remote database, and updates the local message and multimedia records
  /// accordingly.
  ///
  /// Example usage:
  /// ```dart
  /// final messageSource = MessageLocalSource(chatDatabase);
  /// final localMessage = LocalMessage(/*...*/);
  /// await messageSource.sendLocalMessageToRemote(localMessage);
  /// ```
  ///
  /// - [localMessage]: The local message to send to the remote database.
  Future<void> sendLocalMessageToRemote(LocalMessage localMessage);

  /// Inserts a new message received from a remote source into the local database.
  ///
  /// This method first checks whether the message already exists locally. If it doesn't,
  /// the message is inserted along with any associated multimedia content. If the message
  /// already exists, and in both cases we then confirm that we received the messge.
  ///
  /// Returns the local ID of the inserted or existing message.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = MessageRepositoryImp();
  /// final remoteMessage = RemoteMessageModel(/* ... */);
  /// final conversationLocalId = 123;
  ///
  /// await repository.insertNewMessageFromRemote(remoteMessage, conversationLocalId);
  ///
  /// ```
  /// - [message]: The remote message to be inserted.
  /// - [conversationLocalId]: The local ID of the conversation associated with the message.
  Future<void> insertNewMessageFromRemote(
      RemoteMessageModel message, int conversationLocalId);

  /// Marks received messages as "received" and notifies the remote server of the reception confirmation.
  ///
  /// This method takes a list of [ReceivedReadMessageModel] objects representing messages
  /// that have been received by the conversation second user. It updates the "received at" timestamp for each message
  /// in the local data source to indicate that the message has been received. Additionally, it collects
  /// the IDs of the received messages and sends a reception confirmation to the remote server to inform
  /// it of the successful reception.
  ///
  /// Use this method to mark messages as received and ensure that the remote server is aware of the reception.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = MessageRepository();
  /// final receivedMessages = // List of ReceivedReadMessageModel objects
  ///
  /// await repository.markMessagesAsReceived(receivedMessages);
  /// ```
  ///
  /// - [remote]: A list of [ReceivedReadMessageModel] objects representing received messages.
  Future<void> markMessagesAsReceived(List<ReceivedReadMessageModel> remote);

  Future<void> dispatchTypingEvent(DispatchTypingEventRequest request);

  /// Marks received messages as "read" and notifies the remote server of the read confirmation.
  ///
  /// This method takes a list of [ReceivedReadMessageModel] objects representing messages
  /// that have been read by the local user. It updates the "read at" timestamp for each message
  /// in the local data source to indicate that the message has been read. Additionally, it collects
  /// the IDs of the read messages and sends a read confirmation to the remote server to inform
  /// it of the successful reading.
  ///
  /// Use this method to mark messages as read and ensure that the remote server is aware of the reading.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = MessageRepository();
  /// final readMessages = // List of ReceivedReadMessageModel objects
  ///
  /// await repository.markMessagesAsRead(readMessages);
  /// ```
  ///
  /// - [remote]: A list of [ReceivedReadMessageModel] objects representing messages that have been read.
  Future<void> markMessagesAsRead(List<ReceivedReadMessageModel> remote);

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
