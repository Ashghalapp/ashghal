import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_multimedia_model.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/remote_message.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:moor_flutter/moor_flutter.dart';

class RemoteMessageModel extends RemoteMessage {
  const RemoteMessageModel({
    required super.id,
    super.body,
    required super.senderId,
    required super.conversationId,
    super.replyTo,
    super.multimedia,
    required super.sentAt,
    super.receivedAt,
    super.readAt,
    required super.updatedAt,
  });

  factory RemoteMessageModel.fromJson2(Map<String, dynamic> json) {
    return RemoteMessageModel.fromJson(json['message']);
  }
  factory RemoteMessageModel.fromJson(Map<String, dynamic> json) {
    return RemoteMessageModel(
      id: json['id'],
      body: json['body'],
      senderId: json['sender_id'],
      conversationId: json['conversation_id'],
      replyTo: json['reply_to'],
      multimedia: json['multimedia'] == null
          ? null
          : RemoteMultimediaModel.fromJson(json['multimedia']),
      sentAt: DateTime.parse(json['sent_at']),
      receivedAt: json['received_at'] != null
          ? DateTime.parse(json['received_at'])
          : null,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      updatedAt: DateTime.parse((json['updated_at'])),
    );
  }

  // factory RemoteMessage.fromRemoteJson(Map<String, dynamic> json) {
  //   return RemoteMessage(
  //     id: json['id'],
  //     body: json['body'],
  //     senderId: json['sender_id'],
  //     conversationId: json['conversation_id'],
  //     multimedia: Multimedia.fromJsonList(json['multimedia']),
  //     sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at']) : null,
  //     receivedAt: json['received_at'] != null
  //         ? DateTime.parse(json['received_at'])
  //         : null,
  //     readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
  //     updatedAt:
  //         json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
  //   );
  // }

  static List<RemoteMessageModel> fromJsonList(
      List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => RemoteMessageModel.fromJson(json)).toList();
  }

  // static List<RemoteMessage> fromRemoteJsonList(List<dynamic> jsonList) {
  //   return jsonList.map((json) => RemoteMessage.fromRemoteJson(json)).toList();
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'body': body,
  //     'sender_id': senderId,
  //     'conversation_id': conversationId,
  //     'multimedia': multimedia.map((item) => (item as RemoteMultimediaModel).toJson()).toList(),
  //     'sent_at': sentAt?.toIso8601String(),
  //     'received_at': receivedAt?.toIso8601String(),
  //     'read_at': readAt?.toIso8601String(),
  //   };
  // }

  MessagesCompanion toLocalMessageOnReceived(int conversatioLocalId) {
    return MessagesCompanion(
      remoteId: Value(id),
      body: Value(body),
      senderId: Value(senderId),
      conversationId: Value(conversatioLocalId),
      replyTo: Value(replyTo),
      sentAt: Value(sentAt),
      recievedAt: Value(DateTime.now()),
      receivedLocally: const Value(true),
      // readAt: Value.ofNullable(readAt),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
  }

  MessagesCompanion toLocalMessageOnSend() {
    return MessagesCompanion(
      // localId: Value(localId),
      remoteId: Value(id),
      replyTo: Value(replyTo),
      // body: Value.ofNullable(body),
      // senderId: Value(senderId),
      // conversationId: Value(conversationLocalId),
      sentAt: Value(sentAt),
      // recievedAt: Value(DateTime.now()),
      // receivedLocally: const Value(true),
      // readAt: Value.ofNullable(readAt),
      // createdAt: Value(DateTime.now()),
      updatedAt: Value(updatedAt),
    );
  }

  @override
  String toString() {
    return 'RemoteMessage(id: $id, body: $body, senderId: $senderId, conversationId: $conversationId, multimedia: $multimedia, sentAt: $sentAt, receivedAt: $receivedAt, readAt: $readAt)';
  }

  RemoteMessageModel copyWith({
    int? id,
    String? body,
    int? senderId,
    int? conversationId,
    int? replyTo,
    RemoteMultimediaModel? multimedia,
    DateTime? sentAt,
    DateTime? receivedAt,
    DateTime? readAt,
    DateTime? updatedAt,
  }) {
    return RemoteMessageModel(
      id: id ?? this.id,
      body: body ?? this.body,
      senderId: senderId ?? this.senderId,
      conversationId: conversationId ?? this.conversationId,
      replyTo: replyTo ?? this.replyTo,
      multimedia: multimedia ?? this.multimedia,
      sentAt: sentAt ?? this.sentAt,
      receivedAt: receivedAt ?? this.receivedAt,
      readAt: readAt ?? this.readAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
