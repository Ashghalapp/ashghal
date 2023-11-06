import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:dartz/dartz.dart';

class ToggleArchiveConversationUseCase {
  final ConversationRepository repository;
  ToggleArchiveConversationUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call(
      int conversationLocalId, bool addToArchive) async {
    return await repository.toggleArchiveConversation(
        conversationLocalId, addToArchive);
  }
}
