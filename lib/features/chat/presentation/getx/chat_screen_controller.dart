import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/participant_model.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/matched_conversation_and_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/conversation_messages_read.dart';

import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/auto_reply_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/blocked_chats_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_settings_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/conversation_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/full_image_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/profile_chat_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/starred_messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ChatPopupMenuItemsValues {
  autoReply, //الرد التلقائي
  starredMessages, //الرسائل المميزة بنجمة
  blockedChats,
  settings,
  search,
  viewProfile, //فتح الملف الشخصي
  markMessagesAsRead, //تمييز كمقروءة
  selectAll,
  unselectAll,
  blockChat,
}

extension ChatPopupMenuItemsValuesExtension on ChatPopupMenuItemsValues {
  String get value {
    switch (this) {
      case ChatPopupMenuItemsValues.autoReply:
        return AppLocalization.autoReply;
      case ChatPopupMenuItemsValues.starredMessages:
        return AppLocalization.starredMessages;
      case ChatPopupMenuItemsValues.blockedChats:
        return AppLocalization.blockedChats;
      case ChatPopupMenuItemsValues.settings:
        return AppLocalization.settings;
      case ChatPopupMenuItemsValues.search:
        return AppLocalization.search;
      case ChatPopupMenuItemsValues.viewProfile:
        return AppLocalization.viewProfile;
      case ChatPopupMenuItemsValues.markMessagesAsRead:
        return AppLocalization.markMessagesAsRead;
      case ChatPopupMenuItemsValues.selectAll:
        return AppLocalization.selectAll;
      case ChatPopupMenuItemsValues.unselectAll:
        return AppLocalization.unselectAll;
      case ChatPopupMenuItemsValues.blockChat:
        return AppLocalization.blockChat;
    }
  }
}

class ChatScreenController extends GetxController {
  final ChatController chatController = Get.find();
  FocusNode searchFeildFocusNode = FocusNode();
  RxBool isLoading = false.obs;
  final ParticipantModel? user;

  ChatScreenController({this.user});
  @override
  void onInit() {
    super.onInit();
    if (user != null) {
      openConversationWithUser();
    }
  }

  Future<void> openConversationWithUser() async {
    isLoading.value = true;
    LocalConversation? conversation =
        await chatController.startConversationWith(user!);
    isLoading.value = false;
    if (conversation != null) {
      goToConversationScreen(conversation);
    }
    //  else {
    //   AppUtil.buildErrorDialog(AppLocalization.failureStartChatingUser);
    // }
    // isLoading.value = false;
  }

  popupMenuButtonOnSelected(ChatPopupMenuItemsValues value) {
    if (value == ChatPopupMenuItemsValues.autoReply) {
      goToAutoReplyScreen();
    } else if (value == ChatPopupMenuItemsValues.starredMessages) {
      goToStarredMessagesScreen();
    } else if (value == ChatPopupMenuItemsValues.blockedChats) {
      goToBlockedChatsScreen();
    } else if (value == ChatPopupMenuItemsValues.settings) {
      goToSettingsScreen();
    } else if (value == ChatPopupMenuItemsValues.search) {
      toggleSearchMode();
    } else if (value == ChatPopupMenuItemsValues.viewProfile) {
      openSelectedCoversationProfile();
    } else if (value == ChatPopupMenuItemsValues.markMessagesAsRead) {
      markSelectedConversationMessagesAsRead();
    } else if (value == ChatPopupMenuItemsValues.selectAll) {
      selectAllConvesations();
    } else if (value == ChatPopupMenuItemsValues.unselectAll) {
      toggleSelectionMode();
    } else if (value == ChatPopupMenuItemsValues.blockChat) {
      blockSelectedConversation();
    }
  }

  Future<bool> onBackButtonPressed() async {
    if (isSearching.value || selectionEnabled.value) {
      resetToNormalMode();
      return Future.value(false);
    } else if (forwardSelectionEnabled.value) {
      cnacelForwardMode();
      return Future.value(false);
    }
    return Future.value(true);
  }

  String getConversationUserName(int conversationLocalId) {
    return chatController.conversations
        .firstWhere((c) => c.conversation.localId == conversationLocalId)
        .conversation
        .userName;
  }

  Future<void> deleteConversation(int conversationId) async {
    await chatController.deleteConversations([conversationId]);
  }

  Future<void> archiveConversation(int conversationId) async {
    await chatController.toggleArchiveConversation(conversationId);
  }

  void goToSettingsScreen() {
    Get.to(() => const ChatSettingsScreen());
  }

  void goToBlockedChatsScreen() {
    Get.to(() => BlockedChatsScreen());
  }

  void goToAutoReplyScreen() {
    Get.to(() => const AutoReplyScreen());
  }

  void goToStarredMessagesScreen() {
    // i injected the ConversationScreenController so i can use the messages widgets
    //in the starred messages screen, becuase most of conversations widgets depends on that
    // if (chatController.conversations.isNotEmpty) {
    //   Get.put(
    //     ConversationScreenController(
    //       conversation: chatController.conversations[0].conversation,
    //     ),
    //   );
    // }

    Get.to(() => StarredMessagesScreen());
  }

  void goToChatProfileScreen(LocalConversation conversation) {
    Get.to(
      () => ProfileChatScreen(
        conversation: conversation,
      ),
    );
  }

  void openUserProfileImageInFullScreen(
      String? imagePath, String userName, int userId) {
    Get.to(
      () => FullImageScreen(
        imagePath: imagePath,
        title: userName,
        userId: userId,
      ),
    );
  }

  LocalConversation? getConversationWithUserId(int userId) {
    return chatController.conversations
        .firstWhereOrNull((element) => element.conversation.userId == userId)
        ?.conversation;
  }

  void goToConversationScreen(LocalConversation conversation,
      [LocalMessage? matchedMessage]) {
    // Get.delete<ConversationScreenController>();
    // ConversationScreenController controller =
    // Get.put(
    //   ConversationController(
    //     currentConversation: conversation,
    //   ),
    // );
    // ConversationScreenController controller =
    Get.put(
      ConversationScreenController(
        currentConversation: conversation,
        targetMessage: matchedMessage,
      ),
    );
    Get.to(() => ConversationScreen(
          conversation: conversation,
        ));
  }

  void goToConversationScreenWithSearchData(
    MatchedConversationsAndMessage matchedConversation,
  ) {
    goToConversationScreen(
      matchedConversation.conversation,
      matchedConversation.message,
    );
  }

  resetToNormalMode() {
    isSearching.value = false;
    searchFeildController.text = "";
    isSearchTextEmpty.value = true;
    selectionEnabled.value = false;
    forwardSelectionEnabled.value = false;
    selectedConversationsIds.clear();
    _onForwardedMessageSend = null;
  }

  //============================ Start search section ============================//

  TextEditingController searchFeildController = TextEditingController();
  RxBool isSearchTextEmpty = true.obs;
  RxBool isSearching = false.obs;

  Future<void> onSearchTextFieldChanges(String text) async {
    print("onSearchTextFieldChanges");
    // if (text.trim().length > 2 || searchStarted) {
    if (text.trim().isEmpty) {
      isSearchTextEmpty.value = true;
    } else {
      isSearchTextEmpty.value = false;
    }
    chatController.searchInConversations(text);
    if (!forwardSelectionEnabled.value) {
      await chatController.searchInMessages(text);
    }
  }

  toggleSearchMode() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchFeildController.clear();
      isSearchTextEmpty.value = true;
    } else {
      searchFeildFocusNode.requestFocus();
    }
  }

  clearSearchField() {
    searchFeildController.text = "";
    isSearchTextEmpty.value = true;
  }

  //============================ End search section =================================//
  //=================================================================================//
  //============================ Start selection section ============================//

  RxBool selectionEnabled = false.obs;

  RxList<int> selectedConversationsIds = <int>[].obs;

  LocalConversation? get firstSelectedConversation {
    if (selectedConversationsIds.isEmpty) {
      return null;
    }
    return chatController.conversations
        .firstWhereOrNull((element) =>
            element.conversation.localId == selectedConversationsIds[0])
        ?.conversation;
  }

  void toggleSelectionMode() {
    selectionEnabled.value = !selectionEnabled.value;
    if (!selectionEnabled.value) {
      selectedConversationsIds.clear();
    }
  }

  void selectConversation(int conversationId) {
    AppPrint.printInfo("conversation $conversationId selected ");
    if (selectionEnabled.value || forwardSelectionEnabled.value) {
      if (selectedConversationsIds.contains(conversationId)) {
        selectedConversationsIds.remove(conversationId);
      } else {
        selectedConversationsIds.add(conversationId);
      }
      if (selectedConversationsIds.isEmpty && !forwardSelectionEnabled.value) {
        toggleSelectionMode();
      }
    }
  }

  void selectAllConvesations() {
    if (selectionEnabled.value) {
      selectedConversationsIds.clear();
      selectedConversationsIds.addAll(
        chatController.conversations
            .map((element) => element.conversation.localId)
            .toList(),
      );
    }
  }

  Future<void> blockSelectedConversation() async {
    if (selectedConversationsIds.isNotEmpty) {
      await chatController.blockConversation(
        selectedConversationsIds[0],
      );
      toggleSelectionMode();
    }
  }

  Future<void> deleteSelectedConversations() async {
    if (selectedConversationsIds.isNotEmpty) {
      await chatController.deleteConversations(
        selectedConversationsIds.map((element) => element).toList(),
      );
    }
  }

  Future<void> toggleFavoriteSelectedConversation() async {
    if (selectedConversationsIds.isNotEmpty) {
      selectionEnabled.value = false;
      await chatController
          .toggleFavoriteConversation(selectedConversationsIds[0]);
      selectedConversationsIds.clear();
    }
  }

  Future<void> toggleArchiveSelectedConversation() async {
    if (selectedConversationsIds.isNotEmpty) {
      // toggleSelectionMode();
      selectionEnabled.value = false;

      await chatController
          .toggleArchiveConversation(selectedConversationsIds[0]);
      selectedConversationsIds.clear();
    }
  }

  Future<void> openSelectedCoversationProfile() async {
    if (selectedConversationsIds.isNotEmpty) {
      // ParticipantModel participant = ParticipantModel(
      //   id: firstSelectedConversation!.userId,
      //   name: firstSelectedConversation!.userName,
      //   email: firstSelectedConversation!.userEmail,
      //   phone: firstSelectedConversation!.userPhone,
      //   imageUrl: firstSelectedConversation!.userImageUrl,
      // );
      goToChatProfileScreen(firstSelectedConversation!);
      selectionEnabled.value = false;
      selectedConversationsIds.clear();
    }
  }

  Future<void> markSelectedConversationMessagesAsRead() async {
    if (selectedConversationsIds.isNotEmpty) {
      await chatController.markConversationMessagesAsRead(
        selectedConversationsIds[0],
      );
    }
  }

  //============================ End selection section ============================//
  //===============================================================================//
  //============================ Start forward section ============================//

  RxBool forwardSelectionEnabled = false.obs;

  Future<void> Function(List<int> selectedConversationsIds)?
      _onForwardedMessageSend;

  void forwardMessage(
      Future<void> Function(List<int> selectedConversationsIds)
          onForwardedMessageSend) {
    forwardSelectionEnabled.value = true;
    // selectionEnabled.value = true;
    AppPrint.printInfo("Forwarding started");
    _onForwardedMessageSend = onForwardedMessageSend;
  }

  Future<void> forwardMessageToSelectedConversations() async {
    _onForwardedMessageSend!(selectedConversationsIds);
    Get.back();
    if (selectedConversationsIds.length > 1) {
      Get.back();
    }
    resetToNormalMode();
  }

  void cnacelForwardMode() {
    AppPrint.printInfo("Forward Mode Canceled");
    resetToNormalMode();
    Get.back();
  }
  //============================ End forward section ============================//
}
