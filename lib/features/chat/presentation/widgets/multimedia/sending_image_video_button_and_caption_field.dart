import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:flutter/material.dart';

class SendingImageVideoButtonAndCaptionField extends StatelessWidget {
  const SendingImageVideoButtonAndCaptionField({
    Key? key,
    required this.onSendButtonTaped,
    required this.captionController,
  }) : super(key: key);

  final VoidCallback onSendButtonTaped;
  final TextEditingController captionController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Form(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: AppTextFormField(
                    hintText: 'Add caption...',
                    label: 'Add caption...',
                    //           onPressed: () =>
                    //  SelectImageFromGalleryButton(receiverId: '123').pickImagesFromGallery(context),
                    obscureText: false,
                    controller: captionController,
                    iconName: AppIcons.plus,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 24,
            child: GestureDetector(
              onTap: onSendButtonTaped,
              child: const Icon(
                Icons.send,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
