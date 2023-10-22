import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? data;
  final void Function()? onTap;
  const SettingItemWidget({
    super.key,
    required this.icon,
    required this.label,
    this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Get.theme.iconTheme.color),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            maxLines: 1,
            style: Get.textTheme.bodyMedium,
          ),
          const SizedBox(width: 20),
          if (data != null)
            Flexible(
              child: Text(
                data!,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontSize: (Get.textTheme.bodyMedium?.fontSize ?? 14) - 2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
