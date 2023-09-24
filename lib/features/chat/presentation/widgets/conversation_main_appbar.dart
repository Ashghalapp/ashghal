import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/Chat/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/search_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'avatar2.dart';

AppBar normalAppBar(
  ConversationScreenController screenController,
  LocalConversation conversation,
) {
  return AppBar(
    leadingWidth: 70,
    leading: InkWell(
      onTap: () {
        Get.back();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.arrow_back,
            size: 18,
          ),
          AvatarWithImageOrLetter(
            imageUrl: conversation.userImageUrl,
            userName: conversation.userName,
            raduis: 22,
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
          const SizedBox(height: 5),
          const Text(
            "Last Seen since 2014/12/4",
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
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
