
import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';







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
      style:  TextStyle(
        // fontFamily: 'Cairo',
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: AppColors.bodyDark1,
      ),
    );
  }
}
