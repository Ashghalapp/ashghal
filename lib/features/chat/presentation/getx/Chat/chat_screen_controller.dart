import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';

import 'package:ashghal_app_frontend/features/chat/presentation/getx/Chat/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/Chat/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/ChatScreen/conversation_screen.dart';
import 'package:get/get.dart';

enum ChatPopupMenuItemsValues { settings, blockedUsers, createConversation }

class ChatScreenController extends GetxController {
  // RxList<ConversationWithCountAndLastMessage> get conversations =>
  //     _chatController.conversations;
  RxBool isLoaing = false.obs;
  final ChatController _chatController = Get.put(ChatController());

  Future<void> startConversationWith(int userId) async {
    _chatController.startConversationWith(userId);
  }

  Future<void> deleteConversation(int conversationId) async {
    _chatController.deleteConversation(conversationId);
  }

  popupMenuButtonOnSelected(ChatPopupMenuItemsValues value) {
    if (value == ChatPopupMenuItemsValues.settings) {
      goToSettingsScreen();
    } else if (value == ChatPopupMenuItemsValues.blockedUsers) {
      goToBlockedUsersScreen();
    } else if (value == ChatPopupMenuItemsValues.createConversation) {
      startConversationWith(6);
    }
  }

  void goToSettingsScreen() {}
  void goToBlockedUsersScreen() {}
  void goToConversationScreen(LocalConversation conversation) {
    Get.put(ConversationScreenController(conversationId: conversation.localId));
    Get.to(() => ConversationScreen(conversation: conversation));
  }
}
