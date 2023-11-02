import 'dart:async';

import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/tables/chat_tables.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_last_message_and_count_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_multimedia_model.dart';
import 'package:moor_flutter/moor_flutter.dart';
// import 'package:moor/moor.dart';

part 'message_local_source.g.dart';

// class LastMessageWithCount {
//   final LocalMessage lastMessage;
//   final int newMessagesCount;

//   LastMessageWithCount({
//     required this.lastMessage,
//     required this.newMessagesCount,
//   });
// }
abstract class MessageLocalSourceAbstract {
  /// Streams updates to messages within a specific conversation based on the conversation's local ID.
  ///
  /// Returns a [Stream] that emits a list of [LocalMessage] objects whenever there is a change in the
  /// messages related to the specified conversation. Messages are ordered by their creation timestamp in ascending order.
  ///
  /// Use this method to observe changes in messages within a specific conversation.
  ///
  /// Example usage:
  /// ```dart
  /// final source = MessageLocalSource(ChatDatabase());
  /// final conversationLocalId = 123;
  ///
  /// final messageStream = source.watchConversationMessages(conversationLocalId);
  ///
  /// messageStream.listen((messages) {
  ///   print("Updated Messages in Conversation: $messages");
  /// });
  /// ```
  /// - [conversationLocalId]: The local ID of the conversation to watch for messages.
  Stream<List<LocalMessage>> watchConversationMessages(int conversationLocalId);

  Future<List<LocalMessage>> getConversationMessages(int conversationLocalId);

  /// Inserts a new local message into the database and returns the resulting
  /// local ID.
  ///
  /// Returns a [Future] that resolves to the local ID of the inserted message.
  ///
  /// Use this method to add a new message to the local database.
  ///
  /// Example usage:
  /// ```dart
  /// final messageSource = MessageLocalSource(chatDatabase);
  /// final newMessage = LocalMessage(
  ///   // Initialize message properties
  /// );
  /// final localId = await messageSource.insertNewMessage(newMessage);
  /// print("Inserted Message with local ID: $localId");
  /// ```
  /// - [message]: The [LocalMessage] object to insert into the database.
  Future<LocalMessage> insertMessage({
    required Insertable<LocalMessage> message,
    required int conversationLocalId,
    Future<MultimediaCompanion> Function(int messageLocalId)?
        multimediaConverterCallBack,
  });

  /// Deletes messages from the local data source based on their message IDs.
  ///
  /// This method takes a list of message IDs and deletes messages from the local database
  /// that match the provided IDs.
  ///
  /// Use this method to delete specific messages by their IDs.
  ///
  /// Example usage:
  /// ```dart
  /// final source = MessageLocalSource(ChatDatabase());
  /// final messageIdsToDelete = [123, 456, 789];
  ///
  /// await source.deleteMessages(messageIdsToDelete);
  /// ```
  ///
  /// - [messageIds]: A list of message IDs to delete.
  Future<void> deleteMessages(List<int> messageIds);

  /// Deletes all messages in a conversation based on the provided [conversationLocalId].
  ///
  /// Use this method to remove all messages associated with a specific conversation from the local database.
  ///
  /// Example usage:
  /// ```dart
  /// final source = MessageLocalSource(ChatDatabase());
  /// final conversationLocalId = 123;
  ///
  /// await source.deleteAllMessagesInConversation(conversationLocalId);
  /// ```
  ///
  /// - [conversationLocalId]: The local ID of the conversation for which messages should be deleted.
  Future<void> deleteAllMessagesInConversation(int conversationLocalId);

  /// Inserts a new message into the database and retrieves its instance with the assigned local ID.
  ///
  /// Use this method to insert a new message and obtain the message instance with its assigned local ID.
  ///
  /// Example usage:
  /// ```dart
  /// final source = MessageLocalSource(ChatDatabase());
  /// final messageToInsert = // Insertable<LocalMessage> message
  ///
  /// final insertedMessage = await source.insertMessageAndGetInstance(messageToInsert);
  /// ```
  ///
  /// - [message]: The message to insert into the database.
  Future<LocalMessage> insertMessageAndGetInstance(
      Insertable<LocalMessage> message);

  /// Marks messages in a conversation as read locally.
  ///
  /// Use this method to mark messages in a conversation as read locally,
  /// typically when the user has viewed the messages.
  ///
  /// Example usage:
  /// ```dart
  /// final source = MessageLocalSource(ChatDatabase());
  /// final conversationId = 123;
  ///
  /// await source.markConversationMessagesAsReadLocally(conversationId);
  /// ```
  ///
  /// - [conversationId]: The ID of the conversation for which messages should be marked as read locally.
  Future<int> markConversationMessagesAsReadLocally(int conversationId);

  Future<List<LocalMessage>> search(
    String searchText,
  );

  Future<List<LocalConversation>> getDeletedLocallyConversations();

  /// Updates an existing message in the database.
  ///
  /// Use this method to update an existing message in the local database.
  ///
  /// Example usage:
  /// ```dart
  /// final source = MessageLocalSource(ChatDatabase());
  /// final updatedMessage = // Updated Insertable<LocalMessage> message
  ///
  /// final success = await source.updateMessage(updatedMessage);
  /// ```
  ///
  /// - [message]: The updated message to replace the existing message in the database.
  Future<int> updateMessageWithLocalId({
    required int conversationLocalId,
    required Insertable<LocalMessage> localMessage,
    required int messageLocalId,
    int? multimediaLocalId,
    Future<MultimediaCompanion> Function(int messageLocalId)?
        multimediaConverterCallBack,
  });

  /// Retrieves a list of locally received messages from the local data source.
  ///
  /// Returns a [Future] that resolves to a list of [LocalMessage] objects representing
  /// messages that were received locally and not sent by the current user.
  ///
  /// Use this method to retrieve locally received messages.
  ///
  /// Example usage:
  /// ```dart
  /// final messageSource = MessageLocalSource(chatDatabase);
  /// final receivedMessages = await messageSource.getReceivedLocallyMessages();
  ///
  /// print("Received Locally Messages: $receivedMessages");
  /// ```
  Future<List<LocalMessage>> getReceivedLocallyMessages();

  Future<LocalMessage?> getMessageByLocalId(int localId);

  /// Updates the `receivedLocally` flag to `false` for messages with specified remote IDs.
  ///
  /// Returns a [Future] that completes when the update is successful.
  ///
  /// Use this method to mark messages as not received locally.
  ///
  /// - [remoteIds]: A list of remote message IDs to update.
  ///
  /// Example usage:
  /// ```dart
  /// final messageSource = MessageLocalSource(chatDatabase);
  /// final remoteIdsToUpdate = [1, 2, 3];
  /// await messageSource.updateReceivedLocallyToFalse(remoteIdsToUpdate);
  /// ```
  Future<int> updateReceivedLocallyToFalse(List<int> remoteIds);

  /// Retrieves a list of locally read messages that have been read.
  ///
  /// Returns a [Future] that resolves to a list of [LocalMessage] objects representing
  /// messages that have been marked as read locally and read, excluding those sent
  /// by the current user.
  ///
  /// Use this method to retrieve messages that you have read localy.
  ///
  /// Example usage:
  /// ```dart
  /// final messageSource = MessageLocalSource(chatDatabase);
  /// final messages = await messageSource.getReadLocallyMessages();
  ///
  /// print("Read Locally Messages: $messages");
  /// ```
  Future<List<LocalMessage>> getReadLocallyMessages();

  /// Updates the `readLocally` flag to `false` for messages with specified remote IDs.
  ///
  /// This method updates the `readLocally` flag to `false` for messages that have
  /// remote IDs matching the provided list of remote IDs.
  ///
  /// Returns a [Future] that resolves when the update is complete.
  ///
  /// - [remoteIds]: A list of remote IDs for which to update the `readLocally` flag to `false`.
  Future<int> updateReadLocallyToFalse(List<int> remoteIds);

  /// Retrieves a list of unsent local messages.
  ///
  /// Returns a [Future] that resolves to a list of [LocalMessage] objects that have not been sent.
  /// Messages are filtered based on the condition that they have no sent timestamp (null) and
  /// were sent by the current user.
  ///
  /// Use this method to retrieve unsent messages for further processing or retrying sending.
  ///
  /// Example usage:
  /// ```dart
  /// final messageSource = MessageLocalSource(chatDatabase);
  /// final unsentMessages = await messageSource.getUnSentMessages();
  ///
  /// print("Unsent Messages: $unsentMessages");
  /// ```
  Future<List<LocalMessage>> getUnSentMessages();

  /// Updates the "received at" timestamp and received locally status for a message.
  ///
  /// This method takes a [ReceivedReadMessageModel] object representing a received message
  /// and updates its "received at" timestamp and received locally status in the local database.
  ///
  /// Use this method to mark a message as received and update its status locally.
  ///
  /// Example usage:
  /// ```dart
  /// final source = MessageLocalSource(ChatDatabase());
  /// final receivedMessage = // ReceivedReadMessageModel object
  ///
  /// await source.updateMessagesReceivedAt(receivedMessage);
  /// ```
  ///
  /// - [rrMessage]: A [ReceivedReadMessageModel] object representing a received message.
  Future<int> updateMessagesReceivedAt(ReceivedReadMessageModel rrMessage);

  /// Updates the "read at" timestamp and read locally status for a message.
  ///
  /// This method takes a [ReceivedReadMessageModel] object representing a read message
  /// and updates its "read at" timestamp and read locally status in the local database.
  ///
  /// Use this method to mark a message as read and update its status locally.
  ///
  /// Example usage:
  /// ```dart
  /// final source = MessageLocalSource(ChatDatabase());
  /// final readMessage = // ReceivedReadMessageModel object
  ///
  /// await source.updateMessagesReadAt(readMessage);
  /// ```
  ///
  /// - [rrMessage]: A [ReceivedReadMessageModel] object representing a read message.
  Future<int> updateMessagesReadAt(ReceivedReadMessageModel rrMessage);

  Future<int> toggleStarMessage(
      int messageLocalId, bool starMessage, int conversationLocalId);

  /// Retrieves a local message by its remote ID.
  ///
  /// Returns a [Future] that resolves to a [LocalMessage] object if a message
  /// with the specified remote ID is found, or `null` if no such message exists.
  ///
  /// Use this method to retrieve a message based on its remote ID.
  ///
  /// Example usage:
  /// ```dart
  /// final messageSource = MessageLocalSource(chatDatabase);
  /// final remoteIdToFind = 123;
  /// final message = await messageSource.getMessageByRemoteId(remoteIdToFind);
  ///
  /// if (message != null) {
  ///   print("Found Message: $message");
  /// } else {
  ///   print("Message with remote ID $remoteIdToFind not found.");
  /// }
  /// ```
  /// - [remoteId]: The remote ID of the message to retrieve.
  Future<LocalMessage?> getMessageByRemoteId(int remoteId);

  /// Retrieves a list of unread messages in a conversation based on the provided [conversationId].
  ///
  /// Returns a [Future] that resolves to a list of [LocalMessage] objects representing unread messages
  /// within the specified conversation. Unread messages are those sent by other participants in the
  /// conversation (excluding the current user) and have not been marked as read.
  ///
  /// Use this method to fetch unread messages for a specific conversation.
  ///
  /// Example usage:
  /// ```dart
  /// final source = MessageLocalSource(ChatDatabase());
  /// final conversationId = 123;
  ///
  /// final unreadMessages = await source.getUnreadMessagesInConversation(conversationId);
  ///
  /// if (unreadMessages.isNotEmpty) {
  ///   print("Unread Messages in Conversation $conversationId: $unreadMessages");
  /// } else {
  ///   print("No unread messages in Conversation $conversationId.");
  /// }
  /// ```
  ///
  /// - [conversationId]: The ID of the conversation for which to retrieve unread messages.
  Future<List<LocalMessage>> getUnreadMessagesInConversation(
      int conversationId);

  /// Streams updates to the last message and new messages count(unread messages) for each conversation from the data source.
  ///
  /// Returns a [Stream] that emits a list of [ConversationLastMessageAndCountModel] objects whenever there
  /// is a change in the database. The stream provides information about the last message and the count of new messages
  /// for each conversation.
  ///
  /// Use this method to observe changes in the last message and new messages count(unread messages) for each conversation.
  ///
  /// This method performs a custom SQL query to retrieve the necessary information.
  ///
  /// Example usage:
  /// ```dart
  /// final messageSource = MessageLocalSource(chatDatabase);
  /// final stream = messageSource.watchLastMessageAndCountInEachConversation();
  ///
  /// stream.listen((conversationsInfo) {
  ///   print("Updated Conversation Info: $conversationsInfo");
  /// });
  /// ```
  Stream<List<ConversationLastMessageAndCountModel>>
      watchLastMessageAndCountInEachConversation();

  //======================================Multimedia Functions===========================//

  /// Retrieves multimedia associated with a message by its message ID.
  ///
  /// Returns a [Future] that resolves to a [LocalMultimedia] object representing
  /// the multimedia associated with the message with the specified message ID if found,
  /// or `null` if no matching multimedia is found.
  ///
  /// Use this method to retrieve multimedia content associated with a message.
  ///
  /// - [messageId]: The message ID of the message to find multimedia for.
  Future<LocalMultimedia?> getMessageMultimedia(int messageId);

  /// Inserts multimedia data into the database.
  ///
  /// Returns a [Future] that resolves to the ID of the inserted multimedia data if
  /// the insertion is successful, or throws an exception on failure.
  ///
  /// Use this method to insert multimedia data into the local database.
  ///
  /// - [multimedia]: The multimedia data to insert, represented as an [Insertable<LocalMultimedia>] object.
  Future<int> insertMultimedia(Insertable<LocalMultimedia> multimedia);

  /// Updates multimedia data in the database.
  ///
  /// Returns a [Future] that resolves to `true` if the multimedia data was successfully updated,
  /// or `false` if the update operation failed.
  ///
  /// Use this method to update multimedia data in the database.
  ///
  /// - [multimedia]: An [Insertable<LocalMultimedia>] representing the multimedia data to update.
  Future<int> updateMultimedia(
      Insertable<LocalMultimedia> multimedia, int multimediaLocalId);
  Future<int> updateMessageMultimedia(int messageLocalId,
      Insertable<LocalMultimedia> multimedia, int multimediaLocalId);

  /// Streams multimedia content related to a specific conversation's messages.
  ///
  /// Returns a [Stream] that emits a list of [LocalMultimedia] objects representing multimedia content
  /// associated with messages within the specified conversation. The stream updates whenever there is
  /// a change in the multimedia content for the conversation.
  ///
  /// Use this method to observe multimedia content for a particular conversation.
  ///
  /// Example usage:
  /// ```dart
  /// final source = MultimediaLocalSource(ChatDatabase());
  /// final conversationId = 123;
  ///
  /// final multimediaStream = source.watchConversationMessagesMultimedia(conversationId);
  ///
  /// multimediaStream.listen((multimediaContent) {
  ///   print("Updated Multimedia Content: $multimediaContent");
  /// });
  /// ```
  /// - [conversationId]: The ID of the conversation for which to retrieve multimedia content.
  Stream<List<MessageAndMultimediaModel>>
      watchConversationMessagesAndMultimedia(int conversationId);

  Future<List<MessageAndMultimediaModel>> getStarredMessages();

  Future<int> cancelUploadDownloadMultimedia(int multimediaLocalId);
}

@UseDao(
  tables: [Messages, Multimedia],
  queries: {
    "newMessagesNotSent": "select * from messages where sent_at is null;"
  },
)
class MessageLocalSource extends DatabaseAccessor<ChatDatabase>
    with _$MessageLocalSourceMixin
    implements MessageLocalSourceAbstract {
  final ChatDatabase db;

  static MessageLocalSource? _instance;
  MessageLocalSource._(this.db) : super(db);
  factory MessageLocalSource() {
    return _instance ?? MessageLocalSource._(ChatDatabase());
  }

  static final StreamController<List<LocalMessage>> _messagesStreamController =
      StreamController<List<LocalMessage>>.broadcast();
  static Stream<List<LocalMessage>> get onMessagesChanges =>
      _messagesStreamController.stream;

  void notifyMessagesListener(
      SimpleSelectStatement<$MessagesTable, LocalMessage> query) async {
    if (!_messagesStreamController.hasListener) {
      // AppPrint.printInfo("Stream has no listeners");
      return;
    }
    List<LocalMessage> messages = await query.get();
    // AppPrint.printInfo("Number of messages sent to stream ${messages.length}");

    if (messages.isNotEmpty) {
      _messagesStreamController.add(messages);
    }
  }

  void messagesDataUpdatedWithLocalId(List<int> localIds) {
    var query = db.select(db.messages)
      ..where((tbl) => tbl.localId.isIn(localIds))
      ..orderBy(
        [
          (table) => OrderingTerm(
                expression: table.createdAt,
                mode: OrderingMode.asc,
              )
        ],
      );
    notifyMessagesListener(query);
  }

  messagesDataUpdatedWithRemoteId(List<int> remoteIds) async {
    var query = db.select(db.messages)
      ..where((tbl) => tbl.remoteId.isIn(remoteIds))
      ..orderBy(
        [
          (table) => OrderingTerm(
                expression: table.createdAt,
                mode: OrderingMode.asc,
              )
        ],
      );
    notifyMessagesListener(query);
  }

  @override
  Stream<List<LocalMessage>> watchConversationMessages(
      int conversationLocalId) async* {
    yield* onMessagesChanges;
  }

  Future<List<MessageAndMultimediaModel>> getConversationMessagesWithMultimedia(
      int conversationLocalId) async {
    final queryResult = await (db.select(db.messages)
          ..where((tbl) => tbl.conversationId.equals(conversationLocalId))
          ..orderBy([
            (table) => OrderingTerm(
                  expression: table.createdAt,
                  mode: OrderingMode.desc,
                )
          ]))
        .join(
      [
        leftOuterJoin(db.multimedia,
            db.multimedia.messageId.equalsExp(db.messages.localId)),
      ],
    ).get();
    final messageAndMultimediaList = <MessageAndMultimediaModel>[];
    for (final result in queryResult) {
      messageAndMultimediaList.add(
        MessageAndMultimediaModel(
            message: result.readTable(db.messages),
            multimedia: result.readTableOrNull(db.multimedia)),
      );
    }
    return messageAndMultimediaList;
  }

  static final StreamController<List<MessageAndMultimediaModel>>
      _messagesAndMultimediaStreamController =
      StreamController<List<MessageAndMultimediaModel>>.broadcast();
  static Stream<List<MessageAndMultimediaModel>>
      get onMessagesAndMultimediaChanges =>
          _messagesAndMultimediaStreamController.stream;

  void messagesWithMultimediaDataUpdated(List<int> messagesLocalIds) async {
    if (!_messagesAndMultimediaStreamController.hasListener) {
      return;
    }
    final queryResult = await (db.select(db.messages)
          ..where((tbl) => tbl.localId.isIn(messagesLocalIds))
          ..orderBy([
            (table) => OrderingTerm(
                  expression: table.createdAt,
                  mode: OrderingMode.asc,
                )
          ]))
        .join(
      [
        leftOuterJoin(db.multimedia,
            db.multimedia.messageId.equalsExp(db.messages.localId)),
      ],
    ).get();

    final messageAndMultimediaList = <MessageAndMultimediaModel>[];
    for (final result in queryResult) {
      messageAndMultimediaList.add(
        MessageAndMultimediaModel(
            message: result.readTable(db.messages),
            multimedia: result.readTableOrNull(db.multimedia)),
      );
    }
    if (messageAndMultimediaList.isNotEmpty) {
      _messagesAndMultimediaStreamController.add(messageAndMultimediaList);
    }
  }

  @override
  Stream<List<MessageAndMultimediaModel>>
      watchConversationMessagesAndMultimedia(int conversationId) async* {
    yield* onMessagesAndMultimediaChanges;
  }

  static final StreamController<List<ConversationLastMessageAndCountModel>>
      _lastMessageAndCountController =
      StreamController<List<ConversationLastMessageAndCountModel>>.broadcast();
  static Stream<List<ConversationLastMessageAndCountModel>>
      get onLastMessageAndCountChanges => _lastMessageAndCountController.stream;
  Future<void> conversationLastMessageAndCountUpdatedWithMessageRemoteId(
      int messageRemoteId) async {
    if (!_lastMessageAndCountController.hasListener) {
      return;
    }
    try {
      LocalMessage message = await (select(db.messages)
            ..where((tbl) => tbl.remoteId.equals(messageRemoteId)))
          .getSingle();
      conversationLastMessageAndCountUpdated(message.conversationId);
    } catch (e) {
      AppPrint.printError(
          "Error in MessageLocalSource on conversationLastMessageAndCountUpdatedWithMessageRemoteId: ${e.toString()}");
    }
  }

  Future<void> conversationLastMessageAndCountUpdated(
      int conversationLocalId) async {
    if (!_lastMessageAndCountController.hasListener) {
      return;
    }
    try {
      final queryResult = await (db.customSelect(
        '''
    SELECT m.*, latest_msg.new_message_count as new_messages_count
    FROM messages m
    JOIN (
      SELECT conversation_id,
            MAX(created_at) AS max_created_at,
            MAX(local_id) AS max_id,
            SUM(CASE WHEN read_at IS NULL AND read_locally IS false AND sender_id != ${SharedPref.currentUserId} THEN 1 ELSE 0 END) AS new_message_count
      FROM messages
      WHERE conversation_id = $conversationLocalId
      GROUP BY conversation_id
    ) latest_msg ON m.conversation_id = latest_msg.conversation_id
              AND m.created_at = latest_msg.max_created_at
              AND m.local_id = latest_msg.max_id;

    ''',
        readsFrom: {db.messages},
      )).getSingle();

      // return
      ConversationLastMessageAndCountModel conversationLastMessageAndCount =
          ConversationLastMessageAndCountModel(
        lastMessage: LocalMessage(
          localId: queryResult.read<int>('local_id'),
          remoteId: queryResult.read<int?>('remote_id'),
          senderId: queryResult.read<int>('sender_id'),
          conversationId: queryResult.read<int>('conversation_id'),
          replyTo: queryResult.read<int?>('reply_to'),
          body: queryResult.read<String?>('body'),
          sentAt: queryResult.read<DateTime?>('sent_at'),
          recievedAt: queryResult.read<DateTime?>('recieved_at'),
          receivedLocally: queryResult.read<bool>('received_locally'),
          readAt: queryResult.read<DateTime?>('read_at'),
          readLocally: queryResult.read<bool>('read_locally'),
          isStarred: queryResult.read<bool>('is_starred'),
          createdAt: queryResult.read<DateTime>('created_at'),
          updatedAt: queryResult.read<DateTime>('updated_at'),
        ),
        newMessagesCount: queryResult.read<int>('new_messages_count'),
      );
      _lastMessageAndCountController.add([conversationLastMessageAndCount]);
      // AppPrint.printInfo(
      //     "conversationLastMessageAndCountUpdated got last message ${conversationLastMessageAndCount.lastMessage.toString()} ////\\\\ and count ${conversationLastMessageAndCount.newMessagesCount.toString()}");
    } catch (e) {
      AppPrint.printWarning(
          "Warning In MessageLocalSource on updateConversationLastMessageAndCountData no messages in this conversation:${e.toString()}");
      // return null; // Handle the case where the conversation ID doesn't exist.
    }
  }

  @override
  Stream<List<ConversationLastMessageAndCountModel>>
      watchLastMessageAndCountInEachConversation() async* {
    yield* onLastMessageAndCountChanges;
  }

  @override
  Future<List<LocalMessage>> getConversationMessages(
      int conversationLocalId) async {
    return (db.select(db.messages)
          ..where((tbl) => tbl.conversationId.equals(conversationLocalId))
          ..orderBy(
            [
              (table) => OrderingTerm(
                    expression: table.createdAt,
                    mode: OrderingMode.asc,
                  )
            ],
          ))
        .get();
  }

  @override
  Future<List<MessageAndMultimediaModel>> getStarredMessages() async {
    return (db.select(db.messages)
          ..where((tbl) => tbl.isStarred.equals(true))
          ..orderBy(
            [
              (table) => OrderingTerm(
                    expression: table.createdAt,
                    mode: OrderingMode.asc,
                  ),
            ],
          ))
        .join(
          [
            leftOuterJoin(db.multimedia,
                db.multimedia.messageId.equalsExp(db.messages.localId)),
          ],
        )
        .get()
        .then((result) {
          return result.map((row) {
            final message = row.readTable(db.messages);
            final multimedia = row.readTableOrNull(db.multimedia);
            return MessageAndMultimediaModel(
              message: message,
              multimedia: multimedia,
            );
          }).toList();
        });
  }

  @override
  Future<LocalMessage> insertMessage({
    required Insertable<LocalMessage> message,
    required int conversationLocalId,
    Future<MultimediaCompanion> Function(int messageLocalId)?
        multimediaConverterCallBack,
  }) async {
    LocalMessage? resultMessage;
    bool multimediaAdded = false;
    try {
      resultMessage = await insertMessageAndGetInstance(message);
      if (multimediaConverterCallBack != null) {
        await insertMultimedia(
          await multimediaConverterCallBack(resultMessage.localId),
        );
        multimediaAdded = true;
      }
    } catch (e) {
      AppPrint.printError(
          "Error in MessageLocalSource on insertMessage: ${e.toString()}");
      throw Exception("Failer inserting this message to db");
    } finally {
      // AppPrint.printInfo("Finnaly works");
      if (resultMessage != null &&
          !multimediaAdded &&
          multimediaConverterCallBack != null) {
        // AppPrint.printInfo("Finnaly works inside if");

        deleteMessages([resultMessage.localId]);
      } else if (resultMessage != null) {
        // AppPrint.printInfo("Finnaly works inside else");

        if (multimediaAdded) {
          // AppPrint.printInfo("Finnaly works messagesWithMultimediaDataUpdated");

          messagesWithMultimediaDataUpdated([resultMessage.localId]);
        } else {
          messagesDataUpdatedWithLocalId([resultMessage.localId]);
        }
        conversationLastMessageAndCountUpdated(conversationLocalId);
        // AppPrint.printInfo(
        //     "Finnaly works conversationLastMessageAndCountUpdated");
      }
    }

    return resultMessage;
  }

  @override
  Future<void> deleteMessages(List<int> messageIds) async {
    delete(db.messages).where((tbl) => tbl.localId.isIn(messageIds));
  }

  @override
  Future<void> deleteAllMessagesInConversation(int conversationLocalId) async {
    var query = delete(db.messages)
      ..where((tbl) => tbl.conversationId.equals(conversationLocalId));
    int m = await query.go();
    AppPrint.printInfo("Done delete number of messages deleted= $m");
  }

  @override
  Future<LocalMessage> insertMessageAndGetInstance(
      Insertable<LocalMessage> message) async {
    int localId = await into(db.messages).insert(message);
    final query = select(db.messages)..where((c) => c.localId.equals(localId));

    return await query.getSingle();
  }

  @override
  Future<int> markConversationMessagesAsReadLocally(
      int conversationLocalId) async {
    List<int> messagesIds = (await (select(db.messages)
              ..where(
                (message) =>
                    message.conversationId.equals(conversationLocalId) &
                    message.senderId.isNotIn([SharedPref.currentUserId]) &
                    message.readAt.isNull(),
              ))
            .get())
        .map((e) => e.localId)
        .toList();

    int count = await (update(db.messages)
          ..where((message) => message.localId.isIn(messagesIds)))
        .write(
      MessagesCompanion(
        readAt: Value(DateTime.now()),
        readLocally: const Value(true),
      ),
    );

    messagesDataUpdatedWithLocalId(messagesIds);
    conversationLastMessageAndCountUpdated(conversationLocalId);
    return count;
  }

  @override
  Future<List<LocalConversation>> getDeletedLocallyConversations() async {
    return await (select(db.conversations)
          ..where((c) => c.isDeletedLocally.equals(true)))
        .get();
  }

  @override
  Future<int> toggleStarMessage(
      int messageLocalId, bool starMessage, int conversationLocalId) async {
    int count = await (update(db.messages)
          ..where((c) => c.localId.equals(messageLocalId)))
        .write(
      MessagesCompanion(
        isStarred: Value(starMessage),
      ),
    );
    messagesDataUpdatedWithLocalId([messageLocalId]);
    return count;
  }

  @override
  Future<int> updateMessageWithLocalId({
    required int conversationLocalId,
    required Insertable<LocalMessage> localMessage,
    required int messageLocalId,
    int? multimediaLocalId,
    Future<MultimediaCompanion> Function(int messageLocalId)?
        multimediaConverterCallBack,
  }) async {
    int count = await (update(db.messages)
          ..where((message) => message.localId.equals(messageLocalId)))
        .write(localMessage);
    if (multimediaLocalId != null &&
        multimediaConverterCallBack != null &&
        count > 0) {
      int c = await updateMultimedia(
        await multimediaConverterCallBack(messageLocalId),
        multimediaLocalId,
      );
      if (c > 0) {
        messagesWithMultimediaDataUpdated([messageLocalId]);
        conversationLastMessageAndCountUpdated(conversationLocalId);
      }
    } else {
      messagesDataUpdatedWithLocalId([messageLocalId]);

      conversationLastMessageAndCountUpdated(conversationLocalId);
    }

    return count;
  }

  @override
  Future<List<LocalMessage>> getReceivedLocallyMessages() async {
    return await (db.select(messages)
          ..where(
            (tbl) =>
                tbl.receivedLocally.equals(true) &
                tbl.senderId.isNotIn([SharedPref.currentUserId]),
          ))
        .get();
  }

  @override
  Future<LocalMessage?> getMessageByLocalId(int localId) async {
    return await (select(db.messages)..where((c) => c.localId.equals(localId)))
        .getSingleOrNull();
  }

  @override
  Future<int> updateReceivedLocallyToFalse(List<int> remoteIds) async {
    return await (update(messages)
          ..where((message) => message.remoteId.isIn(remoteIds)))
        .write(
      const MessagesCompanion(
        receivedLocally: Value(false),
      ),
    );
  }

  @override
  Future<List<LocalMessage>> getReadLocallyMessages() async {
    return await (db.select(messages)
          ..where(
            (tbl) =>
                tbl.readLocally.equals(true) &
                tbl.senderId.isNotIn([SharedPref.currentUserId]),
          ))
        .get();
  }

  @override
  Future<int> updateReadLocallyToFalse(List<int> remoteIds) async {
    return await (update(messages)
          ..where((message) => message.remoteId.isIn(remoteIds)))
        .write(
      const MessagesCompanion(
        readLocally: Value(false),
      ),
    );
  }

  @override
  Future<List<LocalMessage>> getUnSentMessages() async {
    return await (select(db.messages)
          ..where(
            (message) =>
                message.sentAt.isNull() &
                message.senderId.equals(SharedPref.currentUserId),
          ))
        .get();
  }

  @override
  Future<int> updateMessagesReceivedAt(
      ReceivedReadMessageModel rrMessage) async {
    int count = await (update(db.messages)
          ..where((message) => message.remoteId.equals(rrMessage.id)))
        .write(
      MessagesCompanion(
        recievedAt: Value(rrMessage.at),
        receivedLocally: const Value(false),
      ),
    );

    messagesDataUpdatedWithRemoteId([rrMessage.id]);
    conversationLastMessageAndCountUpdatedWithMessageRemoteId(rrMessage.id);
    return count;
  }

  @override
  Future<int> updateMessagesReadAt(ReceivedReadMessageModel rrMessage) async {
    int count = await (update(db.messages)
          ..where((message) => message.remoteId.equals(rrMessage.id)))
        .write(
      MessagesCompanion(
        readAt: Value(rrMessage.at),
        readLocally: const Value(false),
      ),
    );
    messagesDataUpdatedWithRemoteId([rrMessage.id]);
    conversationLastMessageAndCountUpdatedWithMessageRemoteId(rrMessage.id);
    return count;
  }

  @override
  Future<LocalMessage?> getMessageByRemoteId(int remoteId) async {
    return await (select(db.messages)
          ..where((c) => c.remoteId.equals(remoteId)))
        .getSingleOrNull();
  }

  @override
  Future<List<LocalMessage>> getUnreadMessagesInConversation(
      int conversationId) async {
    return await (select(db.messages)
          ..where(
            (message) =>
                message.conversationId.equals(conversationId) &
                message.senderId.isNotIn([SharedPref.currentUserId]) &
                message.readAt.isNull(),
          ))
        .get();
  }

  @override
  Future<List<LocalMessage>> search(
    String searchText,
  ) async {
    final query = searchText.toLowerCase();

    // Create a custom SQL query to search conversations and messages
    // final customQuery = customSelect(
    //   '''SELECT
    //   c.local_id       as c_local_id ,
    //   c.remote_id      as c_remote_id  ,
    //   c.user_id        as c_user_id  ,
    //   c.user_name      as c_user_name  ,
    //   c.user_email     as c_user_email ,
    //   c.user_phone     as c_user_phone   ,
    //   c.user_image_url as c_user_image_url  ,
    //   c.is_blocked     as c_is_blocked   ,
    //   c.created_at     as c_created_at   ,
    //   c.updated_at     as c_updated_at   ,
    //   m.local_id         as m_local_id  ,
    //   m.remote_id        as m_remote_id  ,
    //   m.body             as m_body    ,
    //   m.sender_id        as m_sender_id   ,
    //   m.conversation_id  as m_conversation_id ,
    //   m.sent_at          as m_sent_at     ,
    //   m.recieved_at      as m_recieved_at  ,
    //   m.received_locally as m_received_locally ,
    //   m.read_at          as m_read_at  ,
    //   m.read_locally     as m_read_locally,
    //   m.created_at       as m_created_at,
    //   m.updated_at       as m_updated_at
    //   FROM conversations as c LEFT JOIN messages as m ON c.local_id = m.conversation_id
    //    WHERE LOWER(c.user_name) LIKE '%$query%' OR LOWER(m.body) LIKE '%$query%' ''',
    // );
    final customQuery = customSelect(
      '''SELECT * from messages where LOWER(body) LIKE '%$query%' AND conversation_id not in(select local_id from conversations where is_blocked is true or is_deleted_locally is true)''',
    );

    final results = await customQuery.map((row) {
      // final conversation = LocalConversation(
      //   localId: row.read<int>('c_local_id'),
      //   remoteId: row.read<int?>('c_remote_id'),
      //   userId: row.read<int>('c_user_id'),
      //   userName: row.read<String>('c_user_name'),
      //   userEmail: row.read<String?>('c_user_email'),
      //   userPhone: row.read<String?>('c_user_phone'),
      //   userImageUrl: row.read<String?>('c_user_image_url'),
      //   isBlocked: row.read<bool>('c_is_blocked'),
      //   createdAt: row.read<DateTime>('c_created_at'),
      //   updatedAt: row.read<DateTime>('c_updated_at'),
      // );

      final message = LocalMessage(
        localId: row.read<int>('local_id'),
        remoteId: row.read<int?>('remote_id'),
        body: row.read<String?>('body'),
        senderId: row.read<int>('sender_id'),
        conversationId: row.read<int>('conversation_id'),
        replyTo: row.read<int?>('reply_to'),
        sentAt: row.read<DateTime?>('sent_at'),
        recievedAt: row.read<DateTime?>('recieved_at'),
        receivedLocally: row.read<bool>('received_locally'),
        readAt: row.read<DateTime?>('read_at'),
        readLocally: row.read<bool>('read_locally'),
        isStarred: row.read<bool>('is_starred'),
        createdAt: row.read<DateTime>('created_at'),
        updatedAt: row.read<DateTime>('updated_at'),
      );
      return message;
    }).get();

    // final groupedResults = groupConversationsAndMessages(results);

    return results;
  }

  //======================================Multimedia Functions===========================//
  @override
  Future<LocalMultimedia?> getMessageMultimedia(int messageId) async {
    return await (select(db.multimedia)
          ..where(
            (mul) => mul.messageId.equals(messageId),
          ))
        .getSingleOrNull();
  }

  @override
  Future<int> insertMultimedia(Insertable<LocalMultimedia> multimedia) async {
    return await into(db.multimedia).insert(multimedia);
  }

  @override
  Future<int> updateMultimedia(
      Insertable<LocalMultimedia> multimedia, int multimediaLocalId) async {
    return await (update(db.multimedia)
          ..where(
            (tbl) => tbl.localId.equals(multimediaLocalId),
          ))
        .write(multimedia);
  }

  @override
  Future<int> cancelUploadDownloadMultimedia(int multimediaLocalId) async {
    return await (update(db.multimedia)
          ..where(
            (tbl) => tbl.localId.equals(multimediaLocalId),
          ))
        .write(
      const MultimediaCompanion(
        isCanceled: Value(true),
      ),
    );
  }

  @override
  Future<int> updateMessageMultimedia(int messageLocalId,
      Insertable<LocalMultimedia> multimedia, int multimediaLocalId) async {
    int count = await (update(db.multimedia)
          ..where(
            (tbl) => tbl.localId.equals(multimediaLocalId),
          ))
        .write(multimedia);
    if (count > 0) {
      AppPrint.printInfo("Message with multimedia data updated");
      messagesWithMultimediaDataUpdated([messageLocalId]);
    }
    return count;
  }

  // Future<List<ConversationLastMessageAndCountModel>>
  //     fetchLastMessageAndCountInEachConversation() async {
  //   final result = db.customSelect(
  //     '''
  //   SELECT m.*, latest_msg.new_message_count as new_messages_count
  //   FROM messages m
  //   JOIN (
  //     SELECT conversation_id,
  //           MAX(created_at) AS max_created_at,
  //           MAX(local_id) AS max_id,
  //           SUM(CASE WHEN read_at IS NULL THEN 1 ELSE 0 END) AS new_message_count
  //     FROM messages
  //     GROUP BY conversation_id
  //   ) latest_msg ON m.conversation_id = latest_msg.conversation_id
  //             AND m.created_at = latest_msg.max_created_at
  //             AND m.local_id = latest_msg.max_id;

  // ''',
  //     readsFrom: {db.messages},
  //   );

  //   final conversationLastMessageAndCountList = await result.map((row) {
  //     return ConversationLastMessageAndCountModel(
  //       lastMessage: LocalMessage(
  //         localId: row.read<int>('local_id'),
  //         remoteId: row.read<int?>('remote_id'),
  //         senderId: row.read<int>('sender_id'),
  //         conversationId: row.read<int>('conversation_id'),
  //         body: row.read<String?>('body'),
  //         sentAt: row.read<DateTime?>('sent_at'),
  //         recievedAt: row.read<DateTime?>('recieved_at'),
  //         receivedLocally: row.read<bool>('received_locally'),
  //         // confirmGotReceive: row.read<bool>('confirm_got_receive'),
  //         readAt: row.read<DateTime?>('read_at'),
  //         readLocally: row.read<bool>('read_locally'),
  //         // confirmGotRead: row.read<bool>('confirm_got_read'),
  //         createdAt: row.read<DateTime>('created_at'),
  //         updatedAt: row.read<DateTime>('updated_at'),
  //       ),
  //       newMessagesCount: row.read<int>('new_messages_count'),
  //     );
  //   }).get();

  //   return conversationLastMessageAndCountList;
  // }
//
  // Stream<List<LocalMessage>> watchReceivedAndNotConfirmedYet() {
  //   return (select(messages)
  //         ..where(
  //           (tbl) =>
  //               tbl.recievedAt.isNotNull() &
  //               // tbl.confirmGotReceive.equals(false) &
  //               tbl.senderId.equals(SharedPref.currentUserId),
  //         ))
  //       .watch();
  // }
//
  // Stream<List<LocalMessage>> watchReadAndNotConfirmedYet() {
  //   return (select(messages)
  //         ..where(
  //           (tbl) =>
  //               tbl.readAt.isNotNull() &
  //               // tbl.confirmGotRead.equals(false) &
  //               tbl.senderId.equals(SharedPref.currentUserId),
  //         ))
  //       .watch();
  // }
//
  // Future<void> updateConfirmGotReceiveToTrue(List<int> remoteIds) {
  //   return (update(messages)
  //         ..where((message) => message.remoteId.isIn(remoteIds)))
  //       .write(
  //     const MessagesCompanion(
  //         // confirmGotReceive: Value(true),
  //         ),
  //   );
  // }
//
  //  @override
  // Stream<List<ConversationLastMessageAndCountModel>>
  //     watchLastMessageAndCountInEachConversation() async* {
  //   yield* (db.customSelect(
  //     '''
  //     SELECT m.*, latest_msg.new_message_count as new_messages_count
  //     FROM messages m
  //     JOIN (
  //       SELECT conversation_id,
  //             MAX(created_at) AS max_created_at,
  //             MAX(local_id) AS max_id,
  //             SUM(CASE WHEN read_at IS NULL AND read_locally IS false AND sender_id != ${SharedPref.currentUserId} THEN 1 ELSE 0 END) AS new_message_count
  //       FROM messages
  //       where conversation_id not in(select local_id from conversations where is_blocked is true or is_deleted_locally is true)
  //       GROUP BY conversation_id
  //     ) latest_msg ON m.conversation_id = latest_msg.conversation_id
  //               AND m.created_at = latest_msg.max_created_at
  //               AND m.local_id = latest_msg.max_id;

  //   ''',
  //     readsFrom: {db.messages},
  //   )).watch().map((rows) {
  //     return rows.map((row) {
  //       return ConversationLastMessageAndCountModel(
  //         lastMessage: LocalMessage(
  //           localId: row.read<int>('local_id'),
  //           remoteId: row.read<int?>('remote_id'),
  //           senderId: row.read<int>('sender_id'),
  //           conversationId: row.read<int>('conversation_id'),
  //           body: row.read<String?>('body'),
  //           sentAt: row.read<DateTime?>('sent_at'),
  //           recievedAt: row.read<DateTime?>('recieved_at'),
  //           receivedLocally: row.read<bool>('received_locally'),
  //           // confirmGotReceive: row.read<bool>('confirm_got_receive'),
  //           readAt: row.read<DateTime?>('read_at'),
  //           readLocally: row.read<bool>('read_locally'),
  //           isStarred: row.read<bool>('is_starred'),
  //           // confirmGotRead: row.read<bool>('confirm_got_read'),
  //           createdAt: row.read<DateTime>('created_at'),
  //           updatedAt: row.read<DateTime>('updated_at'),
  //         ),
  //         newMessagesCount: row.read<int>('new_messages_count'),
  //       );
  //     }).toList();
  //   });
  // }
  // Future<void> updateConfirmGotReadToTrue(List<int> remoteIds) {
  //   return (update(messages)
  //         ..where((message) => message.remoteId.isIn(remoteIds)))
  //       .write(
  //     const MessagesCompanion(
  //         // confirmGotRead: Value(true),
  //         ),
  //   );
  // }
//
  // Future<void> markMessagesAsReadInConversation(int conversationId) async {
  //   await (update(messages)
  //         ..where((tbl) => tbl.conversationId.equals(conversationId) & tbl.conversationId.equals(conversationId)))
  //       .write(MessagesCompanion(
  //     readAt: Value(DateTime.now()),
  //     readLocally: const Value(true),
  //   ));
  // }
//
  // Future<List<LocalMessage>> getUnReceivedMessagesInConversation(
  //     int conversationId) async {
  //   return (select(db.messages)
  //         ..where(
  //           (message) =>
  //               message.conversationId.equals(conversationId) &
  //               message.recievedAt.isNull(),
  //         ))
  //       .get();
  // }
//
//

  // Stream<List<LocalMessage>> watchLastMessageInEachConversation() {
  //   return (db.customSelect(
  //     '''
  //       SELECT m.*, latest_msg.new_message_count
  //       FROM messages m
  //       JOIN (
  //         SELECT conversation_id,
  //               MAX(created_at) AS max_created_at,
  //               MAX(local_id) AS max_id,
  //               SUM(CASE WHEN read_at IS NULL THEN 1 ELSE 0 END) AS new_message_count
  //         FROM messages
  //         GROUP BY conversation_id
  //       ) latest_msg ON m.conversation_id = latest_msg.conversation_id
  //                 AND m.created_at = latest_msg.max_created_at
  //                 AND m.local_id = latest_msg.max_id;
  //   ''',
  //     readsFrom: {db.messages},
  //   )).watch().map((rows) {
  //     return rows.map((row) {
  //       return LocalMessage(
  //         localId: row.read<int>('local_id'),
  //         remoteId: row.read<int>('remote_id'),
  //         senderId: row.read<int>('sender_id'),
  //         conversationId: row.read<int>('conversation_id'),
  //         body: row.read<String?>('body'),
  //         sentAt: row.read<DateTime?>('sent_at'),
  //         recievedAt: row.read<DateTime?>('recieved_at'),
  //         receivedLocally: row.read<bool>('received_locally'),
  //         // confirmGotReceive: row.read<bool>('confirm_got_receive'),
  //         readAt: row.read<DateTime?>('read_at'),
  //         readLocally: row.read<bool>('read_locally'),
  //         // confirmGotRead: row.read<bool>('confirm_got_read'),
  //         createdAt: row.read<DateTime>('created_at'),
  //         updatedAt: row.read<DateTime>('updated_at'),
  //       );
  //     }).toList();
  //   });
  // }

  // Stream<List<LocalMessage>> watchReadLocallyMessages() {
  //   return (db.select(messages)
  //         ..where(
  //           (tbl) =>
  //               tbl.readLocally.equals(true) &
  //               tbl.senderId.isNotIn([SharedPref.currentUserId]),
  //         ))
  //       .watch();
  // }

  // Future<List<LocalMessage>> getConversationMessages(
  //     int conversationLocalId) async {
  //   return await (db.select(messages)
  //         ..where((tbl) => tbl.conversationId.equals(conversationLocalId)))
  //       .get();
  // }

  // Stream<List<LocalMessage>> watchReceivedLocallyMessages() {
  //   return (db.select(messages)
  //         ..where(
  //           (tbl) =>
  //               tbl.receivedLocally.equals(true) &
  //               tbl.senderId.isNotIn([SharedPref.currentUserId]),
  //         ))
  //       .watch();
  // }

  // Stream<List<LocalMessage>> watchMessagesNotSent() {
  //   return (select(db.messages)..where((tbl) => tbl.sentAt.equals(null)))
  //       .watch();
  // }

  /// A function to generate a unique random number that is not present in the table before.
  ///
  /// This function generates a random integer between 0 and 99,999.
  /// It checks if the generated value is not already present in the `moor_conversations` table.
  /// If the generated value exists in the table, it generates another random value until it finds a unique one.
  ///
  /// Returns:
  /// - A `Future<int>` representing the generated unique random number.
  // Future<int> getUniqueRandomNumber() async {
  //   final random = Random();
  //   int randomValue;
  //   // Retrieve all existing IDs from the `moor_conversations` table and create a set of existing IDs.
  //   final existingIds = await select(db.conversations).get().then(
  //       (list) => list.map((conversation) => conversation.localId).toSet());
  //   // Generate a random number and check if it is not present in the existing IDs set.
  //   do {
  //     randomValue = random.nextInt(1000000);
  //   } while (existingIds.contains(randomValue));

  //   return randomValue;
  // }
}
