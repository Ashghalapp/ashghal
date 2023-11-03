import 'dart:async';
import 'dart:io';

import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_with_count_and_last_message.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/starred_messages_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_media_links_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/message_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../screens/profile_chat_screen.dart';
// Import the custom FuzzyMatch class.

enum ConversationPopupMenuItemsValues {
  search,
  media,
  goToFirstMessage,
  clearChat,
  block,
  unblock,
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
      case ConversationPopupMenuItemsValues.unblock:
        return AppLocalization.unblock;
    }
  }
}

class ConversationScreenController extends GetxController {
  // final int conversationId;

  final LocalConversation currentConversation;
  final LocalMessage? targetMessage;
  ConversationScreenController({
    required this.currentConversation,
    this.targetMessage,
  }) : conversationController = Get.put(
          ConversationController(
            currentConversation: currentConversation,
          ),
        );

  Rx<MessageAndMultimediaModel?> replyMessage =
      Rx<MessageAndMultimediaModel?>(null);

  RxBool isReplyMessagePresent = false.obs;

  RxBool isLoading = false.obs;
  int get conversationId => currentConversation.localId;

  final ConversationController conversationController; //= Get.find();

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

  /// A list to track over selected messages ids,
  RxList<int> selectedMessagesIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();

    scrollListener.itemPositions.addListener(
      () {
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
        if (indexes.isNotEmpty && indexes[0] > 2) {
          showScrollDownIcon.value = true;
          // print("Ok");
        } else {
          showScrollDownIcon.value = false;
        }
      },
    );
    if (targetMessage != null) {
      Future.delayed(
        const Duration(seconds: 1),
        () async {
          scrollToMessageWithLocalIdAndHighLightItForAWhile(
              targetMessage!.localId, 4);
          // int index = conversationController.messages.indexWhere(
          //     (element) => element.message.localId == targetMessage!.localId);
          // if (index != -1) {
          //   searchSelectedMessage.value = index;
          //   scrollToPosition(index, 0.5);
          //   // after 4 seconds disable selecting the message
          //   Future.delayed(
          //     const Duration(seconds: 4),
          //     () {
          //       searchSelectedMessage.value = -1;
          //     },
          //   );
          // }
          // for (int i = 0; i < conversationController.messages.length; i++) {
          //   if (conversationController.messages[i].message.localId ==
          //       message!.localId) {
          //     // matchedMsgIndixes.add(i);

          //   }
          // }
        },
      );
    }
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
      toggleSearchingMode();
    } else if (value == ConversationPopupMenuItemsValues.media) {
      goToConversationMediaScreen();
    } else if (value == ConversationPopupMenuItemsValues.goToFirstMessage) {
      scrollToFirstOrBottom(false);
    } else if (value == ConversationPopupMenuItemsValues.clearChat) {
      // conversationController.clearChat();
      clearChat();
      //  _chatScreenController
    } else if (value == ConversationPopupMenuItemsValues.block) {
      conversationController.blockConversation();
    } else if (value == ConversationPopupMenuItemsValues.unblock) {
      conversationController.unblockConversation();
    }
  }

  void goToChatProfileScreen() {
    Get.to(
      () => ProfileChatScreen(
        conversation: currentConversation,
      ),
    );
  }

  void closeThisConversationScreen() {
    conversationController.markConversationMessagesAsRead();
    Get.back();
  }

  Future<bool> backButtonPressed() {
    InsertingMessageController insertingController = Get.find();
    if (insertingController.emojiPickerShowing.value) {
      insertingController.emojiPickerShowing.value = false;
      return Future.value(false);
    } else if (selectionEnabled.value || isSearching.value) {
      resetToNormalMode();
      return Future.value(false);
    } else {
      closeThisConversationScreen();
      return Future.value(true);
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

  Future<void> clearChat() async {
    await conversationController.clearChat();
    ChatController chatController = Get.find();
    // AppPrint.printInfo("Clear chat started");
    chatController.deleteConversationsLastMessageAndCount(conversationId);
  }

  void goToConversationMediaScreen() {
    Get.to(() => ChatMediaLinksDocsScreen());
  }

  void viewMessageInfo() {
    if (selectedMessagesIds.length == 1) {
      Get.to(
        () => MessageInfoPage(
          message: conversationController.messages[selectedMessagesIds[0]],
        ),
      );
    }
  }

  void setReplyMessage(int messageRemoteId) {
    AppPrint.printInfo("Message $messageRemoteId Swiped");
    // AppPrint.printInfo("Message ${message.message.toString()} Swiped");
    // AppPrint.printInfo("Message ${message.multimedia.toString()} Swiped");
    replyMessage.value = getMessageWithRemoteId(messageRemoteId);
    AppPrint.printInfo(
        "Message ${replyMessage.value!.message.toString()} Swiped");
    AppPrint.printInfo(
        "Message ${replyMessage.value!.multimedia.toString()} Swiped");
  }

  void cancelReplyMessage() {
    replyMessage.value = null;
  }

  void scrollToMessageReplyWithId(int messagelocalId) {
    scrollToMessageWithLocalIdAndHighLightItForAWhile(messagelocalId, 2);
    // int index = conversationController.messages
    //     .indexWhere((element) => element.message.localId == messagelocalId);
    // AppPrint.printInfo("scroll to index $index");
    // if (index != -1) {
    //   scrollToPosition(index, 0.5);
    // }
  }

  MessageAndMultimediaModel? getMessageWithRemoteId(int messageRemoteId) {
    // MessageAndMultimediaModel? message =
    return conversationController.messages.firstWhereOrNull(
        (element) => element.message.remoteId == messageRemoteId);
    // AppPrint.printData("$messageRemoteId reply Message ${message.toString()}");
    // return message;
  }

  Future<void> sendTextMessage(String body, [int? otherConversationId]) async {
    // AppPrint.printData("Reply Message ${replyMessage!.message}");
    SendMessageRequest request = SendMessageRequest.withBody(
      conversationId: otherConversationId ?? conversationId,
      replyTo: replyMessage.value == null
          ? null
          : replyMessage.value!.message.remoteId,
      body: body,
    );
    // AppPrint.printData(request.toString());
    cancelReplyMessage();
    await conversationController.sendMessage(request);
  }

  Future<void> sendMultimediaMessage(String path,
      [int? otherConversationId]) async {
    SendMessageRequest request = SendMessageRequest.withMultimedia(
      conversationId: otherConversationId ?? conversationId,
      replyTo: replyMessage.value == null
          ? null
          : replyMessage.value!.message.remoteId,
      filePath: path,
      onSendProgress: (count, total) {},
      cancelToken: null,
    );
    cancelReplyMessage();
    await conversationController.sendMessage(request);
  }

  Future<void> sendTextAndMultimediaMessage(String body, String path,
      [int? otherConversationId]) async {
    SendMessageRequest request = SendMessageRequest.withBodyAndMultimedia(
      conversationId: otherConversationId ?? conversationId,
      replyTo: replyMessage.value == null
          ? null
          : replyMessage.value!.message.remoteId,
      filePath: path,
      body: body,
      onSendProgress: (count, total) {},
      cancelToken: null,
    );
    cancelReplyMessage();
    await conversationController.sendMessage(request);
  }

  //============================ Start selection functions ============================//

  LocalMessage? get firstSelectedMessage {
    if (selectedMessagesIds.isEmpty) {
      return null;
    }
    return conversationController.messages
        .firstWhereOrNull(
            (element) => element.message.localId == selectedMessagesIds[0])
        ?.message;
  }

  void toggleSelectionMode() {
    selectionEnabled.value = !selectionEnabled.value;
    if (!selectionEnabled.value) {
      // selectedMessagesIds.clear();
      resetToNormalMode();
    }
  }

  void selectMessage(int messageId) {
    AppPrint.printInfo("Selected message $messageId");
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
      if (selectedMessagesIds.isEmpty) {
        resetToNormalMode();
      }
    }
  }

  Future<void> toggleStarSelectedMessage() async {
    if (selectedMessagesIds.isNotEmpty) {
      // selectionEnabled.value = false;
      selectionEnabled.value = false;
      await conversationController.toggleStarMessage(selectedMessagesIds[0]);
      selectedMessagesIds.clear();
      // if we come from starred messages screen we should refresh the starred messages
      try {
        StarredMessagesScreenController controller = Get.find();
        controller.refreshStarredMessages();
      } catch (e) {}
    }
  }

  Future<void> forwardSelectedMessage() async {
    if (ableToForwardSelectedMessage.value && forwardedMessage != null) {
      Get.to(() => ChatScreen());
      ChatScreenController chatScreenController = Get.find();
      chatScreenController.forwardMessage((selectedconversationsIds) async {
        print("Number of selected conversations $selectedconversationsIds");

        if (forwardedMessage!.message.body != null &&
            forwardedMessage!.multimedia != null) {
          for (int id in selectedconversationsIds) {
            sendTextAndMultimediaMessage(forwardedMessage!.message.body!,
                forwardedMessage!.multimedia!.path!, id);
          }
        } else if (forwardedMessage!.message.body != null &&
            forwardedMessage!.multimedia == null) {
          for (int id in selectedconversationsIds) {
            sendTextMessage(forwardedMessage!.message.body!, id);
          }
        } else if (forwardedMessage!.message.body == null &&
            forwardedMessage!.multimedia != null) {
          for (int id in selectedconversationsIds) {
            sendMultimediaMessage(forwardedMessage!.multimedia!.path!, id);
          }
        } else {
          return;
        }
      });
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

  void scrollToPosition(int targetIndex, [double alignment = 0]) {
    // messagesScrollController.animateTo(
    //   messagesScrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
    messagesScrollController.scrollTo(
      index: targetIndex,
      alignment: alignment,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
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

  void scrollToMessageWithLocalIdAndHighLightItForAWhile(int messageLocalId,
      [int durationInSeconds = 4, double alignment = 0.5]) {
    int index = conversationController.messages
        .indexWhere((element) => element.message.localId == messageLocalId);
    if (index != -1) {
      searchSelectedMessage.value = index;
      scrollToPosition(index, alignment);
      Future.delayed(
        Duration(seconds: durationInSeconds),
        () {
          searchSelectedMessage.value = -1;
        },
      );
    }
  }
//============================ End Scrolling functions ============================//
}
