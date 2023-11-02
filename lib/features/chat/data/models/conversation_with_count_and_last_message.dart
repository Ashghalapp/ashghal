import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';

class ConversationWithCountAndLastMessage {
  LocalConversation conversation;
  int newMessagesCount;
  LocalMessage? lastMessage;

  ConversationWithCountAndLastMessage({
    required this.conversation,
    this.newMessagesCount = 0,
    this.lastMessage,
  });

  ConversationWithCountAndLastMessage copyWith({
    LocalConversation? conversation,
    int? newMessagesCount,
    LocalMessage? lastMessage,
  }) {
    return ConversationWithCountAndLastMessage(
      conversation: conversation ?? this.conversation,
      newMessagesCount: newMessagesCount ?? this.newMessagesCount,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}
