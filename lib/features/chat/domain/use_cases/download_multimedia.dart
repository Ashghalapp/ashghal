import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/download_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';
import 'package:dartz/dartz.dart';

class DownloadMultimediaUseCase {
  final MessageRepository repository;
  DownloadMultimediaUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call(DownloadRequest request) async {
    return await repository.downloadMultimedia(request);
  }
}
