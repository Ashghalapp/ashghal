import 'package:ashghal_app_frontend/features/chat/presentation/getx/Chat/conversation_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar selectionAppBar() {
  ConversationScreenController screenController = Get.find();

  return AppBar(
    centerTitle: true,
    leading: IconButton(
        onPressed: () {
          screenController.selectedMessagesIds.clear();
          screenController.selectionEnabled.value = false;
          // toggleAppBar();
        },
        icon: const Icon(Icons.close)),
    title: Text(
      screenController.selectedMessagesIds.isNotEmpty
          ? "${screenController.selectedMessagesIds.length} item selected"
          : "No item selected",
      style: const TextStyle(fontSize: 15),
    ),
    actions: [
      Visibility(
        visible: screenController.selectedMessagesIds.length == 1,
        child: IconButton(
          icon: const Icon(Icons.copy_outlined),
          onPressed: () {
            screenController.copyToClipboard();
          },
        ),
      ),
      Visibility(
        visible: screenController.selectedMessagesIds.isNotEmpty,
        child: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            screenController.deleteSelectedMessages();
          },
        ),
      ),
      Visibility(
        visible: screenController.selectedMessagesIds.length == 1,
        child: IconButton(
          icon: const Icon(Icons.info_outlined),
          onPressed: () {
            screenController.viewMessageInfo();
          },
        ),
      ),
      IconButton(
        icon: Obx(() => Icon(
              Icons.select_all,
              color: screenController.selectedMessagesIds.length ==
                      screenController.conversationController.messages.length
                  ? Colors.red
                  : Colors.white,
            )),
        onPressed: () {
          screenController.selectAllMessages();
        },
      ),
    ],
  );
}
