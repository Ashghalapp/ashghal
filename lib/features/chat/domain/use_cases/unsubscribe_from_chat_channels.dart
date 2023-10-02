import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';

class UnsubscribeFromRemoteChannelsUseCase {
  final ConversationRepository repository;
  UnsubscribeFromRemoteChannelsUseCase({
    required this.repository,
  });

  Future<void> call() {
    return repository.unsubscribeFromChatChannels();
  }
}
