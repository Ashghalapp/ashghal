import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/tables/chat_tables.dart';
import 'package:moor_flutter/moor_flutter.dart';
// import 'package:moor/moor.dart';

part 'conversation_local_source.g.dart';

// class ConversationWithNewMessagesAndLastMessage {
//   final Conversations conversation;
//   final int newMessageCount;
//   final Messages? lastMessage;

//   ConversationWithNewMessagesAndLastMessage({
//     required this.conversation,
//     required this.newMessageCount,
//     this.lastMessage,
//   });
// }

@UseDao(tables: [Conversations, Messages])
class ConversationLocalSource extends DatabaseAccessor<ChatDatabase>
    with _$ConversationLocalSourceMixin {
  final ChatDatabase db;

  ConversationLocalSource(this.db) : super(db);

  Future<List<LocalConversation>> getLocalConversations() {
    return (select(db.conversations)..where((c) => c.remoteId.equals(null)))
        .get();
  }

  Future<List<LocalConversation>> getAllConversations() {
    return (select(db.conversations)).get();
  }

  Future<bool> updateConversation(Insertable<LocalConversation> conversation) =>
      update(db.conversations).replace(conversation);

  Future<void> refreshConversationUpdatedAt(int conversationID) async {
    final query = select(db.conversations)
      ..where((c) => c.localId.equals(conversationID));
    LocalConversation conversation = await query.getSingle();
    print("refresh function");
    updateConversation(conversation.copyWith(updatedAt: DateTime.now()));
    //  (update(db.conversations)..where((tbl) => tbl.localId.equals(conversationID))).
  }

  Future<LocalConversation> startConversation(
      Insertable<LocalConversation> conversation) async {
    print("*****************before insert");
    final localId = await into(db.conversations).insert(conversation);
    print("*****************after insert");

    final query = select(db.conversations)
      ..where((c) => c.localId.equals(localId));
    print("*****************after select");

    return await query.getSingle();
  }

  Future<int> insertConversation(Insertable<LocalConversation> conversation) =>
      into(db.conversations).insert(conversation);

  Future<LocalConversation?> getConversationWith(int userid) {
    return (select(db.conversations)..where((c) => c.userId.equals(userid)))
        .getSingleOrNull();
  }

  Future<LocalConversation?> getConversationWithRemoteId(int remoteId) {
    return (select(db.conversations)..where((c) => c.remoteId.equals(remoteId)))
        .getSingleOrNull();
  }

  Future<int?> getRemoteIdByLocalId(int localId) async {
    final query = select(db.conversations)
      ..where((c) => c.localId.equals(localId))
      ..limit(1);

    final result = await query.getSingleOrNull();

    return result?.remoteId;
  }

  Future<bool> deleteConversationByLocalId(int localId) async {
    final query = delete(db.conversations)
      ..where((c) => c.localId.equals(localId));

    try {
      await query.go();
      return true; // Deletion successful
    } catch (_) {
      return false; // Deletion failed
    }
  }

  /// A function to get all conversations from local storage.
  ///
  /// This function retrieves all conversations stored in the local
  /// database and returns them as a list of [Conversation] objects.
  ///
  /// Returns:
  /// - A [Future] that completes with a list of [Conversation] objects
  ///   representing all the conversations in the local database.

  Future<List<LocalConversation>> findAllConversations() =>
      select(db.conversations).get();

  Future<LocalConversation?> getConversationByLocalId(int localId) {
    return (select(db.conversations)..where((c) => c.localId.equals(localId)))
        .getSingleOrNull();
  }

  Future<LocalConversation?> getConversationByRemoteId(int remoteId) {
    return (select(db.conversations)..where((c) => c.remoteId.equals(remoteId)))
        .getSingleOrNull();
  }

  Stream<List<LocalConversation>> watchAllConversations() {
    return (select(db.conversations)
          ..orderBy(
            [
              (table) => OrderingTerm(
                    expression: table.updatedAt,
                    mode: OrderingMode.desc,
                  )
            ],
          ))
        .watch();
  }

  Future<int> deleteConversation(LocalConversation conversation) async {
    // final conversation = ConversationsCompanion(id: Value(conversationId));
    return await delete(db.conversations).delete(conversation);
  }

  Future<void> blockUnblockConversation(int conversationLocalId, bool block) {
    return (update(db.conversations)
          ..where((conversation) =>
              conversation.localId.equals(conversationLocalId)))
        .write(
      ConversationsCompanion(
        isBlocked: Value(block),
      ),
    );
  }

  // Future<int> getUniqueRandomNumber() async {
  //   final random = Random();
  //   int randomValue;
  //   // Retrieve all existing IDs from the `moor_conversations` table and create a set of existing IDs.
  //   final existingIds = await select(db.conversations)
  //       .get()
  //       .then((list) => list.map((conversation) => conversation.id).toSet());
  //   // Generate a random number and check if it is not present in the existing IDs set.
  //   do {
  //     randomValue = random.nextInt(1000000);
  //   } while (existingIds.contains(randomValue));

  //   return randomValue;
  // }

  /// A function to get a conversation by its associated user ID from local storage.
  ///
  /// This function retrieves a conversation from the local database
  /// based on the provided [userId] and returns it as a [Conversation] object.
  ///
  /// Parameters:
  /// - [userId]: The ID of the associated user of the conversation to retrieve.
  ///
  /// Returns:
  /// - A [Future] that completes with a [Conversation] object representing
  ///   the conversation with the specified [userId]. If no conversation is found
  ///   with the provided [userId], the future completes with `null`.
  // Future<Conversation?> getConversationWithUser(int userId) {
  //   (select(conversations)..orderBy([
  //     (t)=>OrderingTerm.desc(t.createdAt)
  //   ])).join([
  //     leftOuterJoin(other, on)
  //   ])
  //   return (select(db.conversations)..where((c) => c.userId.equals(userId)))
  //       .getSingleOrNull();
  // }
  // Stream<List<ConversationWithNewMessagesAndLastMessage>>
  //     watchConversationsWithNewMessages() {
  //   // Subquery to count new messages for each conversation
  //   final newMessagesSubquery = selectOnly(messages)
  //     ..addColumns([messages.conversationId])
  //     ..where(messages.readAt.isNull())
  //     ..groupBy([messages.conversationId]);
  //   // Custom select query to join conversations with the count of new messages
  //   final customSelectQuery = customSelect([
  //     conversations,
  //     ifThenElse(newMessagesSubquery.exists, 1, 0).as('newMessageCount'),
  //   ]).join([
  //     leftOuterJoin(
  //       newMessagesSubquery,
  //       customSelectQuery.d(conversations.id) ==
  //           newMessagesSubquery.d(messages.conversationId),
  //     ),
  //   ]);
  //   return customSelectQuery.watch().map((rows) {
  //     return rows.map((row) {
  //       final conversation = ConversationsTable().mapFromRow(row.readTable(conversations));
  //       final newMessageCount = row.readInt('newMessageCount');
  //       return ConversationWithNewMessagesAndLastMessage(
  //         conversation: conversation,
  //         newMessageCount: newMessageCount,
  //       );
  //     }).toList();
  //   });
  // }

  /// A function to insert or update a conversation in the local storage.
  ///
  /// If the provided [conversation] has an ID of -1, a unique random ID will
  /// be generated and set as the ID of the conversation before inserting it.
  /// If the conversation already has a valid ID, it will be updated in the
  /// database.
  ///
  /// Parameters:
  /// - [conversation]: The conversation to be inserted or updated.
  ///
  /// Returns:
  /// - A [Future] that completes when the operation is finished.

  /// A function to update a conversation in the local storage.
  ///
  /// Parameters:
  /// - [conversation]: The conversation to be updated.
  ///
  /// Returns:
  /// - A [Future] that completes when the update operation is finished.

  /// A function to delete a conversation from the local storage.
  ///
  /// Parameters:
  /// - [conversation]: The conversation to be deleted.
  ///
  /// Returns:
  /// - A [Future] that completes when the delete operation is finished.

  /// A function to generate a unique random number that is not present in the table before.
  ///
  /// This function generates a random integer between 0 and 99,999.
  /// It checks if the generated value is not already present in the `moor_conversations` table.
  /// If the generated value exists in the table, it generates another random value until it finds a unique one.
  ///
  /// Returns:
  /// - A `Future<int>` representing the generated unique random number.
}
