import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupMenuButtonWidget extends StatelessWidget {
  final Function(String value) onSelected;
  final List<String> items;
  // final List<void Function()?>? onValuesTapList;

  const PopupMenuButtonWidget({super.key, required this.onSelected, required this.items});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.iconColor),
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      onSelected: onSelected,
      itemBuilder: (_) {
        return [
          for(int i=0; i<items.length; i++)
          PopupMenuItem(
            value: items[i],
            // onTap: () {
            //   onValuesTapList![i]!();
            // },
            child: Text(items[i].tr),
          ),
          // const PopupMenuItem(
          //   value: PostPopupMenuItemsValues.save,
          //   child: Text("Save"),
          // ),
          // const PopupMenuItem(
          //   value: PostPopupMenuItemsValues.report,
          //   child: Text("Report"),
          // ),
          // const PopupMenuItem(
          //   value: PostPopupMenuItemsValues.copy,
          //   child: Text("Copy"),
          // ),
        ];
      },
    );
  }
}
