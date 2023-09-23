import 'package:flutter/material.dart';

import '../../../../config/app_images.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logo,
      fit: BoxFit.contain,
      width: 120,
      height: 120,
    );
  }
}