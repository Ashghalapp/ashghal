import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/matched_conversation_and_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:dartz/dartz.dart';

class SearchInConversationsUseCase {
  final ConversationRepository repository;
  SearchInConversationsUseCase({
    required this.repository,
  });

  Future<Either<Failure, List<LocalMessage>>> call(String searchText) async {
    return await repository.searchInConversations(searchText);
  }
}
