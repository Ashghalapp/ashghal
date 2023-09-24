import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/tables/chat_tables.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'multimedia_local_source.g.dart';

@UseDao(
  tables: [Multimedia],
)
class MultimediaLocalSource extends DatabaseAccessor<ChatDatabase>
    with _$MultimediaLocalSourceMixin {
  final ChatDatabase db;

  MultimediaLocalSource(this.db) : super(db);

  Future<LocalMultimedia?> getMessageMultimedia(int messageId) {
    return (select(db.multimedia)
          ..where(
            (mul) => mul.localId.equals(messageId),
          ))
        .getSingleOrNull();
  }

  Future<int> insertMultimedia(Insertable<LocalMultimedia> multimedia) async {
    return await into(db.multimedia).insert(multimedia);
    // final query = select(db.messages)..where((c) => c.localId.equals(localId));
    // return await query.getSingle();
  }

  Future<bool> updateMultimedia(Insertable<LocalMultimedia> multimedia) =>
      update(db.multimedia).replace(multimedia);

  Stream<List<LocalMultimedia>> watchConversationMessagesMultimedia(
      int conversationId) {
    return (select(db.multimedia)
          ..where((mul) =>
              mul.messageId.isNotNull() &
              mul.messageId.isInQuery(select(db.conversations)
                ..where((tbl) => tbl.localId.equals(conversationId)))))
        .watch();
  }

  Future<void> deleteConversationMessagesMultimedia(int conversationId) async {
    delete(db.multimedia).where((mul) =>
        mul.messageId.isNotNull() &
        mul.messageId.isInQuery(select(db.conversations)
          ..where((tbl) => tbl.localId.equals(conversationId))));
  }
}
