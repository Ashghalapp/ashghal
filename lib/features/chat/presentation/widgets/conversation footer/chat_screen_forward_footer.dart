import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreenForwardModeFooter extends StatelessWidget {
  ChatScreenForwardModeFooter({
    super.key,
  });

  final ChatScreenController _screenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Card(
        color: Get.isPlatformDarkMode
            ? ChatColors.appBarDark
            : ChatColors.appBarLight,
        margin: const EdgeInsets.all(0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(
                  () => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        _screenController.selectedConversationsIds.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: _buildSelectedConversationChip(
                          _screenController.selectedConversationsIds[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                _screenController.forwardMessageToSelectedConversations();
              },
              icon: Icon(
                Icons.send,
                color: Get.theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedConversationChip(int conversationId) {
    return Chip(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),

      onDeleted: () {
        AppPrint.printInfo("Chip select$conversationId");
        _screenController.selectConversation(conversationId);
      },
      deleteIcon: const Icon(Icons.cancel),
      // avatar: const Icon(Icons.cancel),
      label: Text(
        _screenController.getConversationUserName(
          conversationId,
        ),
      ),
    );
  }
}
