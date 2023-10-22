import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/start_conversation_request.dart';
import 'package:dartz/dartz.dart';

class StartConversationWithUseCase {
  final ConversationRepository repository;
  StartConversationWithUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call(StartConversationRequest request) async {
    return await repository.startConversationWith(request);
  }
}
