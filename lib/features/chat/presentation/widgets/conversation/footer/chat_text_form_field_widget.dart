// import 'package:ashghal_app_frontend/config/chat_theme.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/screens/camera_screen.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/attachment_bottom_sheet.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/emoji_picker_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';

// class ChatTextFormFieldWidget extends StatelessWidget {
//   final InsertingMessageController insertingMessageController = Get.find();
//   final MultimediaController multimediaController = Get.find();

//   ChatTextFormFieldWidget({super.key});
//   Color getIconsColor(context) =>
//       Theme.of(context).brightness == Brightness.light
//           ? Colors.black54
//           : Colors.white70;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.sizeOf(context).width * 0.85,
//       child: Card(
//         elevation: 2,
//         // shadowColor: Colors.grey,
//         margin: const EdgeInsets.only(left: 6, right: 2, bottom: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50),
//         ),
//         child: TextFormField(
//           onChanged: insertingMessageController.sendTypingNotification,
//           controller: insertingMessageController.messageTextEdittingController,
//           focusNode: insertingMessageController.messageFieldFocusNode,
//           textAlignVertical: TextAlignVertical.center,
//           keyboardType: TextInputType.multiline,
//           maxLines: 5,
//           minLines: 1,
//           style: const TextStyle(color: Colors.black87, fontSize: 16),
//           decoration: InputDecoration(
//             hintStyle: const TextStyle(fontSize: 18),
//             fillColor: Colors.white,
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(50),
//               borderSide: const BorderSide(color: Colors.transparent),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(50),
//               borderSide: const BorderSide(color: Colors.transparent),
//             ),
//             hintText: "Message",
//             // contentPadding: const EdgeInsets.all(5),
//             // border: InputBorder(),
//             prefixIcon: GetX<InsertingMessageController>(
//               builder: (controller) => IconButton(
//                 onPressed: controller.imojiButtonPressed,
//                 icon: Icon(
//                   controller.emojiPickerShowing.value
//                       ? Icons.keyboard
//                       : Icons.emoji_emotions_outlined,
//                   color: getIconsColor(context),
//                 ),
//               ),
//             ),
//             suffixIcon: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 //Attachment Button
//                 IconButton(
//                   onPressed: () async {
//                     await showAttachmentBottomSheet(multimediaController);
//                   },
//                   icon: Icon(
//                     Icons.attach_file,
//                     color: getIconsColor(context),
//                   ),
//                 ),

//                 IconButton(
//                   onPressed: multimediaController.goToCameraScreen,
//                   icon: Icon(
//                     Icons.camera_alt,
//                     color: getIconsColor(context),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/attachment_bottom_sheet.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/emoji_picker_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/send_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionBar extends StatelessWidget {
  ActionBar({Key? key}) : super(key: key);

  final InsertingMessageController insertingMessageController = Get.find();

  final MultimediaController multimediaController = Get.find();

  Color? getIconsColor() => Get.isPlatformDarkMode ? null : Colors.black54;

  // final StreamMessageInputController controller =
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, right: 6),
                  child: GetX<InsertingMessageController>(
                    builder: (controller) => InkWell(
                      onTap: controller.imojiButtonPressed,
                      child: Icon(
                        controller.emojiPickerShowing.value
                            ? Icons.keyboard
                            : Icons.emoji_emotions_outlined,
                        color: getIconsColor(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    onChanged:
                        insertingMessageController.sendTypingNotification,
                    controller: insertingMessageController
                        .messageTextEdittingController,
                    focusNode: insertingMessageController.messageFieldFocusNode,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          Get.isPlatformDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 7),
                      hintText: 'Type something...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await showAttachmentBottomSheet(multimediaController);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Icon(
                      Icons.attach_file,
                      color: getIconsColor(),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                InkWell(
                  onTap: multimediaController.goToCameraScreen,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Icon(
                      Icons.camera_alt_sharp,
                      color: getIconsColor(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 14,
                    bottom: 3,
                    // right: 10,
                  ),
                  child: SendButtonWidget(
                    icon: Icons.send_rounded,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            //this widget shows or unshows its child based on the offstage value
            GetX<InsertingMessageController>(
              builder: (controller) => Offstage(
                offstage: !controller.emojiPickerShowing.value,
                child: SizedBox(
                  height: 250,
                  child: EmojiPickerWidget(
                    textEditingController: insertingMessageController
                        .messageTextEdittingController,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
