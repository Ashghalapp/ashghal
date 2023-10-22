import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';

class MatchedConversationsAndMessage {
  final LocalConversation conversation;
  final LocalMessage message;

  MatchedConversationsAndMessage({
    required this.conversation,
    required this.message,
  });
}
