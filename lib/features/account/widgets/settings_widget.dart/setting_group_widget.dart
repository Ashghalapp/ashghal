import 'package:ashghal_app_frontend/features/account/widgets/settings_widget.dart/setting_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingGroupWidget extends StatelessWidget {
  final String groupTitle;
  final List<SettingItemWidget>? items;
  final bool showEndDivider;
  const SettingGroupWidget({super.key, required this.groupTitle, this.items, this.showEndDivider = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(groupTitle.tr),
          if (items != null) ...items!,
          if (showEndDivider) const Divider(thickness: 4)
        ],
      ),
    );
  }
}
