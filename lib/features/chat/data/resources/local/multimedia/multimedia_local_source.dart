// import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
// import 'package:ashghal_app_frontend/features/chat/data/local_db/tables/chat_tables.dart';
// import 'package:moor_flutter/moor_flutter.dart';

// part 'multimedia_local_source.g.dart';

// // abstract class MultimediaLocalSourceAbstract {

// // }

// @UseDao(
//   tables: [Multimedia],
// )
// class MultimediaLocalSource extends DatabaseAccessor<ChatDatabase>
//     with _$MultimediaLocalSourceMixin {
//   final ChatDatabase db;

//   MultimediaLocalSource(this.db) : super(db);
// //
//   // /// Retrieves multimedia associated with a message by its message ID.
//   // ///
//   // /// Returns a [Future] that resolves to a [LocalMultimedia] object representing
//   // /// the multimedia associated with the message with the specified message ID if found,
//   // /// or `null` if no matching multimedia is found.
//   // ///
//   // /// Use this method to retrieve multimedia content associated with a message.
//   // ///
//   // /// - [messageId]: The message ID of the message to find multimedia for.
//   // Future<LocalMultimedia?> getMessageMultimedia(int messageId) async {
//   //   return await (select(db.multimedia)
//   //         ..where(
//   //           (mul) => mul.messageId.equals(messageId),
//   //         ))
//   //       .getSingleOrNull();
//   // }
// //
//   // /// Inserts multimedia data into the database.
//   // ///
//   // /// Returns a [Future] that resolves to the ID of the inserted multimedia data if
//   // /// the insertion is successful, or throws an exception on failure.
//   // ///
//   // /// Use this method to insert multimedia data into the local database.
//   // ///
//   // /// - [multimedia]: The multimedia data to insert, represented as an [Insertable<LocalMultimedia>] object.
//   // Future<int> insertMultimedia(Insertable<LocalMultimedia> multimedia) async {
//   //   return await into(db.multimedia).insert(multimedia);
//   // }
// //
//   // /// Updates multimedia data in the database.
//   // ///
//   // /// Returns a [Future] that resolves to `true` if the multimedia data was successfully updated,
//   // /// or `false` if the update operation failed.
//   // ///
//   // /// Use this method to update multimedia data in the database.
//   // ///
//   // /// - [multimedia]: An [Insertable<LocalMultimedia>] representing the multimedia data to update.
//   // Future<int> updateMultimedia(
//   //     Insertable<LocalMultimedia> multimedia, int multimediaLocalId) async {
//   //   return await (update(db.multimedia)
//   //         ..where(
//   //           (tbl) => tbl.localId.equals(multimediaLocalId),
//   //         ))
//   //       .write(multimedia);
//   // }
// //
// //   /// Streams multimedia content related to a specific conversation's messages.
// //   ///
// //   /// Returns a [Stream] that emits a list of [LocalMultimedia] objects representing multimedia content
// //   /// associated with messages within the specified conversation. The stream updates whenever there is
// //   /// a change in the multimedia content for the conversation.
// //   ///
// //   /// Use this method to observe multimedia content for a particular conversation.
// //   ///
// //   /// Example usage:
// //   /// ```dart
// //   /// final source = MultimediaLocalSource(ChatDatabase());
// //   /// final conversationId = 123;
// //   ///
// //   /// final multimediaStream = source.watchConversationMessagesMultimedia(conversationId);
// //   ///
// //   /// multimediaStream.listen((multimediaContent) {
// //   ///   print("Updated Multimedia Content: $multimediaContent");
// //   /// });
// //   /// ```
// //   /// - [conversationId]: The ID of the conversation for which to retrieve multimedia content.
// //   Stream<List<LocalMultimedia>> watchConversationMessagesMultimedia(
// //       int conversationId) {
// //     return (db.customSelect(
// //       '''
// //   select * from multimedia where message_id in (select local_id from messages where conversation_id ==$conversationId)
// // ''',
// //       readsFrom: {db.multimedia, db.messages},
// //     )).watch().map((rows) {
// //       return rows.map((row) {
// //         return LocalMultimedia(
// //           localId: row.read<int>('local_id'),
// //           remoteId: row.read<int?>('remote_id'),
// //           type: row.read<String>('type'),
// //           path: row.read<String?>('path'),
// //           url: row.read<String?>('url'),
// //           size: row.read<int>('size'),
// //           fileName: row.read<String>('file_name'),
// //           messageId: row.read<int>('message_id'),
// //           createdAt: row.read<DateTime>('created_at'),
// //           updatedAt: row.read<DateTime>('updated_at'),
// //         );
// //       }).toList();
// //     });
// //   }

//   // Future<void> deleteMessageMultimedia(int messageLocal)

//   /// Deletes multimedia content associated with a specific conversation.
//   ///
//   /// This method deletes multimedia content records from the local data source that are associated
//   /// with a given conversation ID. It ensures that multimedia content related to messages within
//   /// the specified conversation is removed.
//   ///
//   /// Use this method to clean up multimedia content when a conversation is deleted.
//   ///
//   /// Example usage:
//   /// ```dart
//   /// final source = MultimediaLocalSource(ChatDatabase());
//   /// final conversationId = 123;
//   ///
//   /// await source.deleteConversationMessagesMultimedia(conversationId);
//   /// ```
//   ///
//   /// - [conversationId]: The ID of the conversation for which multimedia content should be deleted.
//   // Future<void> deleteConversationMessagesMultimedia(int conversationId) async {
//   //   delete(db.multimedia).where((mul) =>
//   //       mul.messageId.isNotNull() &
//   //       mul.messageId.isInQuery(select(db.messages)
//   //         ..where((tbl) => tbl.conversationId.equals(conversationId))));
//   // }
// }
