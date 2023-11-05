
// import 'package:ashghal_app_frontend/features/onboarding/domain/requests/onboarding_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';


import '../entities/onboarding.dart';


abstract class OnBoardingRepository{

  // Future<Either<Failure, List<OnBoarding>>> getOnBoardingData(OnBoardingRequest request);
  Future<Either<Failure, List<OnBoarding>>> getOnBoardingData();

}