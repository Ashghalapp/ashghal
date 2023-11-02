import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_with_count_and_last_message.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:get/get.dart';

class BlockedConversationsScreenController extends GetxController {
  RxList<LocalConversation> blockedConversations = <LocalConversation>[].obs;
  final ChatController chatController = Get.find();

  @override
  void onInit() {
    _fetchBlockedConversations();
    super.onInit();
  }

  Future<void> _fetchBlockedConversations() async {
    blockedConversations
        .addAll(await chatController.fetchAllBlockedConversations());
  }

  void unblockConversation(int index) {
    AppUtil.showConfirmationDialog(AppLocalization.confirmUnblockChat).then(
      (value) async {
        if (value != null &&
            value &&
            blockedConversations[index].remoteId != null) {
          bool ok = await chatController
              .unblockConversation(blockedConversations[index].remoteId!);
          if (ok) {
            blockedConversations.removeAt(index);
          }
        }
      },
    );
  }

  void unblockAllConversations(bool value) {
    AppUtil.showConfirmationDialog(AppLocalization.confirmUnblockAllChat).then(
      (value) async {
        if (value != null && value) {
          while (blockedConversations.isNotEmpty) {
            if (blockedConversations[blockedConversations.length - 1]
                    .remoteId !=
                null) {
              bool ok = await chatController.unblockConversation(
                  blockedConversations[blockedConversations.length - 1]
                      .remoteId!);
              if (ok) {
                blockedConversations.removeAt(blockedConversations.length - 1);
              }
            }
          }
        }
      },
    );
  }
}
