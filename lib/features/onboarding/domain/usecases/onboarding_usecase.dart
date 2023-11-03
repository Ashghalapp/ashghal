import 'package:ashghal_app_frontend/core_api/errors/failures.dart';

import 'package:ashghal_app_frontend/features/onboarding/domain/entities/onboarding.dart';

import 'package:dartz/dartz.dart';


import '../repositories/onboarding_repositories.dart';
import '../requests/onboarding_request.dart';


class GetOnBoardingDataUseCase {
  final OnBoardingRepository repository;

  GetOnBoardingDataUseCase(this.repository);

  // Future<Either<Failure, List<OnBoarding>>> execute(OnBoardingRequest request) {
  //   return repository.getOnBoardingData(request);
  // }
  Future<Either<Failure, List<OnBoarding>>> execute() {
    return repository.getOnBoardingData();
  }
}