import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/avatar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/audio_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/file_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/image_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/links_preview_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/reply_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/video_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/chat_style.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageRowWidget extends StatelessWidget {
  bool get isMine => message.message.senderId == SharedPref.currentUserId;

  final ConversationScreenController _screenController = Get.find();
  final MessageAndMultimediaModel message;
  // final LocalConversation conversation;
  final Function()? onSwipe;

  MessageRowWidget({
    super.key,
    required this.message,
    this.onSwipe,

    // required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return onSwipe != null &&
            ((isMine && message.message.remoteId != null) || (!isMine))
        ? SwipeTo(
            onRightSwipe: () => onSwipe!(),
            // onLeftSwipe: isMine ? () => onSwipe ?? (message) : null,
            child: _buildMessageRow(),
          )
        : _buildMessageRow();
  }

  Row _buildMessageRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMine)
          MessageCtreatedAtTextWidget(date: message.message.createdAt),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMine)
              AvatarWithImageOrLetter(
                raduis: 16,
                boderThickness: 1,
                borderColor: ChatStyle.ownMessageColor,
                userName: _screenController.currentConversation.userName,
                imageUrl: _screenController.currentConversation.userImageUrl,
                userId: _screenController.currentConversation.userId,
                showImageOnPress: false,
              ),
            MessageCardWidget(
              message: message,
              // onSwipe: onSwipe,
              replyMessageUserName:
                  _screenController.currentConversation.userName,
              getReplyMessage: (replyMessageRemoteId) => _screenController
                  .getMessageWithRemoteId(replyMessageRemoteId),
              onMessageReplyPressed: (replyMessageLocalId) => _screenController
                  .scrollToMessageReplyWithId(replyMessageLocalId),
            ),
            if (isMine)
              MessageStatusIcon(
                message: message.message,
              ),
          ],
          // ),
        ),
        if (!isMine)
          MessageCtreatedAtTextWidget(date: message.message.createdAt),
      ],
    );
  }
}

class MessageCardWidget extends StatelessWidget {
  bool get isMine => message.message.senderId == SharedPref.currentUserId;

  // final ConversationScreenController _screenController = Get.find();
  final MessageAndMultimediaModel message;
  final bool isReady;
  final String replyMessageUserName;
  // final Function(MessageAndMultimediaModel message)? onSwipe;
  final MessageAndMultimediaModel? Function(int replyMessageRemoteId)?
      getReplyMessage;
  final void Function(int replyMessageLocalId)? onMessageReplyPressed;
  // final LocalConversation conversation;
  const MessageCardWidget({
    super.key,
    required this.message,
    // this.onSwipe,
    this.isReady = false,
    required this.replyMessageUserName,
    this.getReplyMessage,
    this.onMessageReplyPressed,
    // required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isMine
            ? MediaQuery.sizeOf(context).width - 120
            : MediaQuery.sizeOf(context).width - 140,
      ),
      child: Card(
        elevation: 1,
        shadowColor: Colors.grey,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isMine
            ? ChatStyle.ownMessageColor
            : Get.isPlatformDarkMode
                ? ChatStyle.otherMessageDarkColor
                : ChatStyle.otherMessageLightColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 3.0,
            horizontal: 3.0,
          ),
          child: MessageWidget(
            message: message,
            isReady: isReady,
            replyMessageUserName: replyMessageUserName,
            getReplyMessage: (replyMessageRemoteId) {
              if (getReplyMessage == null) {
                return null;
              }
              return getReplyMessage!(replyMessageRemoteId);
            },
            onMessageReplyPressed: (replyMessageLocalId) {
              AppPrint.printInfo("onMessageReplyPressed");
              if (onMessageReplyPressed == null) {
                return;
              }
              onMessageReplyPressed!(replyMessageLocalId);
            },
          ),
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  bool get isMine => message.message.senderId == SharedPref.currentUserId;

  // final ConversationScreenController _screenController = Get.find();
  final MessageAndMultimediaModel message;
  final bool isReady;
  final MessageAndMultimediaModel? Function(int replyMessageRemoteId)?
      getReplyMessage;
  final void Function(int replyMessageLocalId)? onMessageReplyPressed;
  final String replyMessageUserName;
  // final LocalConversation conversation;
  const MessageWidget({
    super.key,
    required this.message,
    this.isReady = false,
    this.getReplyMessage,
    this.onMessageReplyPressed,
    required this.replyMessageUserName,
    // required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    MessageAndMultimediaModel? replyMessage =
        message.message.replyTo != null && getReplyMessage != null
            ? getReplyMessage!(message.message.replyTo!)
            : null;
    return Column(
      crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (replyMessage != null) _buildReplyMessage(replyMessage),
        if (message.multimedia == null &&
            message.message.body != null &&
            message.message.body?.trim() != "" &&
            AppUtil.hasURLInText(message.message.body!))
          LinksPreviewWidget(isMine: isMine, message: message),
        isReady ? getReadyMessage() : getMessage(),
        if (message.multimedia != null &&
            message.message.body != null &&
            message.message.body?.trim() != "")
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
    );
  }

  Widget _buildReplyMessage(MessageAndMultimediaModel replyMessage) {
    return InkWell(
      onTap: () {
        if (onMessageReplyPressed != null) {
          onMessageReplyPressed!(replyMessage.message.localId);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: ReplyMessageWidget(
          message: replyMessage,
          isMine: isMine,
          userName: replyMessageUserName,
        ),
      ),
    );
  }

  Widget getMessage() {
    if (message.multimedia != null &&
        message.multimedia!.type == MultimediaTypes.image.value.toLowerCase()) {
      return ImageMessageWidget(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
      // ImageMessage
    } else if (message.multimedia != null &&
        message.multimedia!.type == MultimediaTypes.video.value.toLowerCase()) {
      return VideoMessageWidget(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
    } else if (message.multimedia != null &&
        message.multimedia!.type == MultimediaTypes.audio.value.toLowerCase()) {
      return AudioMessageWidget(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
    } else if (message.multimedia != null &&
        (message.multimedia!.type == MultimediaTypes.file.value.toLowerCase() ||
            message.multimedia!.type ==
                MultimediaTypes.archive.value.toLowerCase())) {
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

  Widget getReadyMessage() {
    if (message.multimedia != null &&
        message.multimedia!.type == MultimediaTypes.image.value.toLowerCase()) {
      return ReadyImageMessageWidget(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
      // ImageMessage
    } else if (message.multimedia != null &&
        message.multimedia!.type == MultimediaTypes.video.value.toLowerCase()) {
      return ReadyVideoMessageWidget(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
    } else if (message.multimedia != null &&
        message.multimedia!.type == MultimediaTypes.audio.value.toLowerCase()) {
      return ReadyAudioMessageWidget(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
    } else if (message.multimedia != null &&
        (message.multimedia!.type == MultimediaTypes.file.value.toLowerCase() ||
            message.multimedia!.type ==
                MultimediaTypes.archive.value.toLowerCase())) {
      return ReadyFileMessageWidget(
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
