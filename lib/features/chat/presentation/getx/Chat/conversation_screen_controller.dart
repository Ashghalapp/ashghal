import 'dart:io';

import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/Chat/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/ChatScreen/message_info_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// Import the custom FuzzyMatch class.

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

enum ConversationPopupMenuItemsValues {
  search,
  media,
  goToFirstMessage,
  clearChat,
  block
}

class ConversationScreenController extends GetxController {
  final int conversationId;

  ConversationScreenController({required this.conversationId})
      : conversationController =
            Get.put(ConversationController(conversationId: conversationId));

  final ConversationController conversationController;

  /// A controller to handle messages scroling messages in the screen
  final ItemScrollController messagesScrollController = ItemScrollController();

  /// A controller for the search text field
  final TextEditingController searchFeildController = TextEditingController();

  /// indicates if messages selection enabled or not
  RxBool selectionEnabled = false.obs;

  /// A list contians the ids of the messages that has a match with the search Text
  RxList<int> matchedMsgIndixes = <int>[].obs;

  /// The index of the message we are in when searching messages
  RxInt searchSelectedMessage = (-1).obs;

  /// the index of the [searchSelectedMessage] in the [matchedMsgIndixes] list
  RxInt mathedCurrentIndex = (-1).obs;

  /// indicates if the user is searching
  RxBool isSearching = false.obs;

  /// A list to track over selected messages,
  RxList<int> selectedMessagesIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    searchFeildController.dispose();
    Get.delete<ConversationController>();
    super.onClose();
  }

  // final RxList<LocalMessage> filteredMessages = <LocalMessage>[].obs;

  // void updateFilteredMessages(List<LocalMessage> newFilteredMessages) {
  //   conversationController.messages.assignAll(newFilteredMessages);
  // }

  // Future<void> clearChat(int conversationId) async {
  //   conversationController.clearChat(conversationId);
  // }

  popupMenuButtonOnSelected(ConversationPopupMenuItemsValues value) {
    if (value == ConversationPopupMenuItemsValues.search) {
    } else if (value == ConversationPopupMenuItemsValues.media) {
      goToConversationMediaScreen();
    } else if (value == ConversationPopupMenuItemsValues.goToFirstMessage) {
      scrollToFirstOrBottom(false);
    } else if (value == ConversationPopupMenuItemsValues.clearChat) {
      conversationController.clearChat();
    } else if (value == ConversationPopupMenuItemsValues.block) {
      conversationController.blockConversation();
    }
  }

  void resetToNormalMode() {
    selectedMessagesIds.clear();
    selectionEnabled.value = false;
    matchedMsgIndixes.clear();
    isSearching.value = false;
    searchSelectedMessage.value = -1;
    mathedCurrentIndex.value = -1;
  }

  void goToConversationMediaScreen() {}

  void viewMessageInfo() {
    if (selectedMessagesIds.length == 1) {
      LocalMessage msg =
          conversationController.messages[selectedMessagesIds[0]];
      Get.to(() => MessageInfoPage(message: msg));
    }
  }

  //============================ Start selection functions ============================//
  void toggleSelectionMode() {
    selectionEnabled.value = !selectionEnabled.value;
    if (!selectionEnabled.value) {
      resetToNormalMode();
    }
  }

  void selectMessage(int messageId) {
    if (selectionEnabled.value) {
      if (selectedMessagesIds.contains(messageId)) {
        selectedMessagesIds.remove(messageId);
      } else {
        selectedMessagesIds.add(messageId);
      }
    }
  }

  void deleteSelectedMessages() {
    //deleteMessageOrMessages(messagesIds, conversationId);
    conversationController.deleteMessages(selectedMessagesIds.value.toList());
    resetToNormalMode();
  }

  void copyToClipboard() {
    if (selectedMessagesIds.isNotEmpty) {
      LocalMessage msg = conversationController.messages
          .firstWhere((element) => element.localId == selectedMessagesIds[0]);
      Clipboard.setData(ClipboardData(text: "${msg.body}"));
    }
    resetToNormalMode();
  }

  void selectAllMessages() {
    if (selectedMessagesIds.length == conversationController.messages.length) {
      selectedMessagesIds.clear();
    } else {
      selectedMessagesIds.clear();
      selectedMessagesIds.addAll(
          conversationController.messages.map((element) => element.localId));
    }
  }

  //============================ end selection functions ============================//

  //============================ Start Searching functions ============================//
  void toggleSearchingMode() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      resetToNormalMode();
    }
  }

  void searchInMessages() {
    if (searchFeildController.text.trim().isNotEmpty) {
      String searchText = searchFeildController.text;
      for (int i = 0; i < conversationController.messages.length; i++) {
        if (conversationController.messages[i].body != null &&
            conversationController.messages[i].body!.contains(searchText)) {
          matchedMsgIndixes.add(i);
        }
      }

      // Create a copy of the list, reverse it, and convert it back to RxList
      //  matchedMsgIndixes = matchedMsgIndixes.toList().reversed.toList().obs;
      if (matchedMsgIndixes.isNotEmpty) {
        mathedCurrentIndex.value = 0;
        scrollToPosition(matchedMsgIndixes[0]);
        searchSelectedMessage.value = matchedMsgIndixes[0];
        // return RxList<int>.from(reversedIndices);
      }
    }
  }

  //============================ End Searching functions ============================//

  //============================ Start Scrolling functions ============================//
  void scrollToPosition(int targetPosition) {
    messagesScrollController.scrollTo(
      index: targetPosition,
      duration: const Duration(microseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  void incrementIndex() {
    if (mathedCurrentIndex < matchedMsgIndixes.length - 1) {
      // Increment the current index if not at the end

      scrollToPosition(matchedMsgIndixes[++mathedCurrentIndex.value]);
      searchSelectedMessage.value = matchedMsgIndixes[mathedCurrentIndex.value];

      print(
          "*******************${matchedMsgIndixes[mathedCurrentIndex.value]}");
    }
  }

  void decrementIndex() {
    if (mathedCurrentIndex > 0) {
      // Decrement the current index if not at the beginning
      scrollToPosition(matchedMsgIndixes[--mathedCurrentIndex.value]);
      searchSelectedMessage.value = matchedMsgIndixes[mathedCurrentIndex.value];
      print("deincrement ${matchedMsgIndixes[mathedCurrentIndex.value]}");
    }
  }

  void scrollToFirstOrBottom(bool toBottom) {
    // the flage value 0 to  Scroll to the bottom and 1 to Scroll to the first
    print("flage is " + toBottom.toString());
    try {
      scrollToPosition(
          toBottom ? 0 : conversationController.messages.length - 1);
      // messagesScrollController.scrollTo(
      //   index:,
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.easeOut,
      // );
    } catch (e) {
      print(e.toString());
    }
  }

//============================ End Scrolling functions ============================//
}
