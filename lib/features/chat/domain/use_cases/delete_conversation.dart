import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_conversation_request.dart';
import 'package:dartz/dartz.dart';

class DeleteConversationUseCase {
  final ConversationRepository repository;
  DeleteConversationUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call(List<int> conversationsLocalIds) async {
    return await repository.deleteConversations(conversationsLocalIds);
  }
}
