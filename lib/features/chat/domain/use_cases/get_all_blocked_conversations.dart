import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_with_count_and_last_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllBlockedConversationsCountUseCase {
  final ConversationRepository repository;
  GetAllBlockedConversationsCountUseCase({
    required this.repository,
  });

  Future<Either<Failure, List<LocalConversation>>> call() async {
    return await repository.getAllBlockedConversations();
  }
}
