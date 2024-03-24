import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottombarItemWidget extends StatelessWidget {
  final Widget icon;
  final Widget activeIcon;
  final void Function() onTap;
  final bool isActive;
  const BottombarItemWidget({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    return SizedBox(
      width: width * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onTap,
            icon: isActive ? activeIcon : icon,
          ),

          AnimatedContainer(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.fastLinearToSlowEaseIn,
            // alignment: AlignmentDirectional.bottomCenter,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: isActive ? 7 : 0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              color: Theme.of(context).primaryColor,
            ),
          ),
          // if (!isActive)
          //   AnimatedContainer(
          //     duration: Duration(milliseconds: 1500),
          //     curve: Curves.fastLinearToSlowEaseIn,
          //     child: IconButton(onPressed: onTap, icon: icon),
          //   ),
          // if (isActive) ...[
          //   AnimatedContainer(
          //     duration: Duration(milliseconds: 1500),
          //     curve: Curves.fastLinearToSlowEaseIn,
          //     child: IconButton(onPressed: onTap, icon: activeIcon),
          //   ),
          //   AnimatedContainer(
          //     duration: Duration(milliseconds: 1500),
          //     curve: Curves.fastLinearToSlowEaseIn,
          //     // alignment: AlignmentDirectional.bottomCenter,
          //     margin: const EdgeInsets.symmetric(horizontal: 15),
          //     height: 7,
          //     decoration: BoxDecoration(
          //       borderRadius: const BorderRadius.only(
          //         topRight: Radius.circular(30),
          //         topLeft: Radius.circular(30),
          //       ),
          //       color: Theme.of(context).primaryColor,
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }
}

Widget myIcons(
    {String? svgAssetUrl, double? width, double? height, Color? color}) {
  return SvgPicture.asset(
    svgAssetUrl!,
    // AppIcons.email,
    width: width ?? 30,
    height: height ?? 30,

    colorFilter:
        ColorFilter.mode(color ?? AppColors.iconColor, BlendMode.srcIn),
  );
}
