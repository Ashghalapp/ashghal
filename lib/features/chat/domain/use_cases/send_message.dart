import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';
import 'package:dartz/dartz.dart';

class SendMessageUseCase {
  final MessageRepository repository;
  SendMessageUseCase({
    required this.repository,
  });

  Future<Either<Failure, LocalMessage>> call(
      SendMessageRequest sendMessageRequest) async {
    return await repository.sendMessage(sendMessageRequest);
  }
}
