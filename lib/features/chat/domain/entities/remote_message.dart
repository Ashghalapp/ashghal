import 'package:ashghal_app_frontend/features/chat/domain/entities/remote_multimedia.dart';
import 'package:equatable/equatable.dart';

class RemoteMessage extends Equatable {
  final int id;
  final String? body;
  final int senderId;
  final int conversationId;
  final RemoteMultimedia? multimedia;
  final DateTime sentAt;
  final DateTime? receivedAt;
  final DateTime? readAt;
  final DateTime updatedAt;

  const RemoteMessage({
    required this.id,
    this.body,
    required this.senderId,
    required this.conversationId,
    this.multimedia,
    required this.sentAt,
    this.receivedAt,
    this.readAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        body,
        senderId,
        conversationId,
        multimedia,
        sentAt,
        receivedAt,
        readAt,
        updatedAt
      ];
}
