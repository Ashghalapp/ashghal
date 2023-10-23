import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:dartz/dartz.dart';

class ToggleFavoriteConversationUseCase {
  final ConversationRepository repository;
  ToggleFavoriteConversationUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call(
      int conversationLocalId, bool addToFavorite) async {
    return await repository.toggleFavoriteConversation(
        conversationLocalId, addToFavorite);
  }
}
