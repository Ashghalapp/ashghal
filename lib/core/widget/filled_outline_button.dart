import 'package:flutter/material.dart';

class FillOutlineButton extends StatelessWidget {
  const FillOutlineButton({
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
        side: const BorderSide(color: Colors.white),
      ),
      elevation: isFilled ? 2 : 0,
      color: isFilled ? Colors.white : Colors.transparent,
      onPressed: onPress,
      child: Text(
        text,
        style: TextStyle(
          color: isFilled ? Colors.blue : Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }
}
