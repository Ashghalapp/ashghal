import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/widget/app_dropdownbuttonformfield.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetUtil {
  static Future buildBottomsheet({
    double height = 210,
    required Widget child,
    void Function()? onClose,
  }) {
    return Get.bottomSheet(
      Container(
        // width: double.infinity,
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
                onPressed: () {
                  Get.back();
                  onClose ?? ();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
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
    double height = 210,
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
          _buildTitleForBottomSheet(title),
          AppTextFormField(
            controller: textController,
            labelText: '',
            obscureText: false,
            onSuffixIconPressed: () {},
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            autoFocuse: autoFocuse,
          ),
          const SizedBox(height: 5),
          Obx(
            () => _buildSaveButtonForButtomSheet(
              () => onSave(textController.text),
              buttonColor: enableSaveButton.value ? null : Colors.grey,
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
    double height = 260,
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
            _buildTitleForBottomSheet(title),
            for (int i = 0; i < values.length; i++)
              Obx(
                () => RadioListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  title: Text(values[i].tr),
                  value: values[i],
                  groupValue: selectedValue.value,
                  onChanged: (Object? value) {
                    print("<<<<<<<<<<<<<<<<<<<<<<Value: ${value.toString()}");
                    selectedValue.value = value.toString();
                  },
                ),
              ),
            const SizedBox(height: 5),
            _buildSaveButtonForButtomSheet(() {
              onSave(selectedValue.value);
            })
          ],
        ),
      ),
    );
  }

  static Future buildButtomsheetToEditList({
    required String title,
    required List<Map<String, Object>> items,
    required int initialValue,
    TextEditingController? controller,
    required void Function(int newValue)? onSave,
    double height = 210,
  }) {
    int newValue = initialValue;
    return buildBottomsheet(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTitleForBottomSheet(title),
            AppDropDownButton(
              items: items,
              onChange: (selectedValue) {
                newValue = selectedValue != null
                    ? int.parse(selectedValue.toString())
                    : initialValue;
              },
              initialValue: initialValue,
            ),
            const SizedBox(height: 5),
            _buildSaveButtonForButtomSheet(() {
              if (onSave != null) {
                onSave(newValue);
              }
            }),
          ],
        ),
      ),
    );
  }

  static Widget _buildTitleForBottomSheet(String title) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      margin: EdgeInsets.only(
        right: Get.locale?.languageCode == 'ar' ? 10 : 0,
        left: Get.locale?.languageCode == 'en' ? 10 : 0,
      ),
      child: Text(
        title.tr,
        style: Get.textTheme.titleMedium,
      ),
    );
  }

  static Widget _buildSaveButtonForButtomSheet(Function onSave,
      {Color? buttonColor}) {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton(
        onPressed: () {
          Get.focusScope?.unfocus();
          onSave();
          Get.back();
        },
        child: Text(
          AppLocalization.save.tr,
          style: Get.textTheme.titleMedium?.copyWith(color: buttonColor),
        ),
      ),
    );
  }
}
