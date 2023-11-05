import 'package:ashghal_app_frontend/app_library/public_request/search_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';


/// the search will be on name, phone, email, job_name, job_desc, city, street, and address desc
class SearchForUsersUseCase {
  final UserRepository repository;

  SearchForUsersUseCase(this.repository);

  Future<Either<Failure, List<User>>> call(SearchRequest request) async {
    return await repository.searchForUsers(request);
  }
}