import 'package:ashghal_app_frontend/features/chat/domain/entities/participant.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/received_read_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/remote_message.dart';
import 'package:equatable/equatable.dart';

class RemoteConversation extends Equatable {
  final int id;
  final int createdBy;
  final String? name;
  final bool isGroup;
  final String? iconUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Participant> participants;
  final List<RemoteMessage> newMessages;
  final List<ReceivedReadMessage> receivedMessages;
  final List<ReceivedReadMessage> readMessages;

  RemoteConversation({
    required this.id,
    required this.createdBy,
    this.name,
    this.isGroup = false,
    this.iconUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.participants,
    required this.newMessages,
    required this.receivedMessages,
    required this.readMessages,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [
        id,
      ];
}
