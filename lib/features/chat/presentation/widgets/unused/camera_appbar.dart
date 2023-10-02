import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CameraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onFlashPressed;
  final bool isFlashOn;

  const CameraAppBar({
    super.key,
    required this.onFlashPressed,
    required this.isFlashOn,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: Get.theme.appBarTheme.systemOverlayStyle,
      leading: IconButton(
        // iconSize: 30,
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.clear),
      ),
      actions: [
        IconButton(
          onPressed: onFlashPressed,
          icon: Icon(
            isFlashOn ? Icons.flash_on : Icons.flash_off,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
