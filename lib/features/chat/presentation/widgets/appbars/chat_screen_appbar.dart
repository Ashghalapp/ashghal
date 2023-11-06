import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/search_textformfield.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  ChatScreenAppBar({
    super.key,
  });

  final ChatScreenController _screenController = Get.find();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      leadingWidth: 48,
      leading: builLeading(),
      title: buildTitle(),
      actions: [
        Obx(
          () {
            if (_screenController.selectionEnabled.value) {
              return buildSelectionModeActions();
            }
            if (!_screenController.isSearching.value &&
                !_screenController.forwardSelectionEnabled.value) {
              return buildPopMenuButtonAccordingToMode();
            } else if (_screenController.forwardSelectionEnabled.value &&
                !_screenController.isSearching.value) {
              return buildSearchButton();
            } else if (_screenController.isSearching.value &&
                (!_screenController.isSearchTextEmpty.value ||
                    _screenController.forwardSelectionEnabled.value)) {
              return buildCancelButton();
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Obx buildTitle() {
    return Obx(
      () {
        return _screenController.isSearching.value
            ? Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: SearchTextField(
                  focusNode: _screenController.searchFeildFocusNode,
                  controller: _screenController.searchFeildController,
                  onTextChanged: (value) async =>
                      await _screenController.onSearchTextFieldChanges(value),
                ),
              )
            : _screenController.forwardSelectionEnabled.value
                ? _screenController.selectedConversationsIds.isNotEmpty
                    ? Text(
                        "${_screenController.selectedConversationsIds.length} ${AppLocalization.chatSelected.tr}")
                    : Text(AppLocalization.forwardTo.tr)
                : _screenController.selectionEnabled.value
                    ? Text(
                        // _screenController.selectedConversationsIds.isNotEmpty
                        //     ?
                        "${_screenController.selectedConversationsIds.length}" +
                            " " +
                            AppLocalization.conversationsSelected.tr,
                        // : "No item selected",
                        style: const TextStyle(fontSize: 15),
                      )
                    : Text(AppLocalization.ashghal.tr);
      },
    );
  }

  Obx builLeading() {
    return Obx(
      () {
        return _screenController.forwardSelectionEnabled.value ||
                _screenController.isSearching.value ||
                _screenController.selectionEnabled.value
            ? InkWell(
                onTap: () {
                  if (_screenController.forwardSelectionEnabled.value) {
                    _screenController.cnacelForwardMode();
                  } else if (_screenController.isSearching.value) {
                    _screenController.toggleSearchMode();
                  } else if (_screenController.selectionEnabled.value) {
                    _screenController.toggleSelectionMode();
                  }
                },
                child: const Icon(Icons.arrow_back),
              )
            : PressableIconBackground(
                icon: Icons.search,
                onTap: _screenController.toggleSearchMode,
                borderRadius: 0,
                padding: 10,
              );
      },
    );
  }

  Row buildSelectionModeActions() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.delete,
          ),
          onPressed: _screenController.deleteSelectedConversations,
        ),
        Visibility(
          visible: _screenController.selectedConversationsIds.length == 1,
          child: IconButton(
            icon: Icon(
              _screenController.firstSelectedConversation?.isArchived == true
                  ? Icons.archive
                  : Icons.archive_outlined,
              color: _screenController.firstSelectedConversation?.isArchived ==
                      true
                  ? Get.theme.primaryColor
                  : null,
            ),
            onPressed: _screenController.toggleArchiveSelectedConversation,
          ),
        ),
        Visibility(
          visible: _screenController.selectedConversationsIds.length == 1,
          child: IconButton(
            icon: Icon(
              _screenController.firstSelectedConversation?.isFavorite == true
                  ? Icons.favorite
                  : Icons.favorite_border_sharp,
              color: _screenController.firstSelectedConversation?.isFavorite ==
                      true
                  ? Get.theme.primaryColor
                  : null,
            ),
            onPressed: _screenController.toggleFavoriteSelectedConversation,
          ),
        ),
        buildPopMenuButtonAccordingToMode(),
      ],
    );
  }

  Widget buildPopMenuButtonAccordingToMode() {
    if (_screenController.selectionEnabled.value) {
      if (_screenController.selectedConversationsIds.length == 1) {
        return buildPopupMenuButton(
          oneSelectedConversationModePopupmenuButtons,
        );
      } else {
        if (_screenController.selectedConversationsIds.length ==
            _screenController.chatController.filteredConversations.length) {
          return buildPopupMenuButton(
            [unselectAllMenuButton],
          );
        } else {
          return buildPopupMenuButton(
            [selectAllPopMenuButton],
          );
        }
      }
    } else {
      return PressableIconBackground(
        padding: 0,
        borderRadius: 0,
        onTap: () {},
        child: buildPopupMenuButton(normalModePopupmenuButtons),
      );
    }
  }

  Padding buildCancelButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        child: const Icon(Icons.cancel),
        onTap: () {
          if (_screenController.isSearchTextEmpty.value &&
              _screenController.forwardSelectionEnabled.value) {
            _screenController.toggleSearchMode();
          } else {
            _screenController.clearSearchField();
          }
        },
      ),
    );
  }

  Padding buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        onTap: _screenController.toggleSearchMode,
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget buildPopupMenuButton(
      List<PopupMenuItem<ChatPopupMenuItemsValues>> items) {
    return PopupMenuButton<ChatPopupMenuItemsValues>(
      onSelected: _screenController.popupMenuButtonOnSelected,
      itemBuilder: (BuildContext ctx) {
        return items;
      },
    );
  }

  List<PopupMenuItem<ChatPopupMenuItemsValues>>
      get normalModePopupmenuButtons => [
            PopupMenuItem(
              value: ChatPopupMenuItemsValues.search,
              child: Text(
                ChatPopupMenuItemsValues.search.value.tr,
              ),
            ),
            PopupMenuItem(
              value: ChatPopupMenuItemsValues.starredMessages,
              child: Text(
                ChatPopupMenuItemsValues.starredMessages.value.tr,
              ),
            ),
            PopupMenuItem(
              value: ChatPopupMenuItemsValues.blockedChats,
              child: Text(
                ChatPopupMenuItemsValues.blockedChats.value.tr,
              ),
            ),
          ];

  List<PopupMenuItem<ChatPopupMenuItemsValues>>
      get oneSelectedConversationModePopupmenuButtons => [
            PopupMenuItem(
              value: ChatPopupMenuItemsValues.viewProfile,
              child: Text(
                ChatPopupMenuItemsValues.viewProfile.value.tr,
              ),
            ),
            PopupMenuItem(
              value: ChatPopupMenuItemsValues.markMessagesAsRead,
              child: Text(
                ChatPopupMenuItemsValues.markMessagesAsRead.value.tr,
              ),
            ),
            PopupMenuItem(
              value: ChatPopupMenuItemsValues.blockChat,
              child: Text(
                ChatPopupMenuItemsValues.blockChat.value.tr,
              ),
            ),
            selectAllPopMenuButton
          ];

  PopupMenuItem<ChatPopupMenuItemsValues> get selectAllPopMenuButton =>
      PopupMenuItem(
        value: ChatPopupMenuItemsValues.selectAll,
        child: Text(
          ChatPopupMenuItemsValues.selectAll.value.tr,
        ),
      );
  PopupMenuItem<ChatPopupMenuItemsValues> get unselectAllMenuButton =>
      PopupMenuItem(
        value: ChatPopupMenuItemsValues.unselectAll,
        child: Text(
          ChatPopupMenuItemsValues.unselectAll.value.tr,
        ),
      );
}
