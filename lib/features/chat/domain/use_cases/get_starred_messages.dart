import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:dartz/dartz.dart';

class GetStarredMessagesUseCase {
  final MessageRepository repository;
  GetStarredMessagesUseCase({
    required this.repository,
  });

  Future<Either<Failure, List<MessageAndMultimediaModel>>> call() async {
    return await repository.getStarredMessages();
  }
}
