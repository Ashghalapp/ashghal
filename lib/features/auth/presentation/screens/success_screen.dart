import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/app_colors.dart';

import '../../../../config/app_routes.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../../core/widget/app_buttons.dart';

class SuccesResetPassword extends StatelessWidget {
  final String message;
  const SuccesResetPassword({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          AppLocalization.success,
          style:  TextStyle(
            // fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color:AppColors.bodyDark1,
          ),
        ),
        leading: MyCircularIconButton(
          onPressed: () {
            // Get.back();
          },
          iconData: Icons.arrow_back_ios,
          iconColor: AppColors.iconColor,
        ),
      ),
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
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                height: 2,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            MyGesterDedector(
              text: AppLocalization.signIn,
              onTap: () => Get.offAllNamed(AppRoutes.logIn),
            )
          ],
        ),
      ),
    );
  }
}
