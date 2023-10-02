import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:flutter/material.dart';

class MessageTextAndStatusIcon extends StatelessWidget {
  final LocalMessage message;
  final bool isMine;

  const MessageTextAndStatusIcon({
    super.key,
    required this.message,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 25,
            left: 10,
            right: 10,
            top: 3,
          ),
          child: getMessageBodyText(message.body),
        ),
        Positioned(
          right: 10,
          bottom: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              getMessageCreatedAtText(message.createdAt),
              if (isMine) MessageStatusIcon(message: message),
            ],
          ),
        )
      ],
    );
  }
}
