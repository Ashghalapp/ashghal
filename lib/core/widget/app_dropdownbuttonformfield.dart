import 'package:ashghal_app_frontend/core/util/validinput.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDropDownButton extends StatelessWidget {
  /// the item in items list must contain a map containing two fields: id and name
  final List<Map<String, Object>> items;
  // final TextEditingController controller;
  final void Function(Object? selectedValue) onChange;
  final int? initialValue;
  final String? hintText;
  final String? labelText;
    final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppDropDownButton({
    super.key,
    required this.items,
    this.initialValue,
    required this.onChange,
    this.hintText,
    this.labelText,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: DropdownButtonFormField(
        borderRadius: const BorderRadius.all(Radius.zero),
        style: Get.textTheme.bodyMedium?.copyWith(color: Get.theme.primaryColor),
        // style: Get.theme.dropdownMenuTheme.textStyle?.copyWith(
        //   fontSize: Get.textTheme.bodyMedium?.fontSize,
        //   fontWeight: FontWeight.normal
        // ),
        isDense: true,
        isExpanded: true,
        hint: hintText != null
            ? Text(hintText!.tr, style: Get.textTheme.labelSmall)
            : null,
        value: initialValue,
        items: [
          ...items.map((e) {
            return DropdownMenuItem(
              value: e['id'],
              child: Text("${e['name']}"),
            );
          }).toList()
        ],

        
    
        decoration: InputDecoration(
          labelText: labelText?.tr,
          labelStyle: Get.textTheme.labelSmall,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
          // Set the border to none to remove the side border
          border: InputBorder.none,
        ),
        validator: (value) =>
            validInput(value?.toString() ?? "", null, null, 'selectedCategory'),
        onChanged: (value) {
          print("<<<<<<<<<<<<<$value>>>>>>>>>>>>>");
          onChange(value);
        },
      ),
    );
  }
}
