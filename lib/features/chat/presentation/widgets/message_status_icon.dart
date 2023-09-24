import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum MessageStatus {
  notSent,
  sent,
  received,
  read,
}

class MessageStatusIcon extends StatelessWidget {
  final LocalMessage message;
  const MessageStatusIcon({super.key, required this.message});

  MessageStatus get messageStatus {
    if (message.sentAt != null) {
      if (message.recievedAt != null) {
        if (message.readAt != null) {
          return MessageStatus.read;
        }
        return MessageStatus.received;
      }
      return MessageStatus.sent;
    }
    return MessageStatus.notSent;
  }

  @override
  Widget build(BuildContext context) {
    return messageStatus == MessageStatus.read
        ? const Icon(
            FontAwesomeIcons.checkDouble,
            color: Colors.blue,
            size: 16,
          )
        : messageStatus == MessageStatus.received
            ? const Icon(
                FontAwesomeIcons.checkDouble,
                color: Colors.grey,
                size: 16,
              )
            : messageStatus == MessageStatus.sent
                ? const Icon(Icons.check, color: Colors.green)
                : const Icon(
                    Icons.access_time,
                    color: Colors.green,
                  );
  }
}
