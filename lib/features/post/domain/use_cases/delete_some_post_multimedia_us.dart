import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';
import '../../../../core_api/success/success.dart';
import '../Requsets/delete_some_post_multimedia_request.dart';
import '../repositories/post_comment_repository.dart';

class DeleteSomeMultimediaUseCase {
  final PostCommentRepository repository;

  DeleteSomeMultimediaUseCase(this.repository);

  Future<Either<Failure, Success>> call(DeleteSomePostMultimediaRequest request) async {
    return await repository.deleteSomePostMultimedia(request);
  }
}
