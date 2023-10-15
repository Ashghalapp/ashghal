import 'dart:math';

import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/tables/chat_tables.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_last_message_and_count_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_message_model.dart';
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

@UseDao(
  tables: [Messages],
  queries: {
    "newMessagesNotSent": "select * from messages where sent_at is null;"
  },
)
class MessageLocalSource extends DatabaseAccessor<ChatDatabase>
    with _$MessageLocalSourceMixin {
  final ChatDatabase db;

  MessageLocalSource(this.db) : super(db);

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

  Stream<List<LocalMessage>> watchConversationMessages(
      int conversationLocalId) async* {
    yield* (db.select(db.messages)
          ..where((tbl) => tbl.conversationId.equals(conversationLocalId))
          ..orderBy(
            [
              (table) => OrderingTerm(
                    expression: table.createdAt,
                    mode: OrderingMode.asc,
                  )
            ],
          ))
        .watch();
  }

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
  Future<int> insertMessage(Insertable<LocalMessage> message) async {
    return await into(db.messages).insert(message);
    // final query = select(db.messages)..where((c) => c.localId.equals(localId));
    // return await query.getSingle();
  }

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
  Future<void> deleteMessages(List<int> messageIds) async {
    delete(db.messages).where((tbl) => tbl.localId.isIn(messageIds));
  }

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
  Future<void> deleteAllMessagesInConversation(int conversationLocalId) async {
    // print("conversationLocalId $conversationLocalId");
    var query = delete(db.messages)
      ..where((tbl) => tbl.conversationId.equals(conversationLocalId));
    int m = await query.go();
    print("Done delete umber of messages deleted= $m");
  }

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
      Insertable<LocalMessage> message) async {
    int localId = await into(db.messages).insert(message);
    final query = select(db.messages)..where((c) => c.localId.equals(localId));
    return await query.getSingle();
  }

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
  Future<int> markConversationMessagesAsReadLocally(int conversationId) async {
    // print("markConversationMessagesAsReadLocally");
    return await (update(db.messages)
          ..where(
            (message) =>
                message.conversationId.equals(conversationId) &
                message.senderId.isNotIn([SharedPref.currentUserId]) &
                message.readAt.isNull(),
          ))
        .write(
      MessagesCompanion(
        readAt: Value(DateTime.now()),
        readLocally: const Value(true),
      ),
    );
  }

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
  Future<int> updateMessageWithLocalId(
      Insertable<LocalMessage> localMessage, int messageLocalId) async {
    return await (update(db.messages)
          ..where((message) => message.localId.equals(messageLocalId)))
        .write(localMessage);
  }

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
  Future<List<LocalMessage>> getReceivedLocallyMessages() async {
    return await (db.select(messages)
          ..where(
            (tbl) =>
                tbl.receivedLocally.equals(true) &
                tbl.senderId.isNotIn([SharedPref.currentUserId]),
          ))
        .get();
  }

  Future<LocalMessage?> getMessageByLocalId(int localId) async {
    return await (select(db.messages)..where((c) => c.localId.equals(localId)))
        .getSingleOrNull();
  }

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
  Future<int> updateReceivedLocallyToFalse(List<int> remoteIds) async {
    return await (update(messages)
          ..where((message) => message.remoteId.isIn(remoteIds)))
        .write(
      const MessagesCompanion(
        receivedLocally: Value(false),
      ),
    );
  }

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
  Future<List<LocalMessage>> getReadLocallyMessages() async {
    return await (db.select(messages)
          ..where(
            (tbl) =>
                tbl.readLocally.equals(true) &
                tbl.senderId.isNotIn([SharedPref.currentUserId]),
          ))
        .get();
  }

  /// Updates the `readLocally` flag to `false` for messages with specified remote IDs.
  ///
  /// This method updates the `readLocally` flag to `false` for messages that have
  /// remote IDs matching the provided list of remote IDs.
  ///
  /// Returns a [Future] that resolves when the update is complete.
  ///
  /// - [remoteIds]: A list of remote IDs for which to update the `readLocally` flag to `false`.
  Future<int> updateReadLocallyToFalse(List<int> remoteIds) async {
    return await (update(messages)
          ..where((message) => message.remoteId.isIn(remoteIds)))
        .write(
      const MessagesCompanion(
        readLocally: Value(false),
      ),
    );
  }

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
  Future<List<LocalMessage>> getUnSentMessages() async {
    return await (select(db.messages)
          ..where(
            (message) =>
                message.sentAt.isNull() &
                message.senderId.equals(SharedPref.currentUserId),
          ))
        .get();
  }

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
  Future<int> updateMessagesReceivedAt(
      ReceivedReadMessageModel rrMessage) async {
    return await (update(db.messages)
          ..where((message) => message.remoteId.equals(rrMessage.id)))
        .write(
      MessagesCompanion(
        recievedAt: Value(rrMessage.at),
        receivedLocally: const Value(false),
      ),
    );
  }

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
  Future<int> updateMessagesReadAt(ReceivedReadMessageModel rrMessage) async {
    return await (update(db.messages)
          ..where((message) => message.remoteId.equals(rrMessage.id)))
        .write(
      MessagesCompanion(
        readAt: Value(rrMessage.at),
        readLocally: const Value(false),
      ),
    );
  }

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
  Future<LocalMessage?> getMessageByRemoteId(int remoteId) async {
    return await (select(db.messages)
          ..where((c) => c.remoteId.equals(remoteId)))
        .getSingleOrNull();
  }

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
      watchLastMessageAndCountInEachConversation() async* {
    yield* (db.customSelect(
      '''
      SELECT m.*, latest_msg.new_message_count as new_messages_count
      FROM messages m
      JOIN (
        SELECT conversation_id,
              MAX(created_at) AS max_created_at,
              MAX(local_id) AS max_id,
              SUM(CASE WHEN read_at IS NULL AND read_locally IS false AND sender_id != ${SharedPref.currentUserId} THEN 1 ELSE 0 END) AS new_message_count
        FROM messages
        GROUP BY conversation_id
      ) latest_msg ON m.conversation_id = latest_msg.conversation_id
                AND m.created_at = latest_msg.max_created_at
                AND m.local_id = latest_msg.max_id;

    ''',
      readsFrom: {db.messages},
    )).watch().map((rows) {
      return rows.map((row) {
        return ConversationLastMessageAndCountModel(
          lastMessage: LocalMessage(
            localId: row.read<int>('local_id'),
            remoteId: row.read<int?>('remote_id'),
            senderId: row.read<int>('sender_id'),
            conversationId: row.read<int>('conversation_id'),
            body: row.read<String?>('body'),
            sentAt: row.read<DateTime?>('sent_at'),
            recievedAt: row.read<DateTime?>('recieved_at'),
            receivedLocally: row.read<bool>('received_locally'),
            // confirmGotReceive: row.read<bool>('confirm_got_receive'),
            readAt: row.read<DateTime?>('read_at'),
            readLocally: row.read<bool>('read_locally'),
            // confirmGotRead: row.read<bool>('confirm_got_read'),
            createdAt: row.read<DateTime>('created_at'),
            updatedAt: row.read<DateTime>('updated_at'),
          ),
          newMessagesCount: row.read<int>('new_messages_count'),
        );
      }).toList();
    });
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
  Stream<List<LocalMessage>> watchLastMessageInEachConversation() {
    return (db.customSelect(
      '''
        SELECT m.*, latest_msg.new_message_count
        FROM messages m
        JOIN (
          SELECT conversation_id,
                MAX(created_at) AS max_created_at,
                MAX(local_id) AS max_id,
                SUM(CASE WHEN read_at IS NULL THEN 1 ELSE 0 END) AS new_message_count
          FROM messages
          GROUP BY conversation_id
        ) latest_msg ON m.conversation_id = latest_msg.conversation_id
                  AND m.created_at = latest_msg.max_created_at
                  AND m.local_id = latest_msg.max_id;
    ''',
      readsFrom: {db.messages},
    )).watch().map((rows) {
      return rows.map((row) {
        return LocalMessage(
          localId: row.read<int>('local_id'),
          remoteId: row.read<int>('remote_id'),
          senderId: row.read<int>('sender_id'),
          conversationId: row.read<int>('conversation_id'),
          body: row.read<String?>('body'),
          sentAt: row.read<DateTime?>('sent_at'),
          recievedAt: row.read<DateTime?>('recieved_at'),
          receivedLocally: row.read<bool>('received_locally'),
          // confirmGotReceive: row.read<bool>('confirm_got_receive'),
          readAt: row.read<DateTime?>('read_at'),
          readLocally: row.read<bool>('read_locally'),
          // confirmGotRead: row.read<bool>('confirm_got_read'),
          createdAt: row.read<DateTime>('created_at'),
          updatedAt: row.read<DateTime>('updated_at'),
        );
      }).toList();
    });
  }

  Stream<List<LocalMessage>> watchReadLocallyMessages() {
    return (db.select(messages)
          ..where(
            (tbl) =>
                tbl.readLocally.equals(true) &
                tbl.senderId.isNotIn([SharedPref.currentUserId]),
          ))
        .watch();
  }

  // Future<List<LocalMessage>> getConversationMessages(
  //     int conversationLocalId) async {
  //   return await (db.select(messages)
  //         ..where((tbl) => tbl.conversationId.equals(conversationLocalId)))
  //       .get();
  // }

  Stream<List<LocalMessage>> watchReceivedLocallyMessages() {
    return (db.select(messages)
          ..where(
            (tbl) =>
                tbl.receivedLocally.equals(true) &
                tbl.senderId.isNotIn([SharedPref.currentUserId]),
          ))
        .watch();
  }

  Stream<List<LocalMessage>> watchMessagesNotSent() {
    return (select(db.messages)..where((tbl) => tbl.sentAt.equals(null)))
        .watch();
  }

  /// A function to generate a unique random number that is not present in the table before.
  ///
  /// This function generates a random integer between 0 and 99,999.
  /// It checks if the generated value is not already present in the `moor_conversations` table.
  /// If the generated value exists in the table, it generates another random value until it finds a unique one.
  ///
  /// Returns:
  /// - A `Future<int>` representing the generated unique random number.
  Future<int> getUniqueRandomNumber() async {
    final random = Random();
    int randomValue;
    // Retrieve all existing IDs from the `moor_conversations` table and create a set of existing IDs.
    final existingIds = await select(db.conversations).get().then(
        (list) => list.map((conversation) => conversation.localId).toSet());
    // Generate a random number and check if it is not present in the existing IDs set.
    do {
      randomValue = random.nextInt(1000000);
    } while (existingIds.contains(randomValue));

    return randomValue;
  }
}
