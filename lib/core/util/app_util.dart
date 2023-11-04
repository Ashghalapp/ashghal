import 'dart:io';
import 'package:ashghal_app_frontend/config/app_patterns.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:ashghal_app_frontend/core_api/api_constant.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppUtil {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Widget addProgressIndicator(double? size) {
    return Center(
        child: SizedBox(
      width: size ?? 40,
      height: size ?? 40,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        backgroundColor: Colors.black12,
        valueColor: AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
      ),
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
        child: AppGesterDedector(onTap: () => Get.back(), text: "Ok"),
      ),
    );
  }

  ///دالة لفحص الانترنت
  static Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  static String editUrl(String url) {
    // return url.replaceAll(RegExp(r'localhost'), '10.0.2.2:8000');
    return url.replaceAll(RegExp(r'localhost'), ApiConstants.baseIp);
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

  static void hanldeAndShowFailure(Failure failure, {String prefixText = ""}) {
    if (failure is NotSpecificFailure) {
      // if (!failure.message.contains("DioException")) {
      buildErrorDialog("$prefixText ${failure.message}");
      // }
    } else {
      String message = failure.message;
      // الحصول على رسائل الاخطاء وتحويلها الى نص وعرضها للمستخدم
      if (failure.errors != null) {
        message = (failure.errors as Map).entries.map((entry) {
          final key = entry.key;
          final value = entry.value;
          return "$key: $value";
        }).join('\n');
      }
      showMessage("$prefixText $message", Get.theme.colorScheme.error);
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

  static buildDialog(
    String title,
    String message,
    void Function() onSubmitPresed, {
    bool isShowCancelButton = true,
    String? cancelButtonText,
    String? submitButtonText,
  }) {
    return Get.defaultDialog(
      backgroundColor: Get.theme.dialogBackgroundColor,
      title: title,
      titleStyle:
          TextStyle(color: Get.theme.primaryColor, fontWeight: FontWeight.bold),
      middleText: message,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.primaryColor,
          ),
          onPressed: onSubmitPresed,
          child: Text(
            submitButtonText ?? AppLocalization.submit,
            style: Get.theme.primaryTextTheme.labelSmall,
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
              cancelButtonText ?? AppLocalization.cancle,
              style: Get.theme.primaryTextTheme.labelSmall,
            ),
          )
      ],
    );
  }

  static Future<bool> exitApp(BuildContext context) {
    buildDialog(
      AppLocalization.warning,
      AppLocalization.doyouwanttoexitApp,
      () {
        exit(0);
      },
    );
    return Future.value(true);
  }

  static Shimmer getShimmerForFullPage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: Get.width - 10,
        height: Get.height,
        color: Colors.grey[300],
      ),
    );
  }

  static Future buildBottomsheet({double height = 200, required Widget child}) {
    return Get.bottomSheet(
      Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              right: Get.locale?.languageCode == 'en' ? 10 : null,
              left: Get.locale?.languageCode == 'ar' ? 10 : null,
              child: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Get.back(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  static Future buildButtomSheetToEditField({
    required String title,
    required String initialValue,
    required void Function(String newValue) onSave,
    double height = 200,
    bool autoFocuse = true,
  }) {
    var textController = TextEditingController();
    RxBool enableSaveButton = true.obs;
    textController.text = initialValue;
    textController.addListener(() {
      enableSaveButton.value = textController.text.isNotEmpty;
    });

    return buildBottomsheet(
      height: height,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.only(
              right: Get.locale?.languageCode == 'ar' ? 10 : 0,
              left: Get.locale?.languageCode == 'en' ? 10 : 0,
            ),
            child: Text(
              title,
              style: Get.textTheme.titleMedium,
            ),
          ),
          AppTextFormField(
            controller: textController,
            hintText: '',
            obscureText: false,
            onSuffixIconPressed: () {},
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            autoFocuse: autoFocuse,
          ),
          const SizedBox(height: 5),
          Container(
            alignment: AlignmentDirectional.centerEnd,
            child: Obx(
              () => TextButton(
                onPressed: () {
                  Get.focusScope?.unfocus();
                  onSave(textController.text);
                  Get.back();
                },
                child: Text(
                  AppLocalization.save.tr,
                  style: Get.textTheme.titleMedium?.copyWith(
                      color: enableSaveButton.value ? null : Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future buildButtomsheetToEditRadio({
    required String title,
    required List<String> values,
    required String initialValue,
    required void Function(String newValue) onSave,
    double height = 250,
  }) {
    RxString selectedValue = initialValue.obs;
    return buildBottomsheet(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: AlignmentDirectional.centerStart,
              margin: EdgeInsets.only(
                right: Get.locale?.languageCode == 'ar' ? 10 : 0,
                left: Get.locale?.languageCode == 'en' ? 10 : 0,
              ),
              child: Text(
                title,
                style: Get.textTheme.titleMedium,
              ),
            ),
            for (int i = 0; i < values.length; i++)
              Obx(
                () => RadioListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  title: Text(values[i]),
                  value: values[i].tr,
                  groupValue: selectedValue.value,
                  onChanged: (Object? value) {
                    selectedValue.value = value.toString();
                  },
                ),
              ),
            const SizedBox(height: 5),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () {
                  Get.focusScope?.unfocus();
                  onSave(selectedValue.value);
                  Get.back();
                },
                child: Text(
                  "Save ",
                  style: Get.textTheme.titleMedium,
                ),
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
            Get.back(
                result: true); // Close the dialog and return true as the result
          },
          child: Text(confirmLabel),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back(
                result:
                    false); // Close the dialog and return false as the result
          },
          child: Text(abortLabel),
        ),
      ],
    );
  }

  static String getFormatedFileSize(int bytes) {
    // final file = File(filePath);

    // if (!file.existsSync()) {
    //   // Handle the case where the file doesn't exist
    //   return 'File not found';
    // }

    // final bytes = file.lengthSync();
    // if (bytes < 100) {
    //   return '$bytes B';
    // }
    // else
    if (bytes < 100) {
      return '$bytes B';
    } else if (bytes < 1024 * 10) {
      final fileSizeKB = (bytes / 1024).toStringAsFixed(2);
      return '$fileSizeKB KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      final fileSizeMB = (bytes / (1024 * 1024)).toStringAsFixed(2);
      return '$fileSizeMB MB';
    } else {
      final fileSizeGB = (bytes / (1024 * 1024 * 1024)).toStringAsFixed(2);
      return '$fileSizeGB GB';
    }
  }

  static Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final fileStat = await file.stat();
        return fileStat.size;
      } else {
        return -1; // File doesn't exist
      }
    } catch (e) {
      print('Error getting file size: $e');
      return -1; // Error occurred
    }
  }

  static bool hasURLInText(String text) {
    // Check if the text contains a URL
    // final urlPattern = RegExp(
    //     r"http(s)?://[a-zA-Z0-9.-]+(\.[a-zA-Z]{2,4})+(?:[^\s]*)?",
    //     caseSensitive: false);

    return AppPatterns.urlPattern.hasMatch(text);
  }

  static String? getURLInText(String text) {
    // Check if the text contains a URL
    // final urlPattern = RegExp(
    //     r"http(s)?://[a-zA-Z0-9.-]+(\.[a-zA-Z]{2,4})+(?:[^\s]*)?",
    //     caseSensitive: false);

    return AppPatterns.urlPattern.firstMatch(text)?[0];
  }
}
