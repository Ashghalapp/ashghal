import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    Key? key,
    this.isFilled = true,
    required this.onPress,
    required this.text,
  }) : super(key: key);

  final bool isFilled;
  final VoidCallback onPress;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Get.theme.primaryColor),
      ),
      elevation: isFilled ? 2 : 0,
      color: isFilled ? Get.theme.primaryColor : null,
      onPressed: onPress,
      child: Text(
        text,
        style: Get.textTheme.bodyMedium?.copyWith(
          color: isFilled ? Colors.white : null,
          // fontSize: 15,
        ),
      ),
    );
  }
}
