import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/setting_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingGroupWidget extends StatelessWidget {
  final String groupTitle;
  final List<SettingItemWidget>? items;
  final bool showEndDivider;
  const SettingGroupWidget({
    super.key,
    required this.groupTitle,
    this.items,
    this.showEndDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) => SizedBox(width: 20, child: child),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              // height: 30,
              // alignment: AlignmentDirectional.centerStart,
              child: Text(groupTitle.tr),
            ),
            if (items != null) ...items!,
            if (showEndDivider)
              Divider(thickness: 4, color: Get.theme.dividerColor)
          ],
        ),
      ),
    );
  }
}
