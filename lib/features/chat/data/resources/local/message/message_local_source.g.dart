// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_local_source.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$MessageLocalSourceMixin on DatabaseAccessor<ChatDatabase> {
  $MessagesTable get messages => attachedDatabase.messages;
  $MultimediaTable get multimedia => attachedDatabase.multimedia;
  Selectable<LocalMessage> newMessagesNotSent() {
    return customSelect('select * from messages where sent_at is null;',
        variables: [],
        readsFrom: {
          messages,
        }).map(messages.mapFromRow);
  }
}
