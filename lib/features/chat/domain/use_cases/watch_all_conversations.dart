import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';

class WatchAllConversations {
  final ConversationRepository repository;
  WatchAllConversations({
    required this.repository,
  });

  Stream<List<LocalConversation>> call() {
    return repository.watchAllConversations();
  }
}
