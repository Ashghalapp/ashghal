import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/upload_request.dart';
import 'package:dartz/dartz.dart';

class UploadMultimediaUseCase {
  final MessageRepository repository;
  UploadMultimediaUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call(UploadRequest request) async {
    return await repository.uploadMultimedia(request);
  }
}
