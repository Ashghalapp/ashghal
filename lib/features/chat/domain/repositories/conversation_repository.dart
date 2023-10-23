import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/conversation_last_message_and_count.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/matched_conversation_and_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/block_unblock_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/start_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:dartz/dartz.dart';

abstract class ConversationRepository {
  Future<void> synchronizeConversations();

  /// Unsubscribes the user from chat channels.
  ///
  /// This method is responsible for unsubscribing the user from chat channels, typically
  /// used when the user logs out or leaves a chat session.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = ConversationRepositoryImp();
  /// await repository.unsubscribeFromChatChannels();
  /// ```
  ///
  /// Note: Ensure that you call this method when it's necessary to unsubscribe from chat channels
  /// to prevent receiving further chat messages or events.
  Future<void> unsubscribeFromChatChannels();

  /// Subscribes to chat channels for a list of remote conversations and handles incoming messages.
  ///
  /// This method retrieves a list of remote conversations and subscribes to chat channels
  /// for each conversation using the PusherChatHelper. It also sets up callback functions
  /// to handle new messages, received messages, and read messages. When a new message is received,
  /// it is inserted into the local database. Received and read messages are marked accordingly
  /// in the local database.
  ///
  /// Use this method to establish real-time chat channel subscriptions and handle incoming messages.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = ConversationRepositoryImp();
  /// await repository.subscribeToChatChannels();
  /// ```
  Future<void> subscribeToChatChannels(
    void Function(
      TypingEventType eventType,
      int userId,
    ) onTypingEvent,
  );

  Future<Either<Failure, List<LocalMessage>>> searchInConversations(
      String searchText);

  /// Starts a conversation with the specified user, both locally and remotely, based on the provided [StartConversationRequest].
  ///
  /// Returns a [Future] that either contains a boolean value `true` on success ([Right]),
  /// indicating that the conversation was created successfully, or a failure represented
  /// as a [Failure] object on failure ([Left]).
  ///
  /// This method initiates a conversation locally and, if the device is connected to the network, initiating the conversation remotely.
  ///
  /// starts the conversation remotely by calling [_startAConversationRemotelyAndUpdateTheLocal].
  ///
  /// Example usage:
  /// ```dart
  /// final repository = ConversationRepository();
  /// final request = StartConversationRequest(userId: 123);
  /// final result = await repository.startConversationWith(request);
  ///
  /// result.fold(
  ///   (failure) => print("Error: ${failure.message}"),
  ///   (created) => print("Conversation created: $created"),
  /// );
  /// ```
  /// - [request]: A [StartConversationRequest] object specifying the user to start a conversation with.
  /// - Returns a boolean value indicating whether the conversation was created successfully.
  Future<Either<Failure, bool>> startConversationWith(
      StartConversationRequest request);

  /// Streams updates to a list of local conversations from the local data source.
  ///
  /// Returns a [Stream] that emits a list of [LocalConversation] objects whenever there
  /// is a change in the database. The stream is ordered by the [updatedAt] field in
  /// descending order, ensuring that the most recently updated conversations are at
  /// the top of the list.
  ///
  /// Use this method to observe changes in the local conversations, such as updates or additions.
  ///
  /// Throws a [NotSpecificFailure] if an exception occurs during the streaming process.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = ConversationRepository();
  /// final stream = repository.watchAllConversations();
  ///
  /// stream.listen((conversations) {
  ///   print("Updated Conversations: $conversations");
  /// });
  /// ```
  Stream<List<LocalConversation>> watchAllConversations();

  /// Retrieves a list of all local conversations from the local data source.
  ///
  /// Returns a [Future] that either contains a list of [LocalConversation] objects
  /// on success ([Right]) or a failure represented as a [Failure] object on failure ([Left]).
  ///
  /// Use this method to retrieve a list of local conversations.
  ///
  /// Throws a [NotSpecificFailure] if an exception occurs during the retrieval.
  Future<Either<Failure, List<LocalConversation>>> getAllConversations();

  /// Streams updates to the last message and new messages count (unread messages) for each conversation from the local data source.
  ///
  /// Returns a [Stream] that emits a list of [ConversationlastMessageAndCount] objects whenever there
  /// is a change in the database. The stream provides information about the last message and new messages count (unread messages)
  /// for each conversation.
  ///
  ///  Use this method to observe changes in the conversations last message and new messages count.
  ///
  /// Throws a [NotSpecificFailure] if an exception occurs during the streaming process.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = ConversationRepository();
  /// final stream = repository.watchConversationsLastMessageAndCount();
  ///
  /// stream.listen((conversationsInfo) {
  ///   print("Updated Conversation Info: $conversationsInfo");
  /// });
  /// ```
  Stream<List<ConversationlastMessageAndCount>>
      watchConversationsLastMessageAndCount();

  /// Deletes a conversation and its associated messages based on the provided [DeleteConversationRequest].
  ///
  /// Returns a [Future] that either contains a boolean `true` on success ([Right])
  /// if the conversation was deleted, or a failure represented as a [Failure] object
  /// on failure ([Left]).
  ///
  /// Use this method to delete a conversation and its messages.
  ///
  /// Throws a [NotSpecificFailure] if an exception occurs during the deletion process.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = ConversationRepositoryImp();
  /// final request = DeleteConversationRequest(conversationLocalId: 123);
  /// final result = await repository.deleteConversation(request);
  ///
  /// if (result.isRight()) {
  ///   print("Conversation deleted successfully.");
  /// } else {
  ///   print("Failed to delete conversation: ${result.left().message}");
  /// }
  /// ```
  /// - [request]: A [DeleteConversationRequest] object specifying the conversation to delete.
  Future<Either<Failure, bool>> deleteConversations(
      List<int> conversationsLocalIds);

  /// Blocks or unblocks a conversation based on the provided [BlockUnblockConversationRequest].
  ///
  /// Returns a [Future] that either contains a boolean `true` on success ([Right])
  /// if the conversation was successfully blocked or unblocked, or a failure represented
  /// as a [Failure] object on failure ([Left]).
  ///
  /// Use this method to block or unblock a conversation.
  ///
  /// - [request]: A [BlockUnblockConversationRequest] specifying the conversation to block or unblock,
  /// and the operation is it blocking or unblocking.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = ConversationRepositoryImp();
  /// final request = BlockUnblockConversationRequest(
  ///   conversationId: 123,
  ///   block: true, // Set to true to block, false to unblock
  /// );
  /// final result = await repository.blockUnblockConversation(request);
  ///
  /// if (result.isRight()) {
  ///   print("Conversation blocked/unblocked successfully.");
  /// } else {
  ///   print("Failed to block/unblock conversation: ${result.left().message}");
  /// }
  /// ```
  ///
  /// Throws a [NotSpecificFailure] if an exception occurs during the blocking/unblocking process.
  Future<Either<Failure, bool>> blockUnblockConversation(
      BlockUnblockConversationRequest request);
  Future<Either<Failure, bool>> toggleFavoriteConversation(
      int conversationLocalId, bool addToFavorite);

  Future<Either<Failure, bool>> toggleArchiveConversation(
      int conversationLocalId, bool addToArchive);
}
