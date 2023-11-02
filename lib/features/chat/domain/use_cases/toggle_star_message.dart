import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:dartz/dartz.dart';

class ToggleStarMessageUseCase {
  final MessageRepository repository;
  ToggleStarMessageUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call(
      int messageLocalId, bool starMessage, int conversationLocalId) async {
    return await repository.toggleStarMessage(
      messageLocalId,
      starMessage,
      conversationLocalId,
    );
  }
}
