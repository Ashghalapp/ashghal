import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_with_count_and_last_message.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/avatar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationWidget extends StatefulWidget {
  final ConversationWithCountAndLastMessage conversation;

  const ConversationWidget({super.key, required this.conversation});

  @override
  State<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  final ChatScreenController _controller = Get.find();

  late Stream<void> _minuteStream;
  // late Stream<DateTime> MinuteStream;
  // late Stream<DateTime> _lastSeenMinuteStream;
  // late String _lastMessageDate;
  String? _lastSeen;

  String getLastMessageStringDate() {
    return AppUtil.formatDateTime(widget.conversation.lastMessage?.createdAt ??
        widget.conversation.conversation.updatedAt);
  }

  String? getLastSeenString() {
    if (widget.conversation.lastSeen != null) {
      return AppUtil.timeAgoSince(widget.conversation.lastSeen!);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // _lastMessageDate = getLastMessageStringDate();
    if (_lastSeen != null) {
      _lastSeen = getLastSeenString();
      _minuteStream = Stream<void>.periodic(const Duration(minutes: 1), (_) {
        setState(() {
          // _lastMessageDate = getLastMessageStringDate();
          _lastSeen = getLastSeenString();
        });
      });
    }
  }

  bool get lastMessageMine => widget.conversation.lastMessage == null
      ? false
      : widget.conversation.lastMessage!.senderId == SharedPref.currentUserId;

  @override
  Widget build(BuildContext context) {
    return _buildDismissibleWidget(
      child: InkWell(
        onTap: () => _controller
            .goToConversationScreen(widget.conversation.conversation),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            children: [
              _buildImageAvatar(context),
              // const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.conversation.conversation.userName,
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 7),
                      Opacity(
                        opacity: 0.6,
                        child: buildLastMessageRow(),
                      ),
                    ],
                  ),
                ),
              ),
              _buildTimeAgoAndNumberOfNewMessages()
            ],
          ),
        ),
      ),
    );
  }

  Stack _buildImageAvatar(BuildContext context) {
    return Stack(
      children: [
        // User Image
        InkWell(
          onTap: () {
            //TODO: Open the user image in a full screen
          },
          child: AvatarWithImageOrLetter(
            userName: widget.conversation.conversation.userName,
            imageUrl: widget.conversation.conversation.userImageUrl,
            raduis: 25,
            borderColor: Theme.of(context).primaryColor,
          ),
        ),
        //online icon
        if (widget.conversation.isActive)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                // color: Colors.green,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          )
      ],
    );
  }

  Row buildLastMessageRow() {
    return Row(
      children: [
        // lastMessageMine
        //     ?
        //     : const SizedBox(width: 2),
        // const SizedBox(width: 7),
        if (lastMessageMine)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: MessageStatusIcon(message: widget.conversation.lastMessage!),
          ),
        Expanded(
          flex: 1,
          child: widget.conversation.lastMessage!.body == null
              ? const Icon(Icons.image)
              : Text(
                  widget.conversation.lastMessage!.body!,
                  // maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ],
    );
  }

  Column _buildTimeAgoAndNumberOfNewMessages() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_lastSeen == null)
          Text(
            getLastMessageStringDate(),
            style: const TextStyle(),
          ),
        if (_lastSeen != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              _lastSeen!,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        const SizedBox(height: 7),
        if (widget.conversation.newMessagesCount > 0)
          CircleAvatar(
            radius: 13,
            backgroundColor: Colors.green,
            child: Text(
              widget.conversation.newMessagesCount.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
      ],
    );
  }

  _buildDismissibleWidget({required Widget child}) {
    return Dismissible(
      key: Key(widget.conversation.conversation.localId
          .toString()), //?? DateTime.now().microsecondsSinceEpoch.toString()),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          // Widget dismissed from right to left
          //to prevent the widget from beeing deleted from the tree until it is updated
          //I will fire the updating action here and return false so the dissmisssble widget will not delete the wiget
          return AppUtil.showConfirmationDialog(
              'Are you sure you want to archive this chat?');
          //   .then((value) {
          // if (value != null && value) {

          // }
          // });

          // return Future.value(false);
        } else if (direction == DismissDirection.startToEnd) {
          // Widget dismissed from left to right
          return AppUtil.showConfirmationDialog(
              'Are you sure you want to delete this chat?');
        }
        return Future.value(false);
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          // Widget dismissed from right to left
          // TODO: Archive chat
        } else if (direction == DismissDirection.startToEnd) {
          // Widget dismissed from left to right
          _controller
              .deleteConversation(widget.conversation.conversation.localId);
        }
      },
      //left to right container
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.delete, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                'Delete'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
      //right to left container
      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Archive'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.archive, color: Colors.white),
            ],
          ),
        ),
      ),
      child: child,
    );
  }

  @override
  void dispose() {
    // Cancel the stream subscription when the widget is disposed.
    // _minuteStream.drain();
    super.dispose();
  }
}
