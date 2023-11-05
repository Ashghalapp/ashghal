import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/util/date_time_formatter.dart';
import 'package:ashghal_app_frontend/core/util/dialog_util.dart';
import 'package:ashghal_app_frontend/core_api/users_state_controller.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_with_count_and_last_message.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/avatar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/highlightable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationWidget extends StatelessWidget {
  final ConversationWithCountAndLastMessage conversation;

  ConversationWidget({super.key, required this.conversation});

  final ChatScreenController _screenController = Get.find();

  final UsersStateController _stateController = Get.find();

  final ChatController _chatController = Get.find();

  String getLastMessageStringDate() {
    return DateTimeFormatter.formatDateTime(
        conversation.lastMessage?.createdAt ??
            conversation.conversation.updatedAt);
  }

  bool get lastMessageMine => conversation.lastMessage == null
      ? false
      : conversation.lastMessage!.senderId == SharedPref.currentUserId;

  @override
  Widget build(BuildContext context) {
    return _buildDismissibleWidget(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: [
            UserImageAvatarWithStatusWidget(
              userId: conversation.conversation.userId,
              userName: conversation.conversation.userName,
              raduis: 26,
              boderThickness: 1,
              borderColor: Get.theme.primaryColor,
              imageUrl: conversation.conversation.userImageUrl,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () {
                        return _screenController.isSearching.value &&
                                !_screenController.isSearchTextEmpty.value
                            ? HighlightableTextWidget(
                                text: conversation.conversation.userName,
                                searchText: _screenController
                                    .searchFeildController.text,
                                fontSize: 15,
                              )
                            : Text(
                                conversation.conversation.userName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                      },
                    ),
                    const SizedBox(height: 7),
                    Obx(
                      () {
                        return _chatController.typingUsers
                                .contains(conversation.conversation.userId)
                            ? Text(
                                "${AppLocalization.typingNow.tr}...",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                ),
                              )
                            : conversation.lastMessage != null
                                ? Opacity(
                                    opacity: 0.9,
                                    child: buildLastMessageRow(),
                                  )
                                : const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
            _buildTimeAgoAndNumberOfNewMessages()
          ],
        ),
      ),
      // ),
    );
  }

  Widget? buildLastMessageRow() {
    return conversation.lastMessage == null
        ? null
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (lastMessageMine)
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 10.0),
                  child: MessageStatusIcon(
                    message: conversation.lastMessage!,
                  ),
                ),
              conversation.lastMessage!.body == null
                  ? Icon(
                      Icons.file_present_sharp,
                      color: conversation.newMessagesCount > 0
                          ? Get.theme.primaryColor
                          : null,
                    )
                  : Expanded(
                      flex: 1,
                      child: Text(
                        conversation.lastMessage!.body!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: conversation.newMessagesCount > 0 &&
                                  !_screenController
                                      .forwardSelectionEnabled.value
                              ? Get.theme.primaryColor
                              : null,
                        ),
                      ),
                    ),
            ],
          );
  }

  Column _buildTimeAgoAndNumberOfNewMessages() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Obx(
          () {
            return _stateController.onlineUsersIds
                    .contains(conversation.conversation.userId)
                ? Text(
                    AppLocalization.online.tr,
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontSize: 16,
                    ),
                  )
                : Text(
                    getLastMessageStringDate(),
                  );
          },
        ),
        const SizedBox(height: 10),
        if (conversation.newMessagesCount > 0 &&
            !_screenController.forwardSelectionEnabled.value)
          Container(
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 7),
              child: Text(
                conversation.newMessagesCount.toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  _buildDismissibleWidget({required Widget child}) {
    return Dismissible(
      key: Key(conversation.conversation.localId
          .toString()), //?? DateTime.now().microsecondsSinceEpoch.toString()),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Widget dismissed from right to left
          //to prevent the widget from beeing deleted from the tree until it is updated
          //I will fire the updating action here and return false so the dissmisssble widget will not delete the wiget
          return DialogUtil.showConfirmationDialog(
            AppLocalization.cofirmArchiveConversationMessage,
          );
          //   .then((value) {
          // if (value != null && value) {

          // }
          // });

          // return Future.value(false);
        } else if (direction == DismissDirection.startToEnd) {
          // Widget dismissed from left to right
          return DialogUtil.showConfirmationDialog(
            AppLocalization.cofirmDeleteConversationMessage,
          );
        }
        return Future.value(false);
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Widget dismissed from right to left
          // TODO: Archive chat
          await _screenController
              .archiveConversation(conversation.conversation.localId);
        } else if (direction == DismissDirection.startToEnd) {
          // Widget dismissed from left to right
          await _screenController
              .deleteConversation(conversation.conversation.localId);
        }
      },
      //left to right container
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.delete, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                AppLocalization.delete.tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
      //right to left container
      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                AppLocalization.archived.tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.archive, color: Colors.white),
            ],
          ),
        ),
      ),
      child: child,
    );
  }
}
