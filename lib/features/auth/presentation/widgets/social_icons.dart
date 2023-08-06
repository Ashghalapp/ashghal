import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/config/app_colors.dart';

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
      onTap:press(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(15),
        decoration:  BoxDecoration(
          border: Border.all(width: 1.5),
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
