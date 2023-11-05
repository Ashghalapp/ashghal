import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:equatable/equatable.dart';

class ConversationAndMessageModel extends Equatable {
  final MessageAndMultimediaModel message;
  final LocalConversation conversation;

  const ConversationAndMessageModel({
    required this.message,
    required this.conversation,
  });

  @override
  List<Object?> get props => [conversation, message];
}
