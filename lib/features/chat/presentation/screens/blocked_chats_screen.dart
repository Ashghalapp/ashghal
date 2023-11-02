import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/blocked_conversations_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/avatar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockedChatsScreen extends StatelessWidget {
  BlockedChatsScreen({super.key});
  final BlockedConversationsScreenController controller =
      Get.put(BlockedConversationsScreenController());
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Get.isPlatformDarkMode ? ChatTheme.dark : ChatTheme.light,
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalization.blockedChats.tr),
            actions: [
              PopupMenuButton<bool>(
                onSelected: controller.unblockAllConversations,
                itemBuilder: (BuildContext ctx) {
                  return [
                    PopupMenuItem(
                      value: true,
                      child: Text(AppLocalization.unblockAll.tr),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: GetX<BlockedConversationsScreenController>(
            builder: (controller) {
              if (controller.blockedConversations.isEmpty) {
                return const Center(
                  child: Text("No blocked chats"),
                );
              }
              return ListView.builder(
                itemCount: controller.blockedConversations.length,
                itemBuilder: (_, index) {
                  LocalConversation current =
                      controller.blockedConversations[index];
                  // return ConversationWidget(
                  //   conversation: controller.blockedConversations[index],
                  // );
                  return _buildBlockedConversation(current, index);
                },
              );
            },
          )
          // Center(
          //   child: Text("No Blocked Chats"),
          // ),
          ),
    );
  }

  Padding _buildBlockedConversation(LocalConversation current, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          UserImageAvatarWithStatusWidget(
            userId: current.userId,
            userName: current.userName,
            raduis: 26,
            boderThickness: 1,
            borderColor: Get.theme.primaryColor,
            // borderColor: Theme.of(context).primaryColor,
            imageUrl: current.userImageUrl,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    current.userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => controller.unblockConversation(index),
            child: const Icon(Icons.lock_open),
          )
        ],
      ),
    );
  }
}
