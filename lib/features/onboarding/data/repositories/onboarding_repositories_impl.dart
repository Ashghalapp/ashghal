import 'package:ashghal_app_frontend/config/app_images.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';
import '../../domain/entities/onboarding.dart';
import '../../domain/repositories/onboarding_repositories.dart';
import '../../domain/requests/onboarding_request.dart';
import '../models/onboarding_model.dart';

class OnBoardingRepositoryImpl extends OnBoardingRepository {
  //TODO Replace this with our datasources
  static final List<Map<String, dynamic>> onBoardingDataJson = [
    {
      'title': AppLocalization.onboadingTitle1,
      'subtitle':  AppLocalization.onboadingSubTitle1,
      'imagePath': AppImages.onBoardingImageOne,
    },
    {
      'title': AppLocalization.onboadingTitle2,
      'subtitle':  AppLocalization.onboadingSubTitle2,
      'imagePath': AppImages.onBoardingImageTwo,
    },
    {
      'title': AppLocalization.onboadingTitle3,
      'subtitle':  AppLocalization.onboadingSubTitle3,
      'imagePath': AppImages.onBoardingImageThree,
    },
  ];

  @override
  Future<Either<Failure, List<OnBoarding>>> getOnBoardingData() async {
    try {
      final List<OnBoarding> onBoardingItems = onBoardingDataJson
          .map((json) => OnBoardingModel.fromJson(json))
          .toList();

      return Right(onBoardingItems);
    } catch (e) {
      print(">>>>>>>>>>Exception in repository: $e");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }
}

