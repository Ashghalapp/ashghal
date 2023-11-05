import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/onboarding_model.dart';

class OnBoardingController extends GetxController {
  //   final RxList<OnBoarding> sliders = RxList<OnBoarding>(); //remote source
  final List<OnBoardingModel> sliders = [
    OnBoardingModel(
      title: 'Onboarding Title 1',
      subtitle: 'Onboarding Subtitle 1',
      imagePath: 'assets/onboarding/onboarding_Image_1.svg',
    ),
    OnBoardingModel(
      title: 'Onboarding Title 2',
      subtitle: 'Onboarding Subtitle 2',
      imagePath: 'assets/onboarding/onboarding_Image_1.svg',
    ),
    OnBoardingModel(
      title: 'Onboarding Title 3',
      subtitle: 'Onboarding Subtitle 3',
      imagePath: 'assets/onboarding/onboarding_Image_1.svg',
    ),
  ];

  final RxInt currentIndex = 0.obs;
  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      currentIndex.value = pageController.page?.round() ?? 0;
    });
    // _loadSliderData();
  }

  //TODO Uncomment This To Get The Data From Remote source
// void _loadSliderData() async {
//      GetOnBoardingDataUseCase getOnBoardingDataUseCase=di.getIt();
//     final either = await getOnBoardingDataUseCase.execute();

//     either.fold(
//       (failure) {

//         print('Failed to load slider data: ${failure.message}');
//       },
//       (data) {
//         print('onboarding loading..$sliders');
//         sliders.assignAll(data);
//            print('onboarding loading..$sliders');
//       },
//     );
//   }

  int onNext() {
    currentIndex.value = (currentIndex.value + 1) % sliders.length;
    return currentIndex.value;
  }

  int onPrevious() {
    currentIndex.value = (currentIndex.value - 1) % sliders.length;
    return currentIndex.value;
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
