// ignore: unused_import
import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SocialIcons extends StatelessWidget {
  final String icon;
  final Function press;
  const SocialIcons({
    Key? key,
    required this.icon,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1, // Adjust the width as needed
          ),
        ),
        child: SvgPicture.asset(
          'assets/icons/$icon.svg',
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
