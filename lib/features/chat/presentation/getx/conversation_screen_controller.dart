import 'dart:async';
import 'dart:io';

import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_with_count_and_last_message.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/message_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// Import the custom FuzzyMatch class.

enum ConversationPopupMenuItemsValues {
  search,
  media,
  goToFirstMessage,
  clearChat,
  block
}

extension ConversationPopupMenuItemsValuesExtension
    on ConversationPopupMenuItemsValues {
  String get value {
    switch (this) {
      case ConversationPopupMenuItemsValues.search:
        return AppLocalization.search;
      case ConversationPopupMenuItemsValues.media:
        return AppLocalization.media;
      case ConversationPopupMenuItemsValues.goToFirstMessage:
        return AppLocalization.goToFirstMessage;
      case ConversationPopupMenuItemsValues.clearChat:
        return AppLocalization.clearChat;
      case ConversationPopupMenuItemsValues.block:
        return AppLocalization.block;
    }
  }
}

class ConversationScreenController extends GetxController {
  // final int conversationId;

  late final LocalConversation conversation;
  ConversationScreenController({required this.conversation})
      : conversationController = Get.put(
          ConversationController(
            conversationId: conversation.localId,
          ),
        );

  int get conversationId => conversation.localId;

  final ConversationController conversationController;

  /// A controller to handle messages scroling messages in the screen
  final ItemScrollController messagesScrollController = ItemScrollController();
  final ItemPositionsListener scrollListener = ItemPositionsListener.create();

  /// A controller for the search text field
  final TextEditingController searchFeildController = TextEditingController();

  /// A focusnode for the search text field
  final FocusNode searchFeildFocusNode = FocusNode();

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

  RxBool ableToForwardSelectedMessage = false.obs;

  MessageAndMultimediaModel? forwardedMessage;

  RxBool showScrollDownIcon = false.obs;

  /// A list to track over selected messages,
  RxList<int> selectedMessagesIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    scrollListener.itemPositions.addListener(() {
      // print("Listener started");
      List<int> indexes = scrollListener.itemPositions.value
          // .where((element) {
          //   //itemLeadingEdge: determinates the distance between the top of the list view
          //   //and the top of the item, it is between(0-1)
          //   final isTopVisible = element.itemLeadingEdge >= 0;
          //   //itemTrailingEdge: determinates the distance between the end of the list view
          //   //and the bottom of the item, it is between(0-1)
          //   final isBottomVisible = element.itemTrailingEdge <= 1;
          //   return isTopVisible && isBottomVisible;
          // })
          .map((e) => e.index)
          .toList();
      // print(indexes);
      if (indexes.isNotEmpty && indexes[indexes.length - 1] > 4) {
        showScrollDownIcon.value = true;
        // print("Ok");
      } else {
        showScrollDownIcon.value = false;
      }
    });
    // messagesScrollController.s

    // messagesScrollController.addListener(() {
    //   //offset: tells you how much(the total pixels) you scroll down from the top, its initial value is 0
    //   //maxExtent: tells you how much hidden items in the top
    //   if (messagesScrollController.position.atEdge) {
    //     final isTop = messagesScrollController.position.pixels == 0;
    //   }
    // });
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
    ableToForwardSelectedMessage.value = false;
    forwardedMessage = null;
  }

  void goToConversationMediaScreen() {}

  void viewMessageInfo() {
    if (selectedMessagesIds.length == 1) {
      // LocalMessage msg =
      //     conversationController.messages[selectedMessagesIds[0]].message;
      Get.to(
        () => MessageInfoPage(
          message: conversationController.messages[selectedMessagesIds[0]],
        ),
      );
    }
  }

  //============================ Start selection functions ============================//
  void toggleSelectionMode() {
    selectionEnabled.value = !selectionEnabled.value;
    if (!selectionEnabled.value) {
      // selectedMessagesIds.clear();
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
      // if there is only one message check if its ok to enable forwarding the message
      if (selectedMessagesIds.length == 1) {
        forwardedMessage = conversationController.messages.firstWhereOrNull(
            (element) => element.message.localId == selectedMessagesIds[0]);
        if (forwardedMessage != null &&
            forwardedMessage!.message.body != null &&
            ((forwardedMessage!.multimedia != null &&
                    forwardedMessage!.multimedia!.path != null) ||
                forwardedMessage!.multimedia == null)) {
          ableToForwardSelectedMessage.value = true;
        } else {
          ableToForwardSelectedMessage.value = false;
        }
      } else {
        ableToForwardSelectedMessage.value = false;
      }
    }
  }

  Future<void> forwardSelectedMessage() async {
    if (ableToForwardSelectedMessage.value && forwardedMessage != null) {
      ChatScreenController controller = Get.find();
      controller.forwardMessage((selectedconversationsIds) async {
        print(selectedconversationsIds);
        Get.back();
        if (selectedconversationsIds.length > 1) {
          Get.back();
        }

        // if (forwardedMessage!.message.body != null &&
        //     forwardedMessage!.multimedia != null) {
        //   for (int id in selectedconversationsIds) {
        //     conversationController.sendTextAndMultimediaMessage(
        //         forwardedMessage!.message.body!,
        //         forwardedMessage!.multimedia!.path!,
        //         id);
        //   }
        // } else if (forwardedMessage!.message.body != null &&
        //     forwardedMessage!.multimedia == null) {
        //   for (int id in selectedconversationsIds) {
        //     conversationController.sendTextMessage(
        //         forwardedMessage!.message.body!, id);
        //   }
        // } else if (forwardedMessage!.message.body == null &&
        //     forwardedMessage!.multimedia != null) {
        //   for (int id in selectedconversationsIds) {
        //     conversationController.sendMultimediaMessage(
        //         forwardedMessage!.multimedia!.path!, id);
        //   }
        // } else {
        //   return;
        // }
      });
      Get.to(() => ChatScreen());
    }
  }

  void deleteSelectedMessages() {
    //deleteMessageOrMessages(messagesIds, conversationId);
    conversationController.deleteMessages(selectedMessagesIds.toList());
    resetToNormalMode();
  }

  void copyToClipboard() {
    if (selectedMessagesIds.isNotEmpty) {
      MessageAndMultimedia msg = conversationController.messages.firstWhere(
          (element) => element.message.localId == selectedMessagesIds[0]);
      Clipboard.setData(ClipboardData(text: "${msg.message.body}"));
    }
    resetToNormalMode();
  }

  void selectAllMessages() {
    if (selectedMessagesIds.length == conversationController.messages.length) {
      selectedMessagesIds.clear();
    } else {
      selectedMessagesIds.clear();
      selectedMessagesIds.addAll(conversationController.messages
          .map((element) => element.message.localId));
    }
  }

  //============================ end selection functions ============================//

  //============================ Start Searching functions ============================//
  void toggleSearchingMode() {
    print("toggleSearchingMode");
    print(isSearching.value);
    isSearching.value = !isSearching.value;
    if (isSearching.value) {
      searchFeildFocusNode.requestFocus();
    } else {
      resetToNormalMode();
    }
  }

  void onSearchTextFieldChanged(String text) {
    matchedMsgIndixes.clear();
    if (text.trim().isNotEmpty) {
      for (int i = 0; i < conversationController.messages.length; i++) {
        if (conversationController.messages[i].message.body != null &&
            conversationController.messages[i].message.body!.contains(text)) {
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
      } else {
        mathedCurrentIndex.value = -1;
        searchSelectedMessage.value = -1;
      }
    } else {
      mathedCurrentIndex.value = -1;
      searchSelectedMessage.value = -1;
      scrollToPosition(0);
    }
  }

  //============================ End Searching functions ============================//

  //============================ Start Scrolling functions ============================//
  // void scrollToBottom() {
  //   messagesScrollController.animateTo(
  //     messagesScrollController.position.maxScrollExtent,
  //     duration: const Duration(milliseconds: 500),
  //     curve: Curves.easeInOut,
  //   );
  //   // messagesScrollController.
  // }

  // void scrollToUp() {
  //   messagesScrollController.animateTo(
  //     // messagesScrollController.position.minScrollExtent,
  //     0,
  //     duration: const Duration(milliseconds: 500),
  //     curve: Curves.easeInOut,
  //   );
  // }

  void scrollToPosition(int targetIndex) {
    // messagesScrollController.animateTo(
    //   messagesScrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
    messagesScrollController.scrollTo(
      index: targetIndex,
      // alignment: 0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
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
