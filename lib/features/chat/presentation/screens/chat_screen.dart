import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/filled_outline_button.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_screen_controller.dart';
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
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text("Chats"),
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
      body: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: buildFilterButtons(),
          ),
          Expanded(
            child: GetX<ChatController>(
              builder: (controller) {
                return controller.isLoaing.value
                    ? AppUtil.addProgressIndicator(context, 50)
                    : controller.conversations.isEmpty
                        ? const Text("No Conversations Yet")
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.conversations.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ConversationWidget(
                                conversation: controller.conversations[index],
                              );
                            },
                          );
              },
            ),
          ),
        ],
      ),
    );
  }

  ListView buildFilterButtons() {
    return ListView(
      padding: EdgeInsets.only(left: 10, right: 0, bottom: 7, top: 2),
      scrollDirection: Axis.horizontal,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FillOutlineButton(
                isFilled: true,
                text: "All",
                onPress: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FillOutlineButton(
                isFilled: false,
                text: "Recent Messages",
                onPress: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FillOutlineButton(
                isFilled: false,
                text: "Active",
                onPress: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FillOutlineButton(
                isFilled: false,
                text: "favorite",
                onPress: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
