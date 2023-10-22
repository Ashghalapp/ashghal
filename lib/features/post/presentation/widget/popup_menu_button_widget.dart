import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupMenuButtonWidget extends StatelessWidget {
  final Function(String value) onSelected;
  final List<String> values;

  const PopupMenuButtonWidget({super.key, required this.onSelected, required this.values});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      onSelected: onSelected,
      itemBuilder: (BuildContext ctx) {
        return [
          for(var value in values)
          PopupMenuItem(
            value: value,
            child: Text(value.tr),
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
