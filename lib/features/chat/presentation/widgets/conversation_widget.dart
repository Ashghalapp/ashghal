import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_with_count_and_last_message.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/Chat/chat_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/avatar2.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/message_status_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationWidget extends StatelessWidget {
  final ConversationWithCountAndLastMessage conversationWithMessage;
  final ChatScreenController _controller = Get.find();

  ConversationWidget({super.key, required this.conversationWithMessage});

  bool get lastMessageMine => conversationWithMessage.lastMessage == null
      ? false
      : conversationWithMessage.lastMessage!.senderId ==
          SharedPref.currentUserId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            _controller
                .goToConversationScreen(conversationWithMessage.conversation);
          },
          leading: GestureDetector(
            onTap: () {
              //TODO: Open image in full screeen
            },
            child: AvatarWithImageOrLetter(
              userName: conversationWithMessage.conversation.userName,
              imageUrl: conversationWithMessage.conversation.userImageUrl,
              raduis: 30,
            ),
          ),
          title: Text(
            conversationWithMessage.conversation.userName,
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: conversationWithMessage.lastMessage == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      lastMessageMine
                          ? MessageStatusIcon(
                              message: conversationWithMessage.lastMessage!)
                          : const SizedBox(width: 2),
                      const SizedBox(width: 7),
                      Expanded(
                        flex: 1,
                        child: conversationWithMessage.lastMessage!.body == null
                            ? const Icon(Icons.image)
                            : Text(
                                conversationWithMessage.lastMessage!.body!,
                                // maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ],
                  ),
                ),

          /// TODO: show last Seen
          // trailing: const Text("12:50"),
          trailing: IconButton(
              onPressed: () {
                _controller.deleteConversation(
                    conversationWithMessage.conversation.localId);
              },
              icon: Icon(Icons.delete)),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 20, left: 80),
          child: Divider(
            thickness: 1,
          ),
        )
      ],
    );
  }
}
