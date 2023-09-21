import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
// ignore: must_be_immutable
class SocialIcons extends StatelessWidget {
  String icon;
  Function press;
   SocialIcons({
    Key? key,
    required this.icon,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:press(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(15),
        decoration:  const BoxDecoration(
          // border: Border.all(width: 1.5),
          shape: BoxShape.circle,
        ),
          child: SvgPicture.asset('assets/icons/$icon.svg',
                height: 20,
                width:20,
                // ignore: deprecated_member_use
                color:AppColors.darkColor,
          ),
        ),
    );
  }
}
