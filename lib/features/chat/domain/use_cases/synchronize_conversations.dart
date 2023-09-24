import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';

class SynchronizeConversations {
  final ConversationRepository repository;
  SynchronizeConversations({
    required this.repository,
  });

  Future<void> call() async {
    return await repository.synchronizeConversations();
  }
}
