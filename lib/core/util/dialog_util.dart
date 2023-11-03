import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtil {
  static Future showDialogForWidget({required Widget child}) {
    return Get.defaultDialog(
      title: "",
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: child,
    );
  }

  static showDialog(
    {
     String? title,
    String? message,
    void Function()? onSubmit,
    Widget? content,
    bool isShowCancelButton = true,
    String? cancelButtonText,
    String? submitText,
  }) {
    return Get.defaultDialog(
      backgroundColor: Get.theme.dialogBackgroundColor,
      title: title?? "",
      titlePadding: title == null ? EdgeInsets.zero : null,
      titleStyle:
          TextStyle(color: Get.theme.primaryColor, fontWeight: FontWeight.bold),
      middleText: message?? "",
      content: content,
      actions: [
        Container(
          width: !isShowCancelButton? Get.width : null,
          padding: !isShowCancelButton? const EdgeInsets.symmetric(horizontal: 20): null,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.primaryColor,
            ),
            onPressed: onSubmit,
            child: Text(
              submitText ?? AppLocalization.submit,
              style: Get.theme.primaryTextTheme.labelSmall,
            ),
          ),
        ),
        if (isShowCancelButton)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.primaryColor,
            ),
            onPressed: () {
              Get.back();
            },
            child: Text(
              cancelButtonText ?? AppLocalization.cancel,
              style: Get.theme.primaryTextTheme.labelSmall,
            ),
          )
      ],
    );
  }

  static showSignInDialog() {
    return showDialogForWidget(
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15, top: 5),
              child: Text(
                AppLocalization.signUpForAccount,
                style: Get.textTheme.bodyLarge,
              ),
            ),
            SizedBox(
              width: Get.width,
              height: 35,
              child: TextButton(
                onPressed: () => Get.toNamed(AppRoutes.logIn),
                child: Text(AppLocalization.signUp),
              ),
            ),
            const Divider(),
            SizedBox(
              width: Get.width,
              height: 35,
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text(AppLocalization.cancel,
                    style: Get.textTheme.bodyMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool?> showConfirmationDialog(String confirmText,
      [String confirmLabel = "yes", String abortLabel = "No"]) async {
    return Get.defaultDialog<bool>(
      title: 'Confirmation'.tr,
      middleText: confirmText,
      actions: [
        ElevatedButton(
          onPressed: () {
            // Close the dialog and return true as the result
            Get.back(result: true);
          },
          child: Text(confirmLabel),
        ),
        ElevatedButton(
          onPressed: () {
            // Close the dialog and return false as the result
            Get.back(result: false);
          },
          child: Text(abortLabel),
        ),
      ],
    );
  }

  static Future showErrorDialog(String message) {
    final size = Get.mediaQuery.size;
    return showDialog(
      title: AppLocalization.error,
      onSubmit:  () => Get.back(),
      submitText: AppLocalization.ok,
      isShowCancelButton: false,
      content: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(message),
      ),
    );
    // return Get.defaultDialog(
    //   title: "Error!",
    //   titlePadding: const EdgeInsets.only(top: 20, bottom: 10),
    //   content: Container(
    //     width: size.width,
    //     padding: const EdgeInsets.symmetric(horizontal: 10),
    //     child: Text(message),
    //   ),
    //   confirm: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: AppGesterDedector(onTap: () => Get.back(), text: "Ok"),
    //   ),
    // );
  }
}
