import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/config/app_images.dart';
import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/core/widget/app_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../config/app_constants.dart';
import '../getx/onboarding_controller.dart';

class OnBoardingScreen extends GetView<OnBoardingController> {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: controller.sliders.length,
        onPageChanged: controller.onPageChanged,
        controller: controller.pageController,
        itemBuilder: (context, index) {
          final slider = controller.sliders[index];
          return Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      fit: BoxFit.fill,
                      AppImages.onBoardingBackImage,
                      width: 300,
                      height: 400,
                      colorFilter: const ColorFilter.mode(
                        AppColors.appColorPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.mediaQuery.size.height * .03,
                ),
                Text(
                  slider.title,
                  style: Get.textTheme.titleLarge,
                ),
                Text(
                  slider.subtitle,
                  style: Get.textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        height: Get.mediaQuery.size.height * 0.2,
        decoration: BoxDecoration(color: Get.theme.scaffoldBackgroundColor),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < controller.sliders.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _getProperCircle(i),
                    )
                ],
              ),
              SizedBox(
                height: Get.mediaQuery.size.height * .03,
              ),
              Obx(() => AppGesterDedector(
                    onTap: () {
                      if (controller.currentIndex.value ==
                          controller.sliders.length - 1) {
                        // Navigate to the next screen when reaching the last slide
                        // and set the onboarding seen
                        Get.offNamed(AppRoutes.logIn);
                        SharedPref.setintroductionScreenSeen();
                      } else {
                        controller.pageController.animateToPage(
                          controller.onNext(),
                          duration: const Duration(
                            milliseconds: AppConstants.sliderAnimationTime,
                          ),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    text: controller.currentIndex.value ==
                            controller.sliders.length - 1
                        ? AppLocalization.done
                        : AppLocalization.next,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getProperCircle(int index) {
    return Obx(
      () => Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == controller.currentIndex.value
              ? AppColors.appColorPrimary
              : Get.theme.dividerColor,
        ),
      ),
    );
  }
}
