import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/localization/local_controller.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/search_textformfield.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/user_status_text_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../avatar.dart';

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
      leading: IconButton(
        onPressed: _screenController.toggleSelectionMode,
        icon: const Icon(
          Icons.close,
        ),
      ),
      title: Text(
        _screenController.selectedMessagesIds.isNotEmpty
            ? "${_screenController.selectedMessagesIds.length} ${AppLocalization.messageSelected.tr}"
            : AppLocalization.noMessageSelected.tr,
        style: const TextStyle(fontSize: 15),
      ),
      actions: [
        Visibility(
          visible: _screenController.selectedMessagesIds.length == 1,
          child: IconButton(
            icon: const Icon(
              Icons.copy_outlined,
            ),
            onPressed: _screenController.copyToClipboard,
          ),
        ),
        Visibility(
          visible: _screenController.selectedMessagesIds.isNotEmpty,
          child: IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: _screenController.deleteSelectedMessages,
          ),
        ),
        Visibility(
          visible: _screenController.selectedMessagesIds.length == 1,
          child: IconButton(
            icon: const Icon(
              Icons.info_outlined,
            ),
            onPressed: _screenController.viewMessageInfo,
          ),
        ),
        Visibility(
          visible: _screenController.selectedMessagesIds.length > 1,
          child: IconButton(
            icon: Obx(() => Icon(
                  Icons.select_all,
                  color: _screenController.selectedMessagesIds.length ==
                          _screenController
                              .conversationController.messages.length
                      ? Get.theme.primaryColor
                      : null,
                )),
            onPressed: _screenController.selectAllMessages,
          ),
        ),
        Visibility(
          visible: _screenController.selectedMessagesIds.length == 1,
          child: IconButton(
            icon: Icon(
              _screenController.firstSelectedMessage?.isStarred == true
                  ? Icons.star
                  : Icons.star_border,
              color: _screenController.firstSelectedMessage?.isStarred == true
                  ? Get.theme.primaryColor
                  : null,
            ),
            onPressed: _screenController.toggleStarSelectedMessage,
          ),
        ),
        Visibility(
          visible: _screenController.ableToForwardSelectedMessage.value,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_forward,
            ),
            onPressed: _screenController.forwardSelectedMessage,
          ),
        ),
      ],
    );
  }

  AppBar buildSearchAppbar() {
    return AppBar(
      leadingWidth: 50,
      leading: InkWell(
        onTap: _screenController.toggleSearchingMode,
        child: const Icon(
          Icons.arrow_back,
          size: 22,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SearchTextField(
          controller: _screenController.searchFeildController,
          onTextChanged: (value) =>
              _screenController.onSearchTextFieldChanged(value),
          focusNode: _screenController.searchFeildFocusNode,
        ),
      ),
      actions: [
        const SizedBox(width: 5),
        InkWell(
          onTap: _screenController.incrementIndex,
          child: const Icon(
            Icons.arrow_drop_up,
            size: 30,
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: _screenController.decrementIndex,
          child: const Icon(
            Icons.arrow_drop_down,
            size: 30,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  AppBar buildNormalAppBar(LocalConversation conversation) {
    return AppBar(
      centerTitle: false,
      elevation: 2,
      leadingWidth: 101,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 9),
          InkWell(
            onTap: _screenController.closeThisConversationScreen,
            child: Obx(
              () => Icon(
                Get.find<AppLocallcontroller>().language.value == "en" ||
                        Get.find<AppLocallcontroller>().language.value == "sys"
                    ? Icons.arrow_back_ios_new
                    : Icons.arrow_forward_ios,
              ),
            ),
          ),
          const SizedBox(width: 8),
          UserImageAvatarWithStatusWidget(
            userId: conversation.userId,
            userName: conversation.userName,
            raduis: 24,
            statusRadius: 8,
            // boderThickness: 1,
            borderColor: Get.theme.primaryColor,
            boderThickness: 1,
            imageUrl: conversation.userImageUrl,
            statusBorderColor: Colors.white54,
            showImageDirectly: true,
          ),
        ],
      ),
      titleTextStyle: const TextStyle(
        // fontWeight: FontWeight.w500,
        fontSize: 15,
        // color: Colors.white,
      ),
      title: InkWell(
        onTap: _screenController.goToUserProfileScreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              conversation.userName,
              style: TextStyle(
                fontSize: 16,
                color: Get.isPlatformDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            UserStatusTextWidget(
              userId: conversation.userId,
              offlineColor:
                  Get.isPlatformDarkMode ? Colors.white70 : Colors.black45,
            )
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
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
      onSelected: _screenController.popupMenuButtonOnSelected,
      itemBuilder: (BuildContext ctx) {
        return [
          PopupMenuItem(
            value: ConversationPopupMenuItemsValues.search,
            child: Text(ConversationPopupMenuItemsValues.search.value.tr),
          ),
          PopupMenuItem(
            value: ConversationPopupMenuItemsValues.mediaDocsLinks,
            child:
                Text(ConversationPopupMenuItemsValues.mediaDocsLinks.value.tr),
          ),
          PopupMenuItem(
            value: ConversationPopupMenuItemsValues.goToFirstMessage,
            child: Text(
                ConversationPopupMenuItemsValues.goToFirstMessage.value.tr),
          ),
          PopupMenuItem(
            value: ConversationPopupMenuItemsValues.clearChat,
            child: Text(ConversationPopupMenuItemsValues.clearChat.value.tr),
          ),
          PopupMenuItem(
            value: ConversationPopupMenuItemsValues.block,
            child: Text(ConversationPopupMenuItemsValues.block.value.tr),
          ),
        ];
      },
    );
  }
}
