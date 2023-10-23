// import 'package:moor/moor.dart';

import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('LocalConversation')
class Conversations extends Table {
  IntColumn get localId => integer().autoIncrement()();
  IntColumn get remoteId => integer().unique().nullable()();
  // IntColumn get id =>
  //     integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  // .customConstraint('PRIMARY KEY')();
  IntColumn get userId => integer().unique()();
  TextColumn get userName => text()();
  TextColumn get userEmail => text().nullable()();
  TextColumn get userPhone => text().nullable()();
  TextColumn get userImageUrl => text().nullable()();
  BoolColumn get isBlocked => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeletedLocally =>
      boolean().withDefault(const Constant(false))();
  // BoolColumn get isUserProvider =>
  //     boolean().withDefault(const Constant(false))();
  // BoolColumn get isLocal => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // @override
  // Set<Column> get primaryKey => {id};
}

@DataClassName('LocalMessage')
class Messages extends Table {
  IntColumn get localId => integer().autoIncrement()();
  IntColumn get remoteId => integer().unique().nullable()();
  // IntColumn get id =>
  //     integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  // .customConstraint('PRIMARY KEY')();
  TextColumn get body => text().nullable()();
  IntColumn get senderId => integer()();
  IntColumn get conversationId => integer().customConstraint(
      'NOT NULL REFERENCES conversations(local_id) ON DELETE CASCADE')();
  DateTimeColumn get sentAt => dateTime().nullable()();
  DateTimeColumn get recievedAt => dateTime().nullable()();
  BoolColumn get receivedLocally =>
      boolean().withDefault(const Constant(false))();
  // BoolColumn get confirmGotReceive =>
  //     boolean().withDefault(const Constant(false))();

  DateTimeColumn get readAt => dateTime().nullable()();
  BoolColumn get readLocally => boolean().withDefault(const Constant(false))();
  // BoolColumn get confirmGotRead =>
  //     boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // @override
  // Set<Column> get primaryKey => {id};
}

@DataClassName('LocalMultimedia')
class Multimedia extends Table {
  IntColumn get localId => integer().autoIncrement()();
  IntColumn get remoteId => integer().unique().nullable()();
  // IntColumn get id =>
  //     integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();
  // .customConstraint('PRIMARY KEY')();
  TextColumn get type => text().customConstraint(
      'NOT NULL CHECK(type IN (\'image\', \'file\', \'video\', \'audio\', \'archive\'))')();
  TextColumn get path => text().nullable()();
  IntColumn get size => integer()();
  TextColumn get url => text().nullable()();
  TextColumn get fileName => text().customConstraint('NOT NULL')();
  IntColumn get messageId => integer().customConstraint(
      'NOT NULL REFERENCES messages(local_id) ON DELETE CASCADE')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // @override
  // Set<Column> get primaryKey => {id};
}
