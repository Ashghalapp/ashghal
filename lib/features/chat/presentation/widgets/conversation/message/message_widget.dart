import 'package:any_link_preview/any_link_preview.dart';
import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/avatar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/audio_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/file_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/image_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/reply_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/video_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';

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
                borderColor: ChatStyle.ownMessageColor!,
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
    // AppPrint.printData(
    //     replyMessage == null ? 'No Reply' : replyMessage.message.toString());
    return
        // message.multimedia != null &&
        //         message.message.body != null &&
        //         message.message.body?.trim() != ""
        //     ?
        Column(
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
    if (message.multimedia != null && message.multimedia!.type == "image") {
      return ImageMessageWidget(
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
        (message.multimedia!.type == "file" ||
            message.multimedia!.type == "archive")) {
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
    if (message.multimedia != null && message.multimedia!.type == "image") {
      return ReadyImageMessageWidget(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
      // ImageMessage
    } else if (message.multimedia != null &&
        message.multimedia!.type == "video") {
      return ReadyVideoMessageWidget(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
    } else if (message.multimedia != null &&
        message.multimedia!.type == "audio") {
      return ReadyAudioMessageWidget(
        multimedia: message.multimedia!,
        isMine: isMine,
      );
    } else if (message.multimedia != null &&
        (message.multimedia!.type == "file" ||
            message.multimedia!.type == "archive")) {
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

class LinksPreviewWidget extends StatefulWidget {
  const LinksPreviewWidget({
    super.key,
    required this.isMine,
    required this.message,
  });

  final bool isMine;
  final MessageAndMultimediaModel message;

  @override
  State<LinksPreviewWidget> createState() => _LinksPreviewWidgetState();
}

class _LinksPreviewWidgetState extends State<LinksPreviewWidget> {
  PreviewData? previewData;
  String? link;
  @override
  void initState() {
    link = AppUtil.getURLInText(widget.message.message.body!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
      child: Row(
        children: [
          // Container(
          //   decoration: const BoxDecoration(
          //     color: Colors.black,
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(30),
          //       bottomLeft: Radius.circular(30),
          //     ),
          //   ),
          //   width: 7,
          //   height: 155,
          //   // child: Col,
          //   // height: double.maxFinite,
          // ),
          Expanded(
            child: AnyLinkPreview(
              // previewHeight: 170,
              link: link!,
              displayDirection: UIDirection.uiDirectionVertical,
              showMultimedia: true,
              bodyMaxLines: 6,
              bodyTextOverflow: TextOverflow.ellipsis,
              titleStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              bodyStyle: const TextStyle(color: Colors.black, fontSize: 12),
              errorBody: 'Show my custom error body',
              errorTitle: 'Show my custom error title',
              errorWidget: const SizedBox.shrink(),
              // Container(
              //   color: Colors.grey[300],
              //   child: const Text('Oops!'),
              // ),
              // errorImage: "https://google.com/",
              cache: const Duration(days: 7),
              // backgroundColor: Colors.grey[300],
              backgroundColor: widget.isMine
                  ? Colors.black38
                  : Get.isPlatformDarkMode
                      ? Colors.white38
                      : Colors.white60,
              // borderRadius: 15,
              removeElevation: false,
              boxShadow: const [BoxShadow(blurRadius: 1, color: Colors.grey)],
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(link!))) {
                  await launchUrl(Uri.parse(link!));
                } else {
                  AppUtil.buildErrorDialog("Could not launch $link");
                }
              }, // This disables tap event
            ),
          ),
        ],
      ),
    );
    // LinkPreview(
    //   openOnPreviewImageTap: true,
    //   openOnPreviewTitleTap: true,
    //   hideImage: false,
    //   width: double.maxFinite,
    //   previewBuilder: (ctx,data){

    //   },
    //   //  widget.isMine
    //   //     ? MediaQuery.sizeOf(context).width - 120
    //   //     : MediaQuery.sizeOf(context).width - 140,
    //   enableAnimation: true,
    //   onPreviewDataFetched: (data) {
    //     setState(() {
    //       previewData = data;
    //     });
    //   },
    //   onLinkPressed: (link) {},
    //   previewData: previewData,
    //   text: widget.message.message.body!,

    //   // width: MediaQuery.of(context).size.width,
    // );
  }
}
