import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation_search_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/filled_outline_button.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/search_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  final int? conversationId;
  ChatScreen({super.key, this.conversationId});
  final ChatScreenController _screenController =
      Get.put(ChatScreenController());

  final ChatController _chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Get.isPlatformDarkMode ? ChatTheme.dark : ChatTheme.light,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Obx(
              () => _screenController.isSearching.value ||
                      _screenController.forwardSelectionEnabled.value
                  ? const SizedBox.shrink()
                  : buildFilterButtons(),
            ),
            Expanded(
              child: Obx(
                () {
                  if (_chatController.isLoaing.value) {
                    return AppUtil.addProgressIndicator(50);
                  } else if (_chatController.filteredConversations.isEmpty &&
                      !_screenController.isSearching.value) {
                    return _buildNoConversationsyet();
                  } else if (_screenController.isSearching.value) {
                    return _screenController.isSearchTextEmpty.value
                        ? const SizedBox.shrink()
                        : _buildSearchResultList();
                  }
                  return _builConversationsListView();
                },
              ),
            ),
            if (_screenController.forwardSelectionEnabled.value &&
                _screenController.selectedConversationsIds.isNotEmpty)
              Card(
                color: Get.isPlatformDarkMode
                    ? ChatColors.appBarDark
                    : ChatColors.appBarLight,
                margin: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            _screenController.selectedConversationsIds.length,
                        itemBuilder: (_, index) {
                          return Chip(
                            label: Text(
                                "conversation${_screenController.selectedConversationsIds[index]}"),
                          );
                        },
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.send))
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  ListView _builConversationsListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _chatController.filteredConversations.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            // Container(
            //   margin: EdgeInsets.only(left: 12),
            //   // padding:,
            //   height: 22,
            //   width: 22,
            //   decoration: BoxDecoration(
            //       border: Border.all(
            //     color: Get.isPlatformDarkMode ? Colors.white70 : Colors.black87,
            //   ),),
            // ),
            Expanded(
              child: ConversationWidget(
                conversation: _chatController.filteredConversations[index],
              ),
            ),
          ],
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 1,
      leadingWidth: 45,
      // centerTitle: ,
      leading: Obx(
        () {
          return _screenController.forwardSelectionEnabled.value
              ? InkWell(
                  onTap: _screenController.cnacelForwardMode,
                  child: const Icon(Icons.arrow_back),
                )
              : _screenController.isSearching.value
                  ? InkWell(
                      onTap: _screenController.toggleSearchMode,
                      child: const Icon(Icons.arrow_back),
                    )
                  : PressableIconBackground(
                      icon: Icons.search,
                      onTap: _screenController.toggleSearchMode,
                      borderRadius: 0,
                    );
        },
      ),
      title: Obx(
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
                          "${_screenController.selectedConversationsIds.length} selected")
                      : const Text("Forward to...")
                  : const Text("Ashghal Chat");
        },
      ),
      actions: [
        Obx(
          () {
            if (!_screenController.isSearching.value &&
                !_screenController.forwardSelectionEnabled.value) {
              return PressableIconBackground(
                padding: 1,
                borderRadius: 0,
                onTap: () {},
                child: PopupMenuButton<ChatPopupMenuItemsValues>(
                  // color: Colors.white,
                  onSelected: _screenController.popupMenuButtonOnSelected,
                  itemBuilder: (BuildContext ctx) {
                    return [
                      PopupMenuItem(
                        value: ChatPopupMenuItemsValues.settings,
                        child: Text(ChatPopupMenuItemsValues.settings.value),
                      ),
                      PopupMenuItem(
                        value: ChatPopupMenuItemsValues.blockedUsers,
                        child: Text(
                          ChatPopupMenuItemsValues.blockedUsers.value,
                        ),
                      ),
                      // const PopupMenuItem(
                      //   value: ChatPopupMenuItemsValues.createConversation,
                      //   child: Text("Create Conversation"),
                      // ),
                    ];
                  },
                ),
              );
            } else if (_screenController.forwardSelectionEnabled.value &&
                !_screenController.isSearching.value) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  onTap: _screenController.toggleSearchMode,
                  child: const Icon(Icons.search),
                ),
              );
            } else if (_screenController.isSearching.value &&
                _screenController.isSearchTextEmpty.value &&
                !_screenController.forwardSelectionEnabled.value) {
              return const SizedBox.shrink();
            } else {
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

            // _screenController.forwardSelectionEnabled.value && !_screenController.isSearching.value? Padding(
            //             padding: const EdgeInsets.only(right: 10.0),
            //             child: InkWell(
            //               child: const Icon(Icons.search),
            //               onTap:_screenController.toggleSearchMode,
            //             ),
            //           )
            // return !_screenController.isSearching.value
            //     ? PressableIconBackground(
            //         padding: 1,
            //         borderRadius: 0,
            //         onTap: () {},
            //         child: PopupMenuButton<ChatPopupMenuItemsValues>(
            //           // color: Colors.white,
            //           onSelected: _screenController.popupMenuButtonOnSelected,
            //           itemBuilder: (BuildContext ctx) {
            //             return [
            //               PopupMenuItem(
            //                 value: ChatPopupMenuItemsValues.settings,
            //                 child:
            //                     Text(ChatPopupMenuItemsValues.settings.value),
            //               ),
            //               PopupMenuItem(
            //                 value: ChatPopupMenuItemsValues.blockedUsers,
            //                 child: Text(
            //                   ChatPopupMenuItemsValues.blockedUsers.value,
            //                 ),
            //               ),
            //               // const PopupMenuItem(
            //               //   value: ChatPopupMenuItemsValues.createConversation,
            //               //   child: Text("Create Conversation"),
            //               // ),
            //             ];
            //           },
            //         ),
            //       )
            //     : _screenController.isSearchTextEmpty.value
            //         ? const SizedBox.shrink()
            //         : Padding(
            //             padding: const EdgeInsets.only(right: 10.0),
            //             child: InkWell(
            //               child: const Icon(Icons.cancel),
            //               onTap:_screenController.clearSearchField,
            //             ),
            //           );
          },
        ),
      ],
    );
  }

  // buildForwardAppBar(){

  // }

  /// A list of filters
  SizedBox buildFilterButtons() {
    return SizedBox(
      height: 70,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        margin: const EdgeInsets.all(0),
        elevation: 2,
        child: ListView(
          padding: const EdgeInsets.only(left: 12),
          scrollDirection: Axis.horizontal,
          children: [
            Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildFilterButton(ChatFilters.all),
                  _buildFilterButton(ChatFilters.recentMessages),
                  _buildFilterButton(ChatFilters.active),
                  _buildFilterButton(ChatFilters.favorite),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Filter outlined button
  Padding _buildFilterButton(ChatFilters filter) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: CustomOutlineButton(
        isFilled:
            _screenController.chatController.appliedFilter.value == filter,
        text: filter.value,
        onPress: () => _screenController.chatController.applyFilter(filter),
      ),
    );
  }

  /// A text to indicate no conversations based on the applied filter
  Widget _buildNoConversationsyet() {
    return Obx(() {
      ChatFilters appliedFilter =
          _screenController.chatController.appliedFilter.value;
      return Text(
        appliedFilter == ChatFilters.recentMessages
            ? AppLocalization.noRecentsMessages
            : appliedFilter == ChatFilters.active
                ? AppLocalization.noActiveUsers
                : appliedFilter == ChatFilters.favorite
                    ? AppLocalization.noFavoriteChats
                    : AppLocalization.noConversationsYet,
      );
    });
  }

  /// A listview to show search results
  SingleChildScrollView _buildSearchResultList() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSearchResultText(AppLocalization.conversations),
          GetX<ChatController>(
            builder: (controller) {
              if (_chatController.searchMatchedConversations.isEmpty) {
                return Text(
                  AppLocalization.noConversationsMatchedSearch,
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: _chatController.searchMatchedConversations.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ConversationWidget(
                    conversation:
                        _chatController.searchMatchedConversations[index],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 8),
          _buildSearchResultText(AppLocalization.messages),
          GetX<ChatController>(
            builder: (controller) {
              if (_chatController.searchMatchedConversationMessages.isEmpty) {
                return Text(AppLocalization.noMessagesMatchedSearch);
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount:
                    _chatController.searchMatchedConversationMessages.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ConversationSearchWidget(
                    matchedConversation: _chatController
                        .searchMatchedConversationMessages[index],
                    searchText: _screenController.searchFeildController.text,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// A text showed above search result to indicate if the
  /// search result from a conversations or from messages
  Padding _buildSearchResultText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.white54 : Colors.black45,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Get.isDarkMode ? Colors.black : Colors.white,
                ),
                // overflow: ,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
