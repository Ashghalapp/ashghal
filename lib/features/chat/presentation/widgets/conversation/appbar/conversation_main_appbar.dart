import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/search_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../avatar.dart';

AppBar normalAppBar(
  ConversationScreenController screenController,
  LocalConversation conversation,
) {
  return AppBar(
    backgroundColor: Colors.blue,
    elevation: 2,
    leadingWidth: 75,
    leading: InkWell(
      onTap: () {
        Get.back();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.arrow_back,
            size: 20,
          ),
          AvatarWithImageOrLetter(
            imageUrl: conversation.userImageUrl,
            userName: conversation.userName,
            raduis: 25,
          ),
        ],
      ),
    ),
    title: Padding(
      padding: const EdgeInsets.only(right: 5, left: 0, bottom: 5, top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conversation.userName,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              // color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Last Seen since 2014/12/4",
            style: TextStyle(
              fontSize: 13,
              // color: Colors.white,
            ),
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(
          Icons.search,
          // color: Colors.white,
        ),
        onPressed: screenController.toggleSearchingMode,
      ),
      buildAppbarDropDownMenuOptions(screenController)
    ],
  );
}

PopupMenuButton<ConversationPopupMenuItemsValues>
    buildAppbarDropDownMenuOptions(
        ConversationScreenController screenController) {
  return PopupMenuButton<ConversationPopupMenuItemsValues>(
    onSelected: screenController.popupMenuButtonOnSelected,
    itemBuilder: (BuildContext ctx) {
      return [
        const PopupMenuItem(
          value: ConversationPopupMenuItemsValues.search,
          child: Text("Search"),
        ),
        const PopupMenuItem(
          value: ConversationPopupMenuItemsValues.media,
          child: Text("Media"),
        ),
        const PopupMenuItem(
          value: ConversationPopupMenuItemsValues.goToFirstMessage,
          child: Text("Go To First Message"),
        ),
        const PopupMenuItem(
          value: ConversationPopupMenuItemsValues.clearChat,
          child: Text("Clear Chat"),
        ),
        const PopupMenuItem(
          value: ConversationPopupMenuItemsValues.block,
          child: Text("Block"),
        ),
      ];
    },
  );
}

AppBar searchAppbar(ConversationScreenController screenController) {
  return AppBar(
    leadingWidth: 70,
    leading: InkWell(
      onTap: () {
        screenController.isSearching = false.obs;
      },
      child: const Icon(
        Icons.arrow_back,
        size: 18,
      ),
    ),
    title: Row(
      children: [
        Column(
          children: [
            InkWell(
              child: const Icon(Icons.arrow_drop_up),
              onTap: () => screenController.incrementIndex(),
            ),
            InkWell(
              child: const Icon(Icons.arrow_drop_down),
              onTap: () => screenController.decrementIndex(),
            ),
          ],
        ),
        Expanded(
          child: SearchInputField(
            controller: screenController.searchFeildController,
            onSearchPressed: screenController.searchInMessages,
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: screenController.toggleSearchingMode,
      ),
    ],
  );
}

AppBar selectionAppBar() {
  ConversationScreenController screenController = Get.find();

  return AppBar(
    backgroundColor: Colors.blue[400],
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
