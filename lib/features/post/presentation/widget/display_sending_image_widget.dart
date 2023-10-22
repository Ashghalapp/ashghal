import 'dart:io';

import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DisplaySendingImageWidget extends StatelessWidget {
  final String imageUrl;
  final void Function(String content, String imagePath)? onSend;
  DisplaySendingImageWidget({
    super.key,
    required this.imageUrl,
    this.onSend,
  });

  late final RxString newImagePath = RxString(imageUrl);
  final captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String? languageCode = Get.locale?.languageCode;
    print(imageUrl);
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () async {
      //       final imagePicker = ImagePicker();
      //       XFile? pickedFile =
      //           await imagePicker.pickImage(source: ImageSource.gallery);
      //       if (pickedFile != null) {
      //         newImagePath.value = pickedFile.path;
      //       }
      //     },
      //     icon: Icon(
      //       languageCode == 'ar' ? Icons.arrow_forward : Icons.arrow_back,
      //       color: Colors.white,
      //     ),
      //   ),
      //   backgroundColor: Colors.black87,
      // ),
      resizeToAvoidBottomInset: false,
      body: Container(
        // margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        color: const Color.fromRGBO(0, 0, 0, 0.867),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).viewPadding.top,
              child: IconButton(
                onPressed: () async {
                  final imagePicker = ImagePicker();
                  XFile? pickedFile =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    newImagePath.value = pickedFile.path;
                  }
                },
                icon: Icon(
                  languageCode == 'ar' ? Icons.arrow_forward : Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              child: Obx(
                () => Image.file(
                  File(
                    newImagePath
                        .value, //.isEmpty ? imageUrl : newImagePath.value,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            if (onSend != null)
              Container(
                alignment: AlignmentDirectional.bottomEnd,
                child: _buildSendBar(languageCode, context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendBar(String? languageCode, BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                right: languageCode == 'en' ? 10 : 0,
                left: languageCode == 'ar' ? 10 : 0,
              ),
              child: AppTextFormField(
                controller: captionController,
                hintText: 'caption',
                label: 'caption',
                obscureText: false,
                // onSuffixIconPressed: () {},
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                autoFocuse: false,
                radius: 30,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Get.theme.primaryColor,
            ),
            child: IconButton(
              onPressed: () {
                Get.focusScope?.unfocus();
                // if (captionController.text.isEmpty) {
                //   captionController.text = " ";
                // }
                onSend!(captionController.text, newImagePath.value);
              },
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
