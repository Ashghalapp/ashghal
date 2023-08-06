import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUtil {
  static void showErrorToast(String title, String message) {
    Get.snackbar(title, message,
        duration: const Duration(seconds: 4),
        padding: EdgeInsets.only(
          right: 10,
          left: 10,
          top: title == "" ? 0 : 6,
          bottom: title == "" ? 20 : 6,
        ));
  }

  static void showMessage(String message, Color color) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      content: Text(
        message,
        style: Get.textTheme.bodyMedium!.copyWith(color: Colors.white),      
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 4),
    ));
  }
}
