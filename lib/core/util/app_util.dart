import 'dart:io';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/app_buttons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppUtil {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Widget addProgressIndicator(BuildContext context, double? size) {
    return Center(
        child: SizedBox(
      width: size ?? 50,
      height: size ?? 50,
      child: CircularProgressIndicator(
          strokeWidth: 2.0,
          backgroundColor: Colors.black12,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
    ));
  }

  static Future buildErrorDialog(String message) {
    final size = Get.mediaQuery.size;
    return Get.defaultDialog(
      title: "Error!",
      titlePadding: const EdgeInsets.only(top: 20, bottom: 10),
      content: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(message),
      ),
      confirm: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MyGesterDedector(onTap: () => Get.back(), text: "Ok"),
      ),
    );
  }

  ///دالة لفحص الانترنت
  static Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

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

  static void hanldeAndShowFailure(Failure failure, {String prefixText= ""}) {
    if (failure is NotSpecificFailure) {
      buildErrorDialog("$prefixText ${failure.message}");
    } else {
      showMessage("$prefixText ${failure.message}", Get.theme.colorScheme.error);
    }
  }

  static void showMessage(String message, Color color) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      content: Text(
        message.tr,
        style: Get.textTheme.bodyMedium!.copyWith(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.fixed,
    ));
  }

  static Future<bool> exitApp(BuildContext context) {
    Get.defaultDialog(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: AppLocalization.warning,
        titleStyle: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        middleText: AppLocalization.doyouwanttoexitApp,
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor)),
            onPressed: () {
              exit(0);
            },
            child:  Text(
              AppLocalization.submit,
              style:Theme.of(context).primaryTextTheme.labelSmall,
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor)),
              onPressed: () {
                Get.back();
              },
              child:  Text(
              AppLocalization.cancle,
                style:Theme.of(context).primaryTextTheme.labelSmall,
              ))
        ]);
    return Future.value(true);
  }
}
