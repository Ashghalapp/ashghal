import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/start_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:dartz/dartz.dart';

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
