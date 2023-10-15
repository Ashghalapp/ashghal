import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/search_textformfield.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/user_status_text_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../avatar.dart';

class ConversationScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final LocalConversation conversation;
  ConversationScreenAppBar({super.key, required this.conversation});
  final ConversationScreenController _screenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _screenController.selectionEnabled.value
          ? buildSelectionAppBar()
          : _screenController.isSearching.value
              ? buildSearchAppbar()
              : buildNormalAppBar(conversation);
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  AppBar buildSelectionAppBar() {
    return AppBar(
      // backgroundColor: ChatStyle.ownMessageColor,
      backgroundColor: Color.fromRGBO(25, 39, 52, 1),

      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          _screenController.selectedMessagesIds.clear();
          _screenController.selectionEnabled.value = false;
          // toggleAppBar();
        },
        icon: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
      title: Text(
        _screenController.selectedMessagesIds.isNotEmpty
            ? "${_screenController.selectedMessagesIds.length} item selected"
            : "No item selected",
        style: const TextStyle(fontSize: 15),
      ),
      actions: [
        Visibility(
          visible: _screenController.selectedMessagesIds.length == 1,
          child: IconButton(
            icon: const Icon(
              Icons.copy_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              _screenController.copyToClipboard();
            },
          ),
        ),
        Visibility(
          visible: _screenController.selectedMessagesIds.isNotEmpty,
          child: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              _screenController.deleteSelectedMessages();
            },
          ),
        ),
        Visibility(
          visible: _screenController.selectedMessagesIds.length == 1,
          child: IconButton(
            icon: const Icon(
              Icons.info_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              _screenController.viewMessageInfo();
            },
          ),
        ),
        IconButton(
          icon: Obx(() => Icon(
                Icons.select_all,
                color: _screenController.selectedMessagesIds.length ==
                        _screenController.conversationController.messages.length
                    ? Colors.black87
                    : Colors.white,
              )),
          onPressed: () {
            _screenController.selectAllMessages();
          },
        ),
      ],
    );
  }

  PreferredSize buildSearchAppbar() {
    return PreferredSize(
      preferredSize: Size(Get.width, 260),
      child: Container(
        // color: ChatStyle.ownMessageColor,
        color: Color.fromRGBO(25, 39, 52, 1),
        padding: const EdgeInsets.only(top: 53),
        child: Row(
          children: [
            const SizedBox(width: 7),
            InkWell(
              onTap: _screenController.toggleSearchingMode,
              child: const Icon(
                Icons.arrow_back,
                size: 22,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: SearchInputField(
                controller: _screenController.searchFeildController,
                onSearchPressed: _screenController.searchInMessages,
              ),
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: _screenController.incrementIndex,
              child: const Icon(
                Icons.arrow_drop_up,
                color: Colors.white,
                size: 27,
              ),
            ),
            const SizedBox(width: 7),
            InkWell(
              onTap: _screenController.decrementIndex,
              child: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 27,
              ),
            ),
            const SizedBox(width: 7),
          ],
        ),
      ),
    );
  }

  AppBar buildNormalAppBar(LocalConversation conversation) {
    return AppBar(
      centerTitle: false,
      // backgroundColor: ChatStyle.ownMessageColor,
      backgroundColor: Color.fromRGBO(25, 39, 52, 1),
      elevation: 2,
      leadingWidth: 83,
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 9),
            const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            UserImageAvatarWithStatusWidget(
              userId: conversation.userId,
              userName: conversation.userName,
              raduis: 23,
              boderThickness: 0,
              imageUrl: conversation.userImageUrl,
              statusBorderColor: Colors.white54,
            ),
          ],
        ),
      ),
      title: Column(
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
          UserStatusTextWidget(
            userId: conversation.userId,
            offlineColor: Colors.white70,
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: _screenController.toggleSearchingMode,
        ),
        buildAppbarDropDownMenuOptions()
      ],
    );
  }

  PopupMenuButton<ConversationPopupMenuItemsValues>
      buildAppbarDropDownMenuOptions() {
    return PopupMenuButton<ConversationPopupMenuItemsValues>(
      color: Colors.white,
      onSelected: _screenController.popupMenuButtonOnSelected,
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
}
