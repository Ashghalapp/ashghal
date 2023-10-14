import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future buildButtomSheetToEditField({
  required String title,
  required String initialValue,
  required void Function(String newValue) onSendFunc,
  double height = 200,
  bool autoFocuse = true,
}) {
  var textController = TextEditingController();
  RxBool enableSaveButton = true.obs;
  textController.text = initialValue;
  textController.addListener(() {
    enableSaveButton.value = textController.text.isNotEmpty;
  });

  return Get.bottomSheet(
    Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                autoFocuse: autoFocuse,
              ),
              const SizedBox(height: 5),

              Container(
                alignment: AlignmentDirectional.centerEnd,
                child: Obx(
                  () => TextButton(
                    onPressed: () {
                      Get.focusScope?.unfocus();
                      onSendFunc(textController.text);
                    },
                    child: Text(
                      "Save ",
                      style: Get.textTheme.titleMedium?.copyWith(
                          color: enableSaveButton.value ? null : Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
