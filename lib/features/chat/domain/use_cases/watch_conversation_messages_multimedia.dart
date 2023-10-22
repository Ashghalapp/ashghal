import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';

class WatchConversationMessagesMultimediaUseCase {
  final MessageRepository repository;
  WatchConversationMessagesMultimediaUseCase({
    required this.repository,
  });

  Stream<List<LocalMultimedia>> call(int conversationId) {
    return repository.watchConversationMessagesMultimedia(conversationId);
  }
}
