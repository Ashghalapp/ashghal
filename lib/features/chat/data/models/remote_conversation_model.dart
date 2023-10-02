import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/participant_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/participant.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/received_read_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/remote_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/remote_message.dart';
import 'package:moor_flutter/moor_flutter.dart';

class RemoteConversationModel extends RemoteConversation {
  // int id;
  // int userId;
  // DateTime createdAt;
  // DateTime updatedAt;
  // List<RemoteMessage> newMessages;
  // List<ReceivedReadMessage> receivedMessages;
  // List<ReceivedReadMessage> readMessages;

  Participant get secondUser => participants[0];

  RemoteConversationModel({
    required super.id,
    required super.createdBy,
    super.name,
    super.isGroup = false,
    super.iconUrl,
    super.createdAt,
    super.updatedAt,
    required super.participants,
    required super.newMessages,
    required super.receivedMessages,
    required super.readMessages,
  });

  factory RemoteConversationModel.fromJson(Map<String, dynamic> json) {
    return RemoteConversationModel(
      id: json['id'] as int,
      createdBy: json['created_by'] as int,
      name: json['name'] as String?,
      isGroup: json['is_group'] as bool? ?? false,
      // ignore: prefer_null_aware_operators
      iconUrl:
          json['icon_url'] == null ? null : AppUtil.editUrl(json['icon_url']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      participants: ParticipantModel.fromJsonList(
          (json['participants'] as List).cast<Map<String, dynamic>>()),

      // userId: json['user_id'],
      // userName: json['user_name'],
      // userEmail: json['user_email'],
      // userPhone: json['user_phone'],
      // userImageUrl: json['user_image_url'] == null
      //     ? null
      //     : json['user_image_url']
      //         .toString()
      //         .replaceAll(RegExp('localhost'), "10.0.2.2:8000"),
      // // isUserProvider: json['is_user_provider'],
      // createdAt: DateTime.parse(json['created_at']),
      // becuase json['new_messages'] is a List<dynamic> you will got an error if you pass it directly
      // so you have to cast it to List<Map<String,dynamic>> using the cast function
      newMessages: (json['new_messages'] as List).isEmpty
          ? []
          : RemoteMessageModel.fromJsonList(
              (json['new_messages'] as List).cast<Map<String, dynamic>>(),
            ),

      receivedMessages: (json['received_messages'] as List).isEmpty
          ? []
          : ReceivedReadMessageModel.fromJsonList(
              (json['received_messages'] as List).cast<Map<String, dynamic>>(),
            ),
      readMessages: (json['read_messages'] as List).isEmpty
          ? []
          : ReceivedReadMessageModel.fromJsonList(
              (json['read_messages'] as List).cast<Map<String, dynamic>>(),
            ),
    );
  }

  static List<RemoteConversationModel> fromJsonList(
      List<Map<String, dynamic>> jsonList) {
    return jsonList
        .map<RemoteConversationModel>(
            (json) => RemoteConversationModel.fromJson(json))
        .toList();
  }

  ConversationsCompanion toLocalConversation() {
    return ConversationsCompanion(
      remoteId: Value(id),
      // isBlocked: Value(secondUse),
      userId: Value(secondUser.id),
      userName: Value(secondUser.name),
      userEmail: Value(secondUser.email),
      userPhone: Value(secondUser.phone),
      userImageUrl: Value(secondUser.imageUrl),
      // createdAt: Value(createdAt),
      // updatedAt: Value(DateTime.now()),
    );
  }

  ConversationsCompanion toLocalConversationWithId(int localId) {
    return ConversationsCompanion(
      localId: Value(localId),
      remoteId: Value(id),
      userId: Value(secondUser.id),
      userName: Value(secondUser.name),
      userEmail: Value(secondUser.email),
      userPhone: Value(secondUser.phone),
      userImageUrl: Value(secondUser.imageUrl),
      createdAt: Value(createdAt),
      updatedAt: Value(DateTime.now()),
    );
  }
  // Map<String, dynamic> toJson() {
  //   return {
  //     "id": id,
  //     "user_id": userId,
  //     "created_at": createdAt.toIso8601String(),
  //     'newMessages': newMessages.map((message) => message.toJson()).toList(),
  //     'receivedMessages': receivedMessages,
  //     'readMessages': readMessages,
  //   };
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'createdBy': createdBy,
  //     'name': name,
  //     'isGroup': isGroup,
  //     'iconUrl': iconUrl,
  //     'createdAt': createdAt.toIso8601String(),
  //     'updatedAt': updatedAt.toIso8601String(),
  //     'participants':
  //         participants.map((e) => (e as ParticipantModel).toJson()).toList(),
  //     'newMessages':
  //         newMessages.map((e) => (e as ParticipantModel).toJson()).toList(),
  //     'receivedMessages': receivedMessages
  //         .map((e) => (e as ParticipantModel).toJson())
  //         .toList(),
  //     'readMessages':
  //         readMessages.map((e) => (e as ParticipantModel).toJson()).toList(),
  //   };
  // }

  @override
  String toString() {
    return 'RemoteConversationModel(id: $id, createdBy: $createdBy, name: $name, isGroup: $isGroup, iconUrl: $iconUrl, createdAt: $createdAt, updatedAt: $updatedAt, participants: $participants, newMessages: $newMessages, receivedMessages: $receivedMessages, readMessages: $readMessages)';
  }

  RemoteConversationModel copyWith({
    int? id,
    int? createdBy,
    String? name,
    bool? isGroup,
    String? iconUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Participant>? participants,
    List<RemoteMessage>? newMessages,
    List<ReceivedReadMessage>? receivedMessages,
    List<ReceivedReadMessage>? readMessages,
  }) {
    return RemoteConversationModel(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      name: name ?? this.name,
      isGroup: isGroup ?? this.isGroup,
      iconUrl: iconUrl ?? this.iconUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      participants: participants ?? this.participants,
      newMessages: newMessages ?? this.newMessages,
      receivedMessages: receivedMessages ?? this.receivedMessages,
      readMessages: readMessages ?? this.readMessages,
    );
  }
}
