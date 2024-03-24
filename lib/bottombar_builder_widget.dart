import 'package:ashghal_app_frontend/bottombar_item_widget.dart';
import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottombarBuilderWidget extends StatelessWidget {
  final int currentIndex;
  final void Function(int index) onTap;
  const BottombarBuilderWidget({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    return SizedBox(
      height: 65,
      child: Material(
        // width: width * 0.2,
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        elevation: 4,
        child: Row(
          children: [
            BottombarItemWidget(
              icon: myIcons(svgAssetUrl: AppIcons.homeBorder),
              activeIcon: myIcons(
                svgAssetUrl: AppIcons.home,
                color: AppColors.appColorPrimary,
              ),
              onTap: () => onTap(0),
              isActive: currentIndex == 0,
            ),
            BottombarItemWidget(
              icon: myIcons(svgAssetUrl: AppIcons.searchBorder),
              activeIcon: myIcons(
                svgAssetUrl: AppIcons.search,
                color: AppColors.appColorPrimary,
              ),
              onTap: () => onTap(1),
              isActive: currentIndex == 1,
            ),
            BottombarItemWidget(
              icon: myIcons(svgAssetUrl: AppIcons.plusBorder),
              activeIcon: myIcons(
                svgAssetUrl: AppIcons.plus,
                color: AppColors.appColorPrimary,
              ),
              onTap: () => onTap(2),
              isActive: currentIndex == 2,
            ),
            BottombarItemWidget(
              icon: myIcons(svgAssetUrl: AppIcons.heartBorder),
              activeIcon: myIcons(
                svgAssetUrl: AppIcons.heart,
                color: AppColors.appColorPrimary,
              ),
              onTap: () => onTap(3),
              isActive: currentIndex == 3,
            ),
            BottombarItemWidget(
              icon: myIcons(svgAssetUrl: AppIcons.userBorder),
              activeIcon: myIcons(
                svgAssetUrl: AppIcons.user,
                color: AppColors.appColorPrimary,
              ),
              onTap: () => onTap(4),
              isActive: currentIndex == 4,
            ),
          ],
        ),
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
