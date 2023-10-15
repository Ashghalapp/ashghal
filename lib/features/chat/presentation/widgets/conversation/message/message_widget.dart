import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/avatar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/audio_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/file_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/image_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/message_text_status_icon.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/text_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/video_message_widget.dart';

import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart'
    as style;
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// class MessageWidget1 extends StatelessWidget {
//   bool get isMine => message.senderId == SharedPref.currentUserId;

//   final LocalMessage message;
//   final int selectedIndex; // Pass the selected index to the widget
//   final int messageIndex; // Index of the current message in the list

//   MessageWidget1({
//     super.key,
//     required this.message,
//     required this.selectedIndex,
//     required this.messageIndex,
//   });

//   @override
//   Widget build(BuildContext context) {
//     EdgeInsets padding = EdgeInsets.only(
//       top: 7.0,
//       bottom: 7.0,
//       right: isMine ? 12.0 : 7.0,
//       left: isMine ? 7.0 : 7.0,
//     );
//     BoxDecoration boxDecoration = BoxDecoration(
//       color: isMine ? const Color(0xFFDCF8C6) : Colors.white,
//       border: messageIndex == selectedIndex
//           ? Border.all(
//               color: Colors.red,
//               width: 1.0,
//             ) // Green border for selected item
//           : null,
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(isMine ? 0.0 : 15.0),
//         topRight: Radius.circular(isMine ? 15.0 : 0.0),
//         bottomLeft: Radius.circular(isMine ? 0.0 : 1.0),
//         bottomRight: Radius.circular(isMine ? 1.0 : 0.0),
//       ),
//       boxShadow: style.softShadows,
//     );

//     return Container(
//       constraints: BoxConstraints(
//           minWidth: 50, maxWidth: MediaQuery.of(context).size.width - 70),
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
//       alignment: isMine ? Alignment.topRight : Alignment.topLeft,
//       margin: isMine
//           ? const EdgeInsets.only(right: 10)
//           : const EdgeInsets.only(left: 10),
//       child: Container(
//         constraints: BoxConstraints(
//             minWidth: 50, maxWidth: MediaQuery.of(context).size.width - 70),
//         padding: padding,
//         decoration: boxDecoration,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 1),
//             Column(
//               children: [
//                 Text(
//                   message.body ?? "",
//                   textAlign: TextAlign.right,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: style.textColor,
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text('${DateTime.now().hour}:${DateTime.now().minute}   '),
//                     !isMine
//                         ? const SizedBox(width: 5)
//                         : MessageStatusIcon(message: message)
//                   ],
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class MessageWidget extends StatelessWidget {
  // int get currentUserId => SharedPref.currentUserId ?? -1;
  bool get isMine => message.message.senderId == SharedPref.currentUserId;

  final ConversationScreenController _screenController = Get.find();
  final MessageAndMultimediaModel message;
  // final int index;
  MessageWidget({
    super.key,
    required this.message,
    // required this.index,
  });

  // Widget getMessageWidget() {
  // if (message.multimedia != null) {
  //   return ImageMessage(
  //     multimedia: message.multimedia!,
  //     isMine: isMine,
  //   );
  //   // return ImageMessageWidget(message: message, isMine: isMine);
  // }
  // return TextMessageWidget(message: message, isMine: isMine);
  // return MessageTextAndStatusIcon(message: message.message, isMine: isMine);
  // }

  @override
  Widget build(BuildContext context) {
    return
        //  ConstrainedBox(
        //   constraints: BoxConstraints(
        //       // maxWidth: MediaQuery.sizeOf(context).width,
        //       // maxHeight: 250,
        //       // minWidth: 150,
        //       ),
        //   child:
        Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMine)
          MessageCtreatedAtTextWidget(date: message.message.createdAt),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment:
          //     isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMine)
              AvatarWithImageOrLetter(
                raduis: 16,
                boderThickness: 1,
                borderColor: ChatStyle.otherMessageColor!,
                userName: _screenController.conversation.userName,
                imageUrl: _screenController.conversation.userImageUrl,
              ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width - 140,
                // minWidth: 80,
              ),
              child: Card(
                elevation: 1,
                shadowColor: Colors.grey,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: isMine
                    ? ChatStyle.ownMessageColor
                    : ChatStyle.otherMessageColor,
                // color: isMine ? Colors.black87 : Colors.black54,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))
                    // borderRadius: BorderRadius.only(
                    //   bottomLeft: Radius.circular(isMine ? 15.0 : 0),
                    //   bottomRight: Radius.circular(isMine ? 0 : 15),
                    //   topLeft: Radius.circular(15),
                    //   topRight: Radius.circular(15),
                    // ),
                    ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 3.0,
                    horizontal: 3.0,
                  ),
                  child: getMessageAndMultimedia(),
                  // child: Text("message"),
                ),
                // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                // child: Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     children: [
                //       if (message.message.body != null &&
                //           message.message.body!.trim() != "")
                //         getMessageBodyText(message.message.body),
                //       // MessageTextAndStatusIcon(
                //       //   message: message.message,
                //       //   isMine: isMine,
                //       // ),
                //     ],
                //   ),
                // ),
              ),
            ),
            if (isMine)
              MessageStatusIcon(
                message: message.message,
              ),
            // getMessageWidget(),

            // TextMessageWidget(message: message.message),
            // TextMessageWidget(
            //   message: message.message,
            //   isMine: isMine,
            // ),
            // AudioMessageWidget(
            //   message: message.message,
            //   isMine: isMine,
            // ),
            // ImageMessageWidget(
            //   message: message,
            //   isMine: isMine,
            // )
            // Row(
            //   children: [
            //     Visibility(
            //       visible: _screenController.selectionEnabled.value,
            //       child: Icon(
            //         _screenController.selectedMessagesIds
            //                 .contains(currentMessage.message.localId)
            //             ? Icons.check_circle
            //             : Icons.radio_button_unchecked,
            //         size: 30,
            //         color: Colors.red,
            //       ),
            //     ),
            //   ],
            // )
            // SizedBox.shrink()
          ],
          // ),
        ),
        if (!isMine)
          MessageCtreatedAtTextWidget(date: message.message.createdAt),
      ],
    );
  }

  Widget getMessageAndMultimedia() {
    return message.multimedia != null &&
            message.message.body != null &&
            message.message.body?.trim() != ""
        ? Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              getMessage(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 7.0,
                ),
                child: MessageBodyTextWidget(
                  body: message.message.body,
                  isMine: isMine,
                ),
              ),
            ],
          )
        : getMessage();
  }

  Widget getMessage() {
    if (message.multimedia != null && message.multimedia!.type == "image") {
      return ImageMessage(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
      // ImageMessage
    } else if (message.multimedia != null &&
        message.multimedia!.type == "video") {
      return VideoMessageWidget(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
    } else if (message.multimedia != null &&
        message.multimedia!.type == "audio") {
      return AudioMessageWidget(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
    } else if (message.multimedia != null &&
        message.multimedia!.type == "file") {
      return FileMessageWidget(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2.0,
          horizontal: 7.0,
        ),
        child: MessageBodyTextWidget(
          body: message.message.body,
          isMine: isMine,
        ),
      );
    }
  }
}





// class TextMessageWidget extends StatelessWidget {
//   bool get isMine => message.senderId == SharedPref.currentUserId;

//   final LocalMessage message;
//   // final int selectedIndex; // Pass the selected index to the widget
//   // final int messageIndex; // Index of the current message in the list

//   const TextMessageWidget({
//     super.key,
//     required this.message,
//     // required this.selectedIndex,
//     // required this.messageIndex,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: BoxConstraints(
//         maxWidth: MediaQuery.sizeOf(context).width - 60,
//         minWidth: 105,
//       ),
//       child: Card(
//         color: isMine ? Colors.blue[100] : null,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(isMine ? 1.0 : 0.0),
//             // topRight: Radius.circular(isMine ? 0.0 : 0.0),
//             bottomLeft: Radius.circular(isMine ? 15.0 : 1.0),
//             bottomRight: Radius.circular(isMine ? 0.0 : 15.0),
//           ),
//         ),
//         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         child: MessageContentTimeStatusWidget(message: message, isMine: isMine),
//       ),
//     );
//   }
// }




