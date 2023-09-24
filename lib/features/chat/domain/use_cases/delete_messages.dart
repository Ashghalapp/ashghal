import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_messages_request.dart';
import 'package:dartz/dartz.dart';

class DeleteMessagesUseCase {
  final MessageRepository repository;
  DeleteMessagesUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call(DeleteMessagesRequest request) async {
    return await repository.deleteMessages(request);
  }
}
