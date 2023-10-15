import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/camera_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/attachment_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';

class ChatTextFormFieldWidget extends StatelessWidget {
  final InsertingMessageController insertingMessageController = Get.find();
  final MultimediaController multimediaController = Get.find();

  ChatTextFormFieldWidget({super.key});
  Color getIconsColor(context) =>
      Theme.of(context).brightness == Brightness.light
          ? Colors.black54
          : Colors.white70;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.85,
      child: Card(
        elevation: 2,
        // shadowColor: Colors.grey,
        margin: const EdgeInsets.only(left: 6, right: 2, bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: TextFormField(
          onChanged: insertingMessageController.sendTypingNotification,
          controller: insertingMessageController.messageTextEdittingController,
          focusNode: insertingMessageController.messageFieldFocusNode,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          minLines: 1,
          style: const TextStyle(color: Colors.black87, fontSize: 18),
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 18),
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            hintText: "Message",
            // contentPadding: const EdgeInsets.all(5),
            // border: InputBorder(),
            prefixIcon: GetX<InsertingMessageController>(
              builder: (controller) => IconButton(
                onPressed: controller.imojiButtonPressed,
                icon: Icon(
                  controller.emojiPickerShowing.value
                      ? Icons.keyboard
                      : Icons.emoji_emotions_outlined,
                  color: getIconsColor(context),
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
                  icon: Icon(
                    Icons.attach_file,
                    color: getIconsColor(context),
                  ),
                ),

                IconButton(
                  onPressed: multimediaController.goToCameraScreen,
                  icon: Icon(
                    Icons.camera_alt,
                    color: getIconsColor(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
