import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';

class WatchConversationMessagesMultimediaUseCase {
  final MessageRepository repository;
  WatchConversationMessagesMultimediaUseCase({
    required this.repository,
  });

  Stream<List<MessageAndMultimediaModel>> call(int conversationId) {
    return repository.watchConversationMessagesMultimedia(conversationId);
  }
}
