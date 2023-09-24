import '../repositories/message_repository.dart';

class ConversationMessagesReadUseCase {
  final MessageRepository repository;
  ConversationMessagesReadUseCase({
    required this.repository,
  });

  Future<void> call(int conversatioId) async {
    return await repository.conversationMessagesRead(conversatioId);
  }
}
