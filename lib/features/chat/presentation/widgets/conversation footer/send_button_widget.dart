import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:flutter/material.dart';

class SendButtonWidget extends StatelessWidget {
  const SendButtonWidget({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.onLongPressed,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback? onLongPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ChatColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ChatColors.primary.withOpacity(0.3),
            spreadRadius: 8,
            blurRadius: 24,
          ),
        ],
      ),
      child: ClipOval(
        child: Material(
          color: ChatColors.primary,
          child: GestureDetector(
            onTap: onPressed,
            onLongPress: onLongPressed,
            child: SizedBox(
              width: 42,
              height: 42,
              child: Icon(
                icon,
                size: 26,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
