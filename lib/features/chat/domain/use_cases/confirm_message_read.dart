import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';

class ConfirmMessageReadUseCase {
  final MessageRepository repository;
  ConfirmMessageReadUseCase({
    required this.repository,
  });

  Future<void> call(LocalMessage message) async {
    return await repository.confirmMessageRead(message);
  }
}
