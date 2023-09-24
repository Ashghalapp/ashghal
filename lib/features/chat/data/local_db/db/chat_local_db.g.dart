// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_local_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class LocalConversation extends DataClass
    implements Insertable<LocalConversation> {
  final int localId;
  final int? remoteId;
  final int userId;
  final String userName;
  final String? userEmail;
  final String? userPhone;
  final String? userImageUrl;
  final bool isBlocked;
  final DateTime createdAt;
  final DateTime updatedAt;
  LocalConversation(
      {required this.localId,
      this.remoteId,
      required this.userId,
      required this.userName,
      this.userEmail,
      this.userPhone,
      this.userImageUrl,
      required this.isBlocked,
      required this.createdAt,
      required this.updatedAt});
  factory LocalConversation.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LocalConversation(
      localId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}local_id'])!,
      remoteId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}remote_id']),
      userId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      userName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_name'])!,
      userEmail: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_email']),
      userPhone: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_phone']),
      userImageUrl: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_image_url']),
      isBlocked: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_blocked'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int?>(remoteId);
    }
    map['user_id'] = Variable<int>(userId);
    map['user_name'] = Variable<String>(userName);
    if (!nullToAbsent || userEmail != null) {
      map['user_email'] = Variable<String?>(userEmail);
    }
    if (!nullToAbsent || userPhone != null) {
      map['user_phone'] = Variable<String?>(userPhone);
    }
    if (!nullToAbsent || userImageUrl != null) {
      map['user_image_url'] = Variable<String?>(userImageUrl);
    }
    map['is_blocked'] = Variable<bool>(isBlocked);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ConversationsCompanion toCompanion(bool nullToAbsent) {
    return ConversationsCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      userId: Value(userId),
      userName: Value(userName),
      userEmail: userEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(userEmail),
      userPhone: userPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(userPhone),
      userImageUrl: userImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(userImageUrl),
      isBlocked: Value(isBlocked),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalConversation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LocalConversation(
      localId: serializer.fromJson<int>(json['localId']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      userId: serializer.fromJson<int>(json['userId']),
      userName: serializer.fromJson<String>(json['userName']),
      userEmail: serializer.fromJson<String?>(json['userEmail']),
      userPhone: serializer.fromJson<String?>(json['userPhone']),
      userImageUrl: serializer.fromJson<String?>(json['userImageUrl']),
      isBlocked: serializer.fromJson<bool>(json['isBlocked']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'remoteId': serializer.toJson<int?>(remoteId),
      'userId': serializer.toJson<int>(userId),
      'userName': serializer.toJson<String>(userName),
      'userEmail': serializer.toJson<String?>(userEmail),
      'userPhone': serializer.toJson<String?>(userPhone),
      'userImageUrl': serializer.toJson<String?>(userImageUrl),
      'isBlocked': serializer.toJson<bool>(isBlocked),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalConversation copyWith(
          {int? localId,
          int? remoteId,
          int? userId,
          String? userName,
          String? userEmail,
          String? userPhone,
          String? userImageUrl,
          bool? isBlocked,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      LocalConversation(
        localId: localId ?? this.localId,
        remoteId: remoteId ?? this.remoteId,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userEmail: userEmail ?? this.userEmail,
        userPhone: userPhone ?? this.userPhone,
        userImageUrl: userImageUrl ?? this.userImageUrl,
        isBlocked: isBlocked ?? this.isBlocked,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('LocalConversation(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('userId: $userId, ')
          ..write('userName: $userName, ')
          ..write('userEmail: $userEmail, ')
          ..write('userPhone: $userPhone, ')
          ..write('userImageUrl: $userImageUrl, ')
          ..write('isBlocked: $isBlocked, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(localId, remoteId, userId, userName,
      userEmail, userPhone, userImageUrl, isBlocked, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalConversation &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.userId == this.userId &&
          other.userName == this.userName &&
          other.userEmail == this.userEmail &&
          other.userPhone == this.userPhone &&
          other.userImageUrl == this.userImageUrl &&
          other.isBlocked == this.isBlocked &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ConversationsCompanion extends UpdateCompanion<LocalConversation> {
  final Value<int> localId;
  final Value<int?> remoteId;
  final Value<int> userId;
  final Value<String> userName;
  final Value<String?> userEmail;
  final Value<String?> userPhone;
  final Value<String?> userImageUrl;
  final Value<bool> isBlocked;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ConversationsCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.userId = const Value.absent(),
    this.userName = const Value.absent(),
    this.userEmail = const Value.absent(),
    this.userPhone = const Value.absent(),
    this.userImageUrl = const Value.absent(),
    this.isBlocked = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ConversationsCompanion.insert({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    required int userId,
    required String userName,
    this.userEmail = const Value.absent(),
    this.userPhone = const Value.absent(),
    this.userImageUrl = const Value.absent(),
    this.isBlocked = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : userId = Value(userId),
        userName = Value(userName);
  static Insertable<LocalConversation> custom({
    Expression<int>? localId,
    Expression<int?>? remoteId,
    Expression<int>? userId,
    Expression<String>? userName,
    Expression<String?>? userEmail,
    Expression<String?>? userPhone,
    Expression<String?>? userImageUrl,
    Expression<bool>? isBlocked,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (userId != null) 'user_id': userId,
      if (userName != null) 'user_name': userName,
      if (userEmail != null) 'user_email': userEmail,
      if (userPhone != null) 'user_phone': userPhone,
      if (userImageUrl != null) 'user_image_url': userImageUrl,
      if (isBlocked != null) 'is_blocked': isBlocked,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ConversationsCompanion copyWith(
      {Value<int>? localId,
      Value<int?>? remoteId,
      Value<int>? userId,
      Value<String>? userName,
      Value<String?>? userEmail,
      Value<String?>? userPhone,
      Value<String?>? userImageUrl,
      Value<bool>? isBlocked,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ConversationsCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      isBlocked: isBlocked ?? this.isBlocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int?>(remoteId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (userEmail.present) {
      map['user_email'] = Variable<String?>(userEmail.value);
    }
    if (userPhone.present) {
      map['user_phone'] = Variable<String?>(userPhone.value);
    }
    if (userImageUrl.present) {
      map['user_image_url'] = Variable<String?>(userImageUrl.value);
    }
    if (isBlocked.present) {
      map['is_blocked'] = Variable<bool>(isBlocked.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('userId: $userId, ')
          ..write('userName: $userName, ')
          ..write('userEmail: $userEmail, ')
          ..write('userPhone: $userPhone, ')
          ..write('userImageUrl: $userImageUrl, ')
          ..write('isBlocked: $isBlocked, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ConversationsTable extends Conversations
    with TableInfo<$ConversationsTable, LocalConversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _localIdMeta = const VerificationMeta('localId');
  @override
  late final GeneratedColumn<int?> localId = GeneratedColumn<int?>(
      'local_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _remoteIdMeta = const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<int?> remoteId = GeneratedColumn<int?>(
      'remote_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'UNIQUE');
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int?> userId = GeneratedColumn<int?>(
      'user_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      defaultConstraints: 'UNIQUE');
  final VerificationMeta _userNameMeta = const VerificationMeta('userName');
  @override
  late final GeneratedColumn<String?> userName = GeneratedColumn<String?>(
      'user_name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _userEmailMeta = const VerificationMeta('userEmail');
  @override
  late final GeneratedColumn<String?> userEmail = GeneratedColumn<String?>(
      'user_email', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _userPhoneMeta = const VerificationMeta('userPhone');
  @override
  late final GeneratedColumn<String?> userPhone = GeneratedColumn<String?>(
      'user_phone', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _userImageUrlMeta =
      const VerificationMeta('userImageUrl');
  @override
  late final GeneratedColumn<String?> userImageUrl = GeneratedColumn<String?>(
      'user_image_url', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _isBlockedMeta = const VerificationMeta('isBlocked');
  @override
  late final GeneratedColumn<bool?> isBlocked = GeneratedColumn<bool?>(
      'is_blocked', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_blocked IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        localId,
        remoteId,
        userId,
        userName,
        userEmail,
        userPhone,
        userImageUrl,
        isBlocked,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'conversations';
  @override
  String get actualTableName => 'conversations';
  @override
  VerificationContext validateIntegrity(Insertable<LocalConversation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('user_name')) {
      context.handle(_userNameMeta,
          userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta));
    } else if (isInserting) {
      context.missing(_userNameMeta);
    }
    if (data.containsKey('user_email')) {
      context.handle(_userEmailMeta,
          userEmail.isAcceptableOrUnknown(data['user_email']!, _userEmailMeta));
    }
    if (data.containsKey('user_phone')) {
      context.handle(_userPhoneMeta,
          userPhone.isAcceptableOrUnknown(data['user_phone']!, _userPhoneMeta));
    }
    if (data.containsKey('user_image_url')) {
      context.handle(
          _userImageUrlMeta,
          userImageUrl.isAcceptableOrUnknown(
              data['user_image_url']!, _userImageUrlMeta));
    }
    if (data.containsKey('is_blocked')) {
      context.handle(_isBlockedMeta,
          isBlocked.isAcceptableOrUnknown(data['is_blocked']!, _isBlockedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LocalConversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LocalConversation.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ConversationsTable createAlias(String alias) {
    return $ConversationsTable(attachedDatabase, alias);
  }
}

class LocalMessage extends DataClass implements Insertable<LocalMessage> {
  final int localId;
  final int? remoteId;
  final String? body;
  final int senderId;
  final int conversationId;
  final DateTime? sentAt;
  final DateTime? recievedAt;
  final bool receivedLocally;
  final DateTime? readAt;
  final bool readLocally;
  final DateTime createdAt;
  final DateTime updatedAt;
  LocalMessage(
      {required this.localId,
      this.remoteId,
      this.body,
      required this.senderId,
      required this.conversationId,
      this.sentAt,
      this.recievedAt,
      required this.receivedLocally,
      this.readAt,
      required this.readLocally,
      required this.createdAt,
      required this.updatedAt});
  factory LocalMessage.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LocalMessage(
      localId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}local_id'])!,
      remoteId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}remote_id']),
      body: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}body']),
      senderId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sender_id'])!,
      conversationId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}conversation_id'])!,
      sentAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sent_at']),
      recievedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}recieved_at']),
      receivedLocally: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}received_locally'])!,
      readAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}read_at']),
      readLocally: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}read_locally'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int?>(remoteId);
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String?>(body);
    }
    map['sender_id'] = Variable<int>(senderId);
    map['conversation_id'] = Variable<int>(conversationId);
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime?>(sentAt);
    }
    if (!nullToAbsent || recievedAt != null) {
      map['recieved_at'] = Variable<DateTime?>(recievedAt);
    }
    map['received_locally'] = Variable<bool>(receivedLocally);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime?>(readAt);
    }
    map['read_locally'] = Variable<bool>(readLocally);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      senderId: Value(senderId),
      conversationId: Value(conversationId),
      sentAt:
          sentAt == null && nullToAbsent ? const Value.absent() : Value(sentAt),
      recievedAt: recievedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(recievedAt),
      receivedLocally: Value(receivedLocally),
      readAt:
          readAt == null && nullToAbsent ? const Value.absent() : Value(readAt),
      readLocally: Value(readLocally),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LocalMessage(
      localId: serializer.fromJson<int>(json['localId']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      body: serializer.fromJson<String?>(json['body']),
      senderId: serializer.fromJson<int>(json['senderId']),
      conversationId: serializer.fromJson<int>(json['conversationId']),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
      recievedAt: serializer.fromJson<DateTime?>(json['recievedAt']),
      receivedLocally: serializer.fromJson<bool>(json['receivedLocally']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
      readLocally: serializer.fromJson<bool>(json['readLocally']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'remoteId': serializer.toJson<int?>(remoteId),
      'body': serializer.toJson<String?>(body),
      'senderId': serializer.toJson<int>(senderId),
      'conversationId': serializer.toJson<int>(conversationId),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
      'recievedAt': serializer.toJson<DateTime?>(recievedAt),
      'receivedLocally': serializer.toJson<bool>(receivedLocally),
      'readAt': serializer.toJson<DateTime?>(readAt),
      'readLocally': serializer.toJson<bool>(readLocally),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalMessage copyWith(
          {int? localId,
          int? remoteId,
          String? body,
          int? senderId,
          int? conversationId,
          DateTime? sentAt,
          DateTime? recievedAt,
          bool? receivedLocally,
          DateTime? readAt,
          bool? readLocally,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      LocalMessage(
        localId: localId ?? this.localId,
        remoteId: remoteId ?? this.remoteId,
        body: body ?? this.body,
        senderId: senderId ?? this.senderId,
        conversationId: conversationId ?? this.conversationId,
        sentAt: sentAt ?? this.sentAt,
        recievedAt: recievedAt ?? this.recievedAt,
        receivedLocally: receivedLocally ?? this.receivedLocally,
        readAt: readAt ?? this.readAt,
        readLocally: readLocally ?? this.readLocally,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('LocalMessage(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('body: $body, ')
          ..write('senderId: $senderId, ')
          ..write('conversationId: $conversationId, ')
          ..write('sentAt: $sentAt, ')
          ..write('recievedAt: $recievedAt, ')
          ..write('receivedLocally: $receivedLocally, ')
          ..write('readAt: $readAt, ')
          ..write('readLocally: $readLocally, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      localId,
      remoteId,
      body,
      senderId,
      conversationId,
      sentAt,
      recievedAt,
      receivedLocally,
      readAt,
      readLocally,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMessage &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.body == this.body &&
          other.senderId == this.senderId &&
          other.conversationId == this.conversationId &&
          other.sentAt == this.sentAt &&
          other.recievedAt == this.recievedAt &&
          other.receivedLocally == this.receivedLocally &&
          other.readAt == this.readAt &&
          other.readLocally == this.readLocally &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MessagesCompanion extends UpdateCompanion<LocalMessage> {
  final Value<int> localId;
  final Value<int?> remoteId;
  final Value<String?> body;
  final Value<int> senderId;
  final Value<int> conversationId;
  final Value<DateTime?> sentAt;
  final Value<DateTime?> recievedAt;
  final Value<bool> receivedLocally;
  final Value<DateTime?> readAt;
  final Value<bool> readLocally;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MessagesCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.body = const Value.absent(),
    this.senderId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.recievedAt = const Value.absent(),
    this.receivedLocally = const Value.absent(),
    this.readAt = const Value.absent(),
    this.readLocally = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MessagesCompanion.insert({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.body = const Value.absent(),
    required int senderId,
    required int conversationId,
    this.sentAt = const Value.absent(),
    this.recievedAt = const Value.absent(),
    this.receivedLocally = const Value.absent(),
    this.readAt = const Value.absent(),
    this.readLocally = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : senderId = Value(senderId),
        conversationId = Value(conversationId);
  static Insertable<LocalMessage> custom({
    Expression<int>? localId,
    Expression<int?>? remoteId,
    Expression<String?>? body,
    Expression<int>? senderId,
    Expression<int>? conversationId,
    Expression<DateTime?>? sentAt,
    Expression<DateTime?>? recievedAt,
    Expression<bool>? receivedLocally,
    Expression<DateTime?>? readAt,
    Expression<bool>? readLocally,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (body != null) 'body': body,
      if (senderId != null) 'sender_id': senderId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (sentAt != null) 'sent_at': sentAt,
      if (recievedAt != null) 'recieved_at': recievedAt,
      if (receivedLocally != null) 'received_locally': receivedLocally,
      if (readAt != null) 'read_at': readAt,
      if (readLocally != null) 'read_locally': readLocally,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MessagesCompanion copyWith(
      {Value<int>? localId,
      Value<int?>? remoteId,
      Value<String?>? body,
      Value<int>? senderId,
      Value<int>? conversationId,
      Value<DateTime?>? sentAt,
      Value<DateTime?>? recievedAt,
      Value<bool>? receivedLocally,
      Value<DateTime?>? readAt,
      Value<bool>? readLocally,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MessagesCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      body: body ?? this.body,
      senderId: senderId ?? this.senderId,
      conversationId: conversationId ?? this.conversationId,
      sentAt: sentAt ?? this.sentAt,
      recievedAt: recievedAt ?? this.recievedAt,
      receivedLocally: receivedLocally ?? this.receivedLocally,
      readAt: readAt ?? this.readAt,
      readLocally: readLocally ?? this.readLocally,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int?>(remoteId.value);
    }
    if (body.present) {
      map['body'] = Variable<String?>(body.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<int>(senderId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<int>(conversationId.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime?>(sentAt.value);
    }
    if (recievedAt.present) {
      map['recieved_at'] = Variable<DateTime?>(recievedAt.value);
    }
    if (receivedLocally.present) {
      map['received_locally'] = Variable<bool>(receivedLocally.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime?>(readAt.value);
    }
    if (readLocally.present) {
      map['read_locally'] = Variable<bool>(readLocally.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('body: $body, ')
          ..write('senderId: $senderId, ')
          ..write('conversationId: $conversationId, ')
          ..write('sentAt: $sentAt, ')
          ..write('recievedAt: $recievedAt, ')
          ..write('receivedLocally: $receivedLocally, ')
          ..write('readAt: $readAt, ')
          ..write('readLocally: $readLocally, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages
    with TableInfo<$MessagesTable, LocalMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _localIdMeta = const VerificationMeta('localId');
  @override
  late final GeneratedColumn<int?> localId = GeneratedColumn<int?>(
      'local_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _remoteIdMeta = const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<int?> remoteId = GeneratedColumn<int?>(
      'remote_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'UNIQUE');
  final VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String?> body = GeneratedColumn<String?>(
      'body', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _senderIdMeta = const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<int?> senderId = GeneratedColumn<int?>(
      'sender_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _conversationIdMeta =
      const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<int?> conversationId = GeneratedColumn<int?>(
      'conversation_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES conversations(local_id) ON DELETE CASCADE');
  final VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime?> sentAt = GeneratedColumn<DateTime?>(
      'sent_at', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _recievedAtMeta = const VerificationMeta('recievedAt');
  @override
  late final GeneratedColumn<DateTime?> recievedAt = GeneratedColumn<DateTime?>(
      'recieved_at', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _receivedLocallyMeta =
      const VerificationMeta('receivedLocally');
  @override
  late final GeneratedColumn<bool?> receivedLocally = GeneratedColumn<bool?>(
      'received_locally', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (received_locally IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime?> readAt = GeneratedColumn<DateTime?>(
      'read_at', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _readLocallyMeta =
      const VerificationMeta('readLocally');
  @override
  late final GeneratedColumn<bool?> readLocally = GeneratedColumn<bool?>(
      'read_locally', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (read_locally IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        localId,
        remoteId,
        body,
        senderId,
        conversationId,
        sentAt,
        recievedAt,
        receivedLocally,
        readAt,
        readLocally,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'messages';
  @override
  String get actualTableName => 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<LocalMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
          _conversationIdMeta,
          conversationId.isAcceptableOrUnknown(
              data['conversation_id']!, _conversationIdMeta));
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('sent_at')) {
      context.handle(_sentAtMeta,
          sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta));
    }
    if (data.containsKey('recieved_at')) {
      context.handle(
          _recievedAtMeta,
          recievedAt.isAcceptableOrUnknown(
              data['recieved_at']!, _recievedAtMeta));
    }
    if (data.containsKey('received_locally')) {
      context.handle(
          _receivedLocallyMeta,
          receivedLocally.isAcceptableOrUnknown(
              data['received_locally']!, _receivedLocallyMeta));
    }
    if (data.containsKey('read_at')) {
      context.handle(_readAtMeta,
          readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta));
    }
    if (data.containsKey('read_locally')) {
      context.handle(
          _readLocallyMeta,
          readLocally.isAcceptableOrUnknown(
              data['read_locally']!, _readLocallyMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LocalMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LocalMessage.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class LocalMultimedia extends DataClass implements Insertable<LocalMultimedia> {
  final int localId;
  final int? remoteId;
  final String type;
  final String? path;
  final String? url;
  final String fileName;
  final int messageId;
  final DateTime createdAt;
  final DateTime updatedAt;
  LocalMultimedia(
      {required this.localId,
      this.remoteId,
      required this.type,
      this.path,
      this.url,
      required this.fileName,
      required this.messageId,
      required this.createdAt,
      required this.updatedAt});
  factory LocalMultimedia.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LocalMultimedia(
      localId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}local_id'])!,
      remoteId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}remote_id']),
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      path: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}path']),
      url: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}url']),
      fileName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}file_name'])!,
      messageId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}message_id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int?>(remoteId);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String?>(path);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String?>(url);
    }
    map['file_name'] = Variable<String>(fileName);
    map['message_id'] = Variable<int>(messageId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MultimediaCompanion toCompanion(bool nullToAbsent) {
    return MultimediaCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      type: Value(type),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      fileName: Value(fileName),
      messageId: Value(messageId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalMultimedia.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LocalMultimedia(
      localId: serializer.fromJson<int>(json['localId']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      type: serializer.fromJson<String>(json['type']),
      path: serializer.fromJson<String?>(json['path']),
      url: serializer.fromJson<String?>(json['url']),
      fileName: serializer.fromJson<String>(json['fileName']),
      messageId: serializer.fromJson<int>(json['messageId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'remoteId': serializer.toJson<int?>(remoteId),
      'type': serializer.toJson<String>(type),
      'path': serializer.toJson<String?>(path),
      'url': serializer.toJson<String?>(url),
      'fileName': serializer.toJson<String>(fileName),
      'messageId': serializer.toJson<int>(messageId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalMultimedia copyWith(
          {int? localId,
          int? remoteId,
          String? type,
          String? path,
          String? url,
          String? fileName,
          int? messageId,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      LocalMultimedia(
        localId: localId ?? this.localId,
        remoteId: remoteId ?? this.remoteId,
        type: type ?? this.type,
        path: path ?? this.path,
        url: url ?? this.url,
        fileName: fileName ?? this.fileName,
        messageId: messageId ?? this.messageId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('LocalMultimedia(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('type: $type, ')
          ..write('path: $path, ')
          ..write('url: $url, ')
          ..write('fileName: $fileName, ')
          ..write('messageId: $messageId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(localId, remoteId, type, path, url, fileName,
      messageId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMultimedia &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.type == this.type &&
          other.path == this.path &&
          other.url == this.url &&
          other.fileName == this.fileName &&
          other.messageId == this.messageId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MultimediaCompanion extends UpdateCompanion<LocalMultimedia> {
  final Value<int> localId;
  final Value<int?> remoteId;
  final Value<String> type;
  final Value<String?> path;
  final Value<String?> url;
  final Value<String> fileName;
  final Value<int> messageId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MultimediaCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.type = const Value.absent(),
    this.path = const Value.absent(),
    this.url = const Value.absent(),
    this.fileName = const Value.absent(),
    this.messageId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MultimediaCompanion.insert({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String type,
    this.path = const Value.absent(),
    this.url = const Value.absent(),
    required String fileName,
    required int messageId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : type = Value(type),
        fileName = Value(fileName),
        messageId = Value(messageId);
  static Insertable<LocalMultimedia> custom({
    Expression<int>? localId,
    Expression<int?>? remoteId,
    Expression<String>? type,
    Expression<String?>? path,
    Expression<String?>? url,
    Expression<String>? fileName,
    Expression<int>? messageId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (type != null) 'type': type,
      if (path != null) 'path': path,
      if (url != null) 'url': url,
      if (fileName != null) 'file_name': fileName,
      if (messageId != null) 'message_id': messageId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MultimediaCompanion copyWith(
      {Value<int>? localId,
      Value<int?>? remoteId,
      Value<String>? type,
      Value<String?>? path,
      Value<String?>? url,
      Value<String>? fileName,
      Value<int>? messageId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MultimediaCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      type: type ?? this.type,
      path: path ?? this.path,
      url: url ?? this.url,
      fileName: fileName ?? this.fileName,
      messageId: messageId ?? this.messageId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int?>(remoteId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (path.present) {
      map['path'] = Variable<String?>(path.value);
    }
    if (url.present) {
      map['url'] = Variable<String?>(url.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<int>(messageId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MultimediaCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('type: $type, ')
          ..write('path: $path, ')
          ..write('url: $url, ')
          ..write('fileName: $fileName, ')
          ..write('messageId: $messageId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MultimediaTable extends Multimedia
    with TableInfo<$MultimediaTable, LocalMultimedia> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MultimediaTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _localIdMeta = const VerificationMeta('localId');
  @override
  late final GeneratedColumn<int?> localId = GeneratedColumn<int?>(
      'local_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _remoteIdMeta = const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<int?> remoteId = GeneratedColumn<int?>(
      'remote_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'UNIQUE');
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL CHECK(type IN (\'image\', \'file\', \'video\', \'audio\', \'archive\'))');
  final VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String?> path = GeneratedColumn<String?>(
      'path', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String?> url = GeneratedColumn<String?>(
      'url', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _fileNameMeta = const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String?> fileName = GeneratedColumn<String?>(
      'file_name', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _messageIdMeta = const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<int?> messageId = GeneratedColumn<int?>(
      'message_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES messages(local_id) ON DELETE CASCADE');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        localId,
        remoteId,
        type,
        path,
        url,
        fileName,
        messageId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'multimedia';
  @override
  String get actualTableName => 'multimedia';
  @override
  VerificationContext validateIntegrity(Insertable<LocalMultimedia> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LocalMultimedia map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LocalMultimedia.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MultimediaTable createAlias(String alias) {
    return $MultimediaTable(attachedDatabase, alias);
  }
}

abstract class _$ChatDatabase extends GeneratedDatabase {
  _$ChatDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $ConversationsTable conversations = $ConversationsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $MultimediaTable multimedia = $MultimediaTable(this);
  late final ConversationLocalSource conversationLocalSource =
      ConversationLocalSource(this as ChatDatabase);
  late final MessageLocalSource messageLocalSource =
      MessageLocalSource(this as ChatDatabase);
  late final MultimediaLocalSource multimediaLocalSource =
      MultimediaLocalSource(this as ChatDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [conversations, messages, multimedia];
}
