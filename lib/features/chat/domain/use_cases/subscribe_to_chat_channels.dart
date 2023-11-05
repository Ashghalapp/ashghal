import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';

class SubscribeToChatChannelsUseCase {
  final ConversationRepository repository;
  SubscribeToChatChannelsUseCase({
    required this.repository,
  });

  Future<void> call(
      void Function(TypingEventType eventType, int userId)
          onTypingEvent) async {
    return await repository.subscribeToChatChannels(onTypingEvent);
  }
}
