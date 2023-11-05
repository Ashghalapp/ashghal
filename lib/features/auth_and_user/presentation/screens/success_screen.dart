import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/app_colors.dart';

import '../../../../config/app_routes.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../../core/widget/app_buttons.dart';

class SuccessScreen extends StatelessWidget {
  final String message;
  final String? buttonText;
  final void Function()? onClick;
  const SuccessScreen({
    super.key,
    required this.message,
    required this.buttonText,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalization.success)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Center(
              child: Icon(
                Icons.check_circle_outline,
                size: 200,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              message.tr,
              style: Get.textTheme.bodyLarge,
              // style: const TextStyle(
              //   fontWeight: FontWeight.normal,
              //   fontSize: 14,
              //   height: 2,
              //   color: Colors.grey,
              // ),
            ),
            const SizedBox(height: 40),
            if (buttonText != null)
            AppGesterDedector(
              text: buttonText!,
              onTap: () {
                if (onClick != null){
                  onClick!();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
