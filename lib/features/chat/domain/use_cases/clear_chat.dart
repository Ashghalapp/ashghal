import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/clear_chat_request.dart';
import 'package:dartz/dartz.dart';

class ClearChatUseCase {
  final MessageRepository repository;
  ClearChatUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call(ClearChatRequest request) async {
    return await repository.clearChat(request);
  }
}
