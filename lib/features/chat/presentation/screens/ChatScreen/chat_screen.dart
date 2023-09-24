import 'package:ashghal_app_frontend/features/chat/presentation/getx/Chat/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/Chat/chat_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  final int? conversationId;
  ChatScreen({super.key, this.conversationId});
  final ChatScreenController _chatController = Get.put(ChatScreenController());

  // final RxList<ConversationModel> _conversations =
  //     RxList<ConversationModel>([]);
  // void _fetchUsersConversations() async {
  //   try {
  //     List<ConversationModel> conversations =
  //         await ConversationService.getUserConversations(
  //             "chat/conversations", "9cy39NfHFVDVfAa53TJKDjNqIjFU9eQSgQSVzYAg");
  //     _conversations.assignAll(conversations);
  //     Get.to(() => ChatScreen());
  //   } catch (e) {
  //     print('Error fetching users conversations: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // _fetchUsersConversations();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ashghal Chat"),
        actions: [
          PopupMenuButton<ChatPopupMenuItemsValues>(
            onSelected: _chatController.popupMenuButtonOnSelected,
            itemBuilder: (BuildContext ctx) {
              return [
                const PopupMenuItem(
                  value: ChatPopupMenuItemsValues.settings,
                  child: Text("Settigs"),
                ),
                const PopupMenuItem(
                  value: ChatPopupMenuItemsValues.blockedUsers,
                  child: Text("Blocked Users"),
                ),
                const PopupMenuItem(
                  value: ChatPopupMenuItemsValues.createConversation,
                  child: Text("Create Conversation"),
                ),
              ];
            },
          )
          // IconButton(
          //     onPressed: () async {
          //       await _chatController.startConversationWith(2);
          //     },
          //     icon: const Icon(Icons.add))
        ],
      ),
      body: GetX<ChatController>(
        builder: (controller) {
          return controller.conversations.isEmpty
              ? const Text("No Conversations Yet")
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.conversations.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ConversationWidget(
                      conversationWithMessage: controller.conversations[index],
                    );
                    // Column(
                    //   children: [
                    //     ListTile(
                    //       title: Text(conversation.userName.toString()),
                    //       subtitle: Text(
                    //         lastMessage == null
                    //             ? conversation.updatedAt.toIso8601String()
                    //             : lastMessage.createdAt.toIso8601String(),
                    //       ),
                    //       trailing: MaterialButton(
                    //         onPressed: () async {
                    //           controller.deleteConversation(
                    //             conversation.localId,
                    //           );
                    //         },
                    //         child: const Icon(Icons.delete),
                    //       ),
                    //       leading: CircleAvatar(
                    //         backgroundColor: index % 5 == 0
                    //             ? Colors.blueAccent
                    //             : index % 3 == 0
                    //                 ? Colors.blueGrey
                    //                 : index % 2 == 0
                    //                     ? Colors.lightBlue
                    //                     : Colors.lightGreen,
                    //         radius: 25,
                    //         child: Text(
                    //           conversation.userId
                    //               .toString()
                    //               .substring(0, 1),
                    //           style: const TextStyle(fontSize: 20),
                    //         ),
                    //       ),
                    //       onTap: () {
                    //         // print("Move to conversation");
                    //         try {
                    //           Get.to(() => ConversationScreen(
                    //                 conversation: conversation,
                    //               ));
                    //         } catch (e) {
                    //           print(e);
                    //         }
                    //       },
                    //     ),
                    //     const Divider(color: Colors.black)
                    //   ],
                    // );
                  },
                );
        },
      ),
    );
  }
}
