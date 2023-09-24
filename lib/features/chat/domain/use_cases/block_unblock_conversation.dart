import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/block_unblock_conversation_request.dart';
import 'package:dartz/dartz.dart';

class BlockUnblockConversationUseCase {
  final ConversationRepository repository;
  BlockUnblockConversationUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call(
      BlockUnblockConversationRequest request) async {
    return await repository.blockUnblockConversation(request);
  }
}
