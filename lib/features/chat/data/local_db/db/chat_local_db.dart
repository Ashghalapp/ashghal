import 'dart:ffi';

import 'package:ashghal_app_frontend/features/chat/data/local_db/tables/chat_tables.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/conversation/conversation_local_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/message/message_local_source.dart';
import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'chat_local_db.g.dart';

@UseMoor(
    tables: [Conversations, Messages, Multimedia],
    daos: [ConversationLocalSource, MessageLocalSource])
class ChatDatabase extends _$ChatDatabase {
  ChatDatabase._()
      : super(FlutterQueryExecutor.inDatabaseFolder(
          path: 'chatdb.sqlite',
          logStatements: true,
        ));

  static final ChatDatabase _instance = ChatDatabase._();

  factory ChatDatabase() {
    return _instance;
  }

  @override
  int get schemaVersion => 2;
  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (dertials) async {
          await customStatement("PRAGMA foreign_keys = ON");
        },
        onUpgrade: (m, from, to) async {
          if (from == 1 && to == 2) {
            await m.addColumn(messages, messages.isStarred);
          }
        },
      );
}
