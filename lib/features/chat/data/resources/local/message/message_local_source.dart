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

  Stream<List<LocalMessage>> watchConversationMessages(int conversationId) {
    return (db.select(db.messages)
          ..where((tbl) => tbl.conversationId.equals(conversationId))
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

  Future<int> insertMessage(Insertable<LocalMessage> message) async {
    return await into(db.messages).insert(message);
    // final query = select(db.messages)..where((c) => c.localId.equals(localId));
    // return await query.getSingle();
  }

  Future<void> deleteMessages(List<int> messageIds) async {
    delete(db.messages).where((tbl) => tbl.localId.isIn(messageIds));
    // final query = select(db.messages)..where((c) => c.localId.equals(localId));
    // return await query.getSingle();
  }

  Future<void> deleteAllMessagesInConversation(int conversationLocalId) async {
    delete(db.messages)
        .where((tbl) => tbl.conversationId.equals(conversationLocalId));
    // final query = select(db.messages)..where((c) => c.localId.equals(localId));
    // return await query.getSingle();
  }

  Future<LocalMessage> insertMessageAndGetInstance(
      Insertable<LocalMessage> message) async {
    int localId = await into(db.messages).insert(message);
    final query = select(db.messages)..where((c) => c.localId.equals(localId));
    return await query.getSingle();
  }

  Future<void> markConversationMessagesAsReadLocally(int conversationId) async {
    print("markConversationMessagesAsReadLocally");
    (update(db.messages)
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

  Future<bool> updateMessage(Insertable<LocalMessage> message) =>
      update(db.messages).replace(message);

  Stream<List<LocalMessage>> watchReceivedLocallyMessages() {
    return (db.select(messages)
          ..where(
            (tbl) =>
                tbl.receivedLocally.equals(true) &
                tbl.senderId.isNotIn([SharedPref.currentUserId]),
          ))
        .watch();
  }

  Future<List<LocalMessage>> getReceivedLocallyMessages() async {
    return await (db.select(messages)
          ..where(
            (tbl) =>
                tbl.receivedLocally.equals(true) &
                tbl.senderId.isNotIn([SharedPref.currentUserId]),
          ))
        .get();
  }

  Future<void> updateReceivedLocallyToFalse(List<int> remoteIds) {
    return (update(messages)
          ..where((message) => message.remoteId.isIn(remoteIds)))
        .write(
      const MessagesCompanion(
        receivedLocally: Value(false),
      ),
    );
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

  Future<List<LocalMessage>> getReadLocallyMessages() async {
    return await (db.select(messages)
          ..where(
            (tbl) =>
                tbl.receivedLocally.equals(true) &
                tbl.senderId.isNotIn([SharedPref.currentUserId]),
          ))
        .get();
  }

  Future<void> updateReadLocallyToFalse(List<int> remoteIds) {
    return (update(messages)
          ..where((message) => message.remoteId.isIn(remoteIds)))
        .write(
      const MessagesCompanion(
        readLocally: Value(false),
      ),
    );
  }

  Future<List<LocalMessage>> getUnSentMessages() async {
    return (select(db.messages)
          ..where(
            (message) =>
                message.sentAt.isNull() &
                message.senderId.equals(SharedPref.currentUserId),
          ))
        .get();
  }

  Future<void> updateMessagesReceivedAt(
      ReceivedReadMessageModel rrMessages) async {
    (update(db.messages)
          ..where((message) => message.remoteId.equals(rrMessages.id)))
        .write(
      MessagesCompanion(
        recievedAt: Value(rrMessages.at),
        receivedLocally: const Value(false),
      ),
    );
  }

  Future<void> updateMessagesReadAt(ReceivedReadMessageModel rrMessages) async {
    (update(db.messages)
          ..where((message) => message.remoteId.equals(rrMessages.id)))
        .write(
      MessagesCompanion(
        readAt: Value(rrMessages.at),
        readLocally: const Value(false),
      ),
    );
  }

  Future<LocalMessage?> getMessageByRemoteId(int remoteId) {
    return (select(db.messages)..where((c) => c.remoteId.equals(remoteId)))
        .getSingleOrNull();
  }

  Future<int> getConversatioNewMessages(LocalMessage message) async {
    return into(db.messages).insert(message);
  }

  Stream<List<LocalMessage>> watchMessagesNotSent() {
    return (select(db.messages)..where((tbl) => tbl.sentAt.equals(null)))
        .watch();
  }

  Future<List<LocalMessage>> getUnreadMessagesInConversation(
      int conversationId) async {
    return (select(db.messages)
          ..where(
            (message) =>
                message.conversationId.equals(conversationId) &
                message.senderId.isNotIn([SharedPref.currentUserId]) &
                message.readAt.isNull(),
          ))
        .get();
  }

  Stream<List<ConversationLastMessageAndCountModel>>
      watchLastMessageAndCountInEachConversation() {
    return (db.customSelect(
      '''
      SELECT m.*, latest_msg.new_message_count as new_messages_count
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

  Future<List<ConversationLastMessageAndCountModel>>
      fetchLastMessageAndCountInEachConversation() async {
    final result = db.customSelect(
      '''
    SELECT m.*, latest_msg.new_message_count as new_messages_count
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
    );

    final conversationLastMessageAndCountList = await result.map((row) {
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
    }).get();

    return conversationLastMessageAndCountList;
  }

  Stream<List<LocalMessage>> watchReceivedAndNotConfirmedYet() {
    return (select(messages)
          ..where(
            (tbl) =>
                tbl.recievedAt.isNotNull() &
                // tbl.confirmGotReceive.equals(false) &
                tbl.senderId.equals(SharedPref.currentUserId),
          ))
        .watch();
  }

  Stream<List<LocalMessage>> watchReadAndNotConfirmedYet() {
    return (select(messages)
          ..where(
            (tbl) =>
                tbl.readAt.isNotNull() &
                // tbl.confirmGotRead.equals(false) &
                tbl.senderId.equals(SharedPref.currentUserId),
          ))
        .watch();
  }

  Future<void> updateConfirmGotReceiveToTrue(List<int> remoteIds) {
    return (update(messages)
          ..where((message) => message.remoteId.isIn(remoteIds)))
        .write(
      const MessagesCompanion(
          // confirmGotReceive: Value(true),
          ),
    );
  }

  Future<void> updateConfirmGotReadToTrue(List<int> remoteIds) {
    return (update(messages)
          ..where((message) => message.remoteId.isIn(remoteIds)))
        .write(
      const MessagesCompanion(
          // confirmGotRead: Value(true),
          ),
    );
  }

  // Future<void> markMessagesAsReadInConversation(int conversationId) async {
  //   await (update(messages)
  //         ..where((tbl) => tbl.conversationId.equals(conversationId) & tbl.conversationId.equals(conversationId)))
  //       .write(MessagesCompanion(
  //     readAt: Value(DateTime.now()),
  //     readLocally: const Value(true),
  //   ));
  // }

  Future<List<LocalMessage>> getUnReceivedMessagesInConversation(
      int conversationId) async {
    return (select(db.messages)
          ..where(
            (message) =>
                message.conversationId.equals(conversationId) &
                message.recievedAt.isNull(),
          ))
        .get();
  }
  // Stream<List<LocalMessage>> watchLatestMessages() {
  //   final subquery = selectOnly(LatestMessages)
  //     ..addColumns([latestMessages.conversationId, max(latestMessages.maxCreatedAt), latestMessages.maxId])
  //     ..groupBy([latestMessages.conversationId]);

  //   return (select(messages)
  //         ..join([
  //           innerJoin(subquery, subquery.latestMessages.conversationId.equalsExp(messages.conversationId) &
  //               subquery.latestMessages.maxCreatedAt.equalsExp(messages.createdAt) &
  //               subquery.latestMessages.maxId.equalsExp(messages.id)),
  //         ]))
  //       .watch();
  // }
  //     SELECT m.*
  // FROM messages m
  // JOIN (
  //   SELECT conversation_id,
  //         MAX(created_at) AS max_created_at,
  //         MAX(id) AS max_id
  //   FROM messages
  //   GROUP BY conversation_id
  // ) latest_msg ON m.conversation_id = latest_msg.conversation_id
  //           AND m.created_at = latest_msg.max_created_at
  //           AND m.id = latest_msg.max_id;

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
