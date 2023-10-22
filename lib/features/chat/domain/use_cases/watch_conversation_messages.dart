import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';

class WatchConversationMessages {
  final MessageRepository repository;
  WatchConversationMessages({
    required this.repository,
  });

  Stream<List<LocalMessage>> call(int conversationId) {
    return repository.watchConversationMessages(conversationId);
  }
}
