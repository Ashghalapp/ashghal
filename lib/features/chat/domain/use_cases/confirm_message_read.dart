import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/receive_read_confirmation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/receive_read_confirmation_request.dart';
import 'package:dartz/dartz.dart';

class ConfirmMessageReadUseCase {
  final MessageRepository repository;
  ConfirmMessageReadUseCase({
    required this.repository,
  });

  Future<void> call(LocalMessage message) async {
    return await repository.confirmMessageRead(message);
  }
}
