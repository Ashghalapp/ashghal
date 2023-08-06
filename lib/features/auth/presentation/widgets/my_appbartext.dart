import 'package:ashghal/core/constant/app_colors.dart';
import 'package:flutter/material.dart';







class MyAppBarText extends StatelessWidget {
  const MyAppBarText({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        // fontFamily: 'Cairo',
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: AppColors.gray,
      ),
    );
  }
}
