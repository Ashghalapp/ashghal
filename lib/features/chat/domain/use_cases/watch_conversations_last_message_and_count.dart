import 'package:ashghal_app_frontend/features/chat/domain/entities/conversation_last_message_and_count.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';

class WatchConversationsLastMessageAndCountUseCase {
  final ConversationRepository repository;
  WatchConversationsLastMessageAndCountUseCase({
    required this.repository,
  });

  Stream<List<ConversationlastMessageAndCount>> call() async* {
    yield* repository.watchConversationsLastMessageAndCount();
  }
}
