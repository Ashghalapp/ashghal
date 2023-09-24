import 'package:ashghal_app_frontend/features/chat/domain/entities/conversation_last_message_and_count.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';

class WatchConversationsLastMessageAndCount {
  final ConversationRepository repository;
  WatchConversationsLastMessageAndCount({
    required this.repository,
  });

  Stream<List<ConversationlastMessageAndCount>> call() {
    return repository.watchConversationsLastMessageAndCount();
  }
}
