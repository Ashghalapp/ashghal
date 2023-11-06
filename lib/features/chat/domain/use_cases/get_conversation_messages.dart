import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:dartz/dartz.dart';

class GetConversationMessagesUsecase {
  final MessageRepository repository;
  GetConversationMessagesUsecase({
    required this.repository,
  });

  Future<Either<Failure, List<LocalMessage>>> call(int conversationId) async {
    return await repository.getCoversationMessages(conversationId);
  }
}
