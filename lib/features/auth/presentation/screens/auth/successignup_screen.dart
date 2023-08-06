
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_routes.dart';
import '../../../../../core/core/widget/app_buttons.dart';

class SuccesSignUp extends StatelessWidget{ //GetView<SuccessSignUpControllerImp> {
  const SuccesSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.lazyPut(() =>  SuccessSignUpControllerImp());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '32'.tr,
          style: const TextStyle(
            // fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.gray,
          ),
        ),
        // leading: MyCircularIconButton(
        //   onPressed: () {
        //     Get.back();
        //   },
        //   iconData: Icons.arrow_back_ios,
        //   iconColor: AppColors.gray,
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
             Center(
              child: Icon(
                Icons.check_circle_outline,
                size: 200,
                color:Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '38'.tr,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  height: 2,
                  color: Colors.grey),
            ),

            // Spacer(),
            const SizedBox(
              height: 40,
            ),
            MyGesterDedector(
              text: '31'.tr,
              onTap: () => Get.offAllNamed(AppRoutes.logIn),
            )
          ],
        ),
      ),
    );
  }
}
