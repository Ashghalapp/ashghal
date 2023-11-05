import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HighlightableTextWidget extends StatelessWidget {
  final String text;
  final String searchText;
  final Color highlightColor;
  final double fontSize;
  // final Color? textColor;

  const HighlightableTextWidget({
    super.key,
    required this.text,
    required this.searchText,
    this.fontSize = 16,
    this.highlightColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final pattern = RegExp(searchText, caseSensitive: false);
    final textParts = text.split(pattern);
    AppPrint.printInfo('$textParts');
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          color: Get.isPlatformDarkMode ? null : Colors.black87,
        ),
        children: <TextSpan>[
          for (var i = 0; i < textParts.length - 1; i++)
            TextSpan(
              text: textParts[i],
              //  style: TextStyle(color: Colors.black)
            ),
          TextSpan(
            text: searchText,
            style:
                TextStyle(color: highlightColor, fontWeight: FontWeight.bold),
          ),
          if (textParts.last.isNotEmpty)
            TextSpan(
              text: textParts.last,
              // style: TextStyle(color: Colors.black)
            ),
        ],
      ),
    );
  }
}
