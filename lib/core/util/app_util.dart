import 'dart:io';
import 'package:ashghal_app_frontend/config/app_patterns.dart';
import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/dependency_injection.dart';
import 'package:ashghal_app_frontend/core/util/dialog_util.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/core/widget/app_dropdownbuttonformfield.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:ashghal_app_frontend/core_api/api_util.dart';
import 'package:ashghal_app_frontend/core_api/api_constant.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/check_password_uc.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/participant_model.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_screen.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/custom_report_buttomsheet.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppUtil {
  static Future<void> loadCategories() async {
    (await ApiUtil.getCategoriesFromApi()).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
    }, (resultCategories) {
      SharedPref.setCategories(resultCategories);
    });
  }

  static bool checkUserLoginAndNotifyUser() {
    if (SharedPref.getCurrentUserData() == null) {
      DialogUtil.showSignInDialog();
      return false;
    }
    return true;
  }

  static PopupMenuButtonWidget getPostMenuButtonValuesWidget(Post post,
      [Map<String, Object>? user]) {
    final values = [
      AppLocalization.copy,
      AppLocalization.report,
      // AppLocalization.chat
    ];

    return PopupMenuButtonWidget(
      items: values,
      onSelected: (value) {
        return postPopupMenuButtonOnSelected(value, post, user);
      },
    );
  }

  static void postPopupMenuButtonOnSelected(String value, Post post,
      [Map<String, Object>? user]) async {
    if (value == AppLocalization.copy) {
      ClipboardData clipboardData = ClipboardData(text: post.content);
      await Clipboard.setData(clipboardData);
      showMessage(AppLocalization.postContentCopied, Colors.grey);
    } else if (value == AppLocalization.report) {
      Get.bottomSheet(CustomBottomSheet());
    } else if (value == AppLocalization.chat) {
      if (user != null && user['id'] != null && user['name'] != null) {
        ParticipantModel participant = ParticipantModel(
          id: int.parse(user['id'].toString()),
          name: user['name'].toString(),
        );
        Get.to(() => ChatScreen(user: participant));
      }
    }
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Widget addProgressIndicator([double? size, Color? color]) {
    return Center(
        child: SizedBox(
      width: size ?? 40,
      height: size ?? 40,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        backgroundColor: Colors.black12,
        valueColor:
            AlwaysStoppedAnimation<Color>(color ?? Get.theme.primaryColor),
      ),
    ));
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

  static void showErrorToast(String message) {
    Get.snackbar(
      "",
      message,
      duration: const Duration(seconds: 4),
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
        // top: title == "" ? 0 : 6,
        // bottom: title == "" ? 20 : 6,
        top: 0,
        bottom: 20,
      ),
    );
  }

  static void hanldeAndShowFailure(Failure failure, {String prefixText = ""}) {
    if (failure is NotSpecificFailure) {
      // if (!failure.message.contains("DioException")) {
      DialogUtil.showErrorDialog("$prefixText ${failure.message}");
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

  static Future<bool> exitApp(BuildContext context) {
    DialogUtil.showDialog(
      title: AppLocalization.warning,
      message: AppLocalization.doyouwanttoexitApp,
      onSubmit: () {
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

  static String timeAgoSince(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return AppLocalization.now.tr;
    }
    // else if (difference.inSeconds < 60) {
    //   return '${difference.inSeconds} seconds ago';
    // }
    else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;

      return '$minutes ${minutes == 1 ? AppLocalization.minute.tr : AppLocalization.minutes.tr} ${AppLocalization.ago.tr}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? AppLocalization.hour.tr : AppLocalization.hours.tr} ${AppLocalization.ago.tr}';
    } else if (difference.inDays == 1) {
      final s = dateTime.subtract(const Duration(days: 1));
      return '${AppLocalization.yesterday.tr} ${getHourMinuteDateFormat(s)}';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? AppLocalization.day.tr : AppLocalization.days.tr} ${AppLocalization.ago.tr}';
    } else if (difference.inDays < 30) {
      final int days = difference.inDays;
      int weak = 1;
      if (days < 14) {
        weak = 1;
      } else if (days < 21) {
        weak = 2;
      } else if (days < 28) {
        weak = 3;
      } else {
        weak = 4;
      }
      return '$weak ${weak == 1 ? AppLocalization.week.tr : AppLocalization.weeks.tr} ${AppLocalization.ago.tr}';
    } else {
      // If it's more than a week ago, return the actual date
      return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
    }
  }

  static String getHourMinuteDateFormat(DateTime dateTime) {
    final hour =
        (dateTime.hour == 12 || dateTime.hour == 0 ? 12 : dateTime.hour % 12)
            .toString()
            .padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    print(minute);
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // If the date is today, return the time (HH:mm a format).
      return getHourMinuteDateFormat(dateTime);
    } else if (difference.inDays == 1) {
      // If the date is yesterday, return "Yesterday".
      return AppLocalization.yesterday;
    } else {
      // If more than one day has passed, return the date in "dd/MM/yy" format.
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final year = dateTime.year.toString().substring(2);
      return '$day/$month/$year';
    }
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
