import 'package:ashghal_app_frontend/features/chat/presentation/getx/Chat/multimedia_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/attachment_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/Chat/inserting_message_controller.dart';

class ChatTextFormFieldWidget extends StatelessWidget {
  final InsertingMessageController insertingMessageController = Get.find();
  final MultimediaController multimediaController = Get.find();

  ChatTextFormFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.85,
      child: Card(
        margin: const EdgeInsets.only(left: 6, right: 2, bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextFormField(
          controller: insertingMessageController.messageTextEdittingController,
          focusNode: insertingMessageController.messageFieldFocusNode,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          minLines: 1,
          decoration: InputDecoration(
            hintText: "Message",
            contentPadding: const EdgeInsets.all(5),
            border: InputBorder.none,
            prefixIcon: GetX<InsertingMessageController>(
              builder: (controller) => IconButton(
                onPressed: controller.imojiButtonPressed,
                icon: Icon(
                  controller.emojiPickerShowing.value
                      ? Icons.keyboard
                      : Icons.emoji_emotions_outlined,
                ),
              ),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Attachment Button
                IconButton(
                  onPressed: () async {
                    await showAttachmentBottomSheet(multimediaController);
                  },
                  icon: const Icon(Icons.attach_file),
                ),

                IconButton(
                  onPressed: () {
                    multimediaController.takeCameraPhoto();
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
