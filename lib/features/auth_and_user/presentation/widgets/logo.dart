import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_images.dart';

// class LogoWidget extends StatelessWidget {
//   const LogoWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Image.asset(
//       AppImages.logo,
//       fit: BoxFit.contain,
//       width: 120,
//       height: 120,
//     );
//   }
// }

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      colorFilter: const ColorFilter.mode(AppColors.appColorPrimary, BlendMode.srcIn),
      AppImages.logo,
      fit: BoxFit.contain,
      width: Get.mediaQuery.size.width * 0.15,
      height: Get.mediaQuery.size.height * 0.15,
    );
  }
}