import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/message_status_icon.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart'
    as style;
import 'package:flutter/material.dart';

class MessageWidget1 extends StatelessWidget {
  bool get isMine => message.senderId == SharedPref.currentUserId;

  final LocalMessage message;
  final int selectedIndex; // Pass the selected index to the widget
  final int messageIndex; // Index of the current message in the list

  MessageWidget1({
    super.key,
    required this.message,
    required this.selectedIndex,
    required this.messageIndex,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = EdgeInsets.only(
      top: 7.0,
      bottom: 7.0,
      right: isMine ? 12.0 : 7.0,
      left: isMine ? 7.0 : 7.0,
    );
    BoxDecoration boxDecoration = BoxDecoration(
      color: isMine ? const Color(0xFFDCF8C6) : Colors.white,
      border: messageIndex == selectedIndex
          ? Border.all(
              color: Colors.red,
              width: 1.0,
            ) // Green border for selected item
          : null,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isMine ? 0.0 : 15.0),
        topRight: Radius.circular(isMine ? 15.0 : 0.0),
        bottomLeft: Radius.circular(isMine ? 0.0 : 1.0),
        bottomRight: Radius.circular(isMine ? 1.0 : 0.0),
      ),
      boxShadow: style.softShadows,
    );

    return Container(
      constraints: BoxConstraints(
          minWidth: 50, maxWidth: MediaQuery.of(context).size.width - 70),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
      alignment: isMine ? Alignment.topRight : Alignment.topLeft,
      margin: isMine
          ? const EdgeInsets.only(right: 10)
          : const EdgeInsets.only(left: 10),
      child: Container(
        constraints: BoxConstraints(
            minWidth: 50, maxWidth: MediaQuery.of(context).size.width - 70),
        padding: padding,
        decoration: boxDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1),
            Column(
              children: [
                Text(
                  message.body ?? "",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    color: style.textColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${DateTime.now().hour}:${DateTime.now().minute}   '),
                    !isMine
                        ? const SizedBox(width: 5)
                        : MessageStatusIcon(message: message)
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  bool get isMine => message.senderId == SharedPref.currentUserId;

  final LocalMessage message;
  // final int selectedIndex; // Pass the selected index to the widget
  // final int messageIndex; // Index of the current message in the list

  MessageWidget({
    super.key,
    required this.message,
    // required this.selectedIndex,
    // required this.messageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width - 60,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMine ? 0.0 : 15.0),
            topRight: Radius.circular(isMine ? 15.0 : 0.0),
            bottomLeft: Radius.circular(isMine ? 0.0 : 1.0),
            bottomRight: Radius.circular(isMine ? 1.0 : 0.0),
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: MessageContentTimeStatusWidget(message: message, isMine: isMine),
      ),
    );
  }
}

class MessageContentTimeStatusWidget extends StatelessWidget {
  const MessageContentTimeStatusWidget({
    super.key,
    required this.message,
    required this.isMine,
  });

  final LocalMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30,
            left: 10,
            right: 10,
            top: 10,
          ),
          child: Text(
            message.body ?? "",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              color: style.textColor,
            ),
          ),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${DateTime.now().hour}:${DateTime.now().minute}   '),
              !isMine
                  ? const SizedBox(width: 5)
                  : MessageStatusIcon(message: message)
            ],
          ),
        )
      ],
    );
  }
}
