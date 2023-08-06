import 'dart:io';


import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../constant/app_colors.dart';

Future<bool> exitApp(BuildContext context) {

  Get.defaultDialog(
      title: "تنبيه",
      titleStyle:  TextStyle(
          color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
      middleText: "هل تريد الخروج من التطبيق؟",
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor)),
          onPressed: () {
            exit(0);
          },
          child: const Text(
            "تاكيد",
            style: TextStyle(color: AppColors.textColor),
          ),
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor)),
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "الغاء",
              style: TextStyle(color: AppColors.textColor),
            ))
      ]);
  return Future.value(true);
}
