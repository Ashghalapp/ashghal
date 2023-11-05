import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function(String value)? onTextChanged;

  const SearchTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      onChanged: onTextChanged,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Get.isDarkMode ? Colors.white70 : Colors.black87,
          ), // Change the border color when focused
        ),

        hintText: "${AppLocalization.search.tr}...",
        hintStyle: TextStyle(color: Colors.grey.shade600),
        // prefixIcon: Icon(
        //   Icons.search,
        //   color: Colors.grey.shade600,
        //   size: 20,
        // ),
        // filled: true,
        // fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.all(8),
        // suffixIcon: IconButton(
        //   icon: const Icon(Icons.check),
        //   color: Colors.black,
        //   onPressed: onSearchPressed,
        // ),
        enabledBorder: UnderlineInputBorder(
          // borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Get.isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(20),
        //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
        // ),
      ),
    );
  }
}
