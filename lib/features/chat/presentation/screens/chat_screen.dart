import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_with_count_and_last_message.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/participant_model.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/appbar/chat_screen_appbar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/chat_screen_forward_footer.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation_search_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/filled_outline_button.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  final ParticipantModel? userId;
  ChatScreen({super.key, this.userId});
  final ChatScreenController _screenController =
      Get.put(ChatScreenController());

  final ChatController _chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Get.isPlatformDarkMode ? ChatTheme.dark : ChatTheme.light,
      child: SafeArea(
        child: Scaffold(
          appBar: ChatScreenAppBar(),
          body: WillPopScope(
            onWillPop: _screenController.onBackButtonPressed,
            child: Column(
              children: [
                //If the screen in selection or search or forward modes show filter buttons
                Obx(
                  () => _screenController.isSearching.value ||
                          _screenController.forwardSelectionEnabled.value ||
                          _screenController.selectionEnabled.value
                      ? const SizedBox.shrink()
                      : buildFilterButtons(),
                ),
                Expanded(
                  child: Obx(
                    () {
                      if (_chatController.isLoaing.value ||
                          _screenController.isLoading.value) {
                        return AppUtil.addProgressIndicator(50);
                      } else if (_chatController
                              .filteredConversations.isEmpty &&
                          !_screenController.isSearching.value) {
                        return _buildNoConversationsyet();
                      } else if (_screenController.isSearching.value &&
                          !_screenController.forwardSelectionEnabled.value) {
                        return _screenController.isSearchTextEmpty.value
                            ? const SizedBox.shrink()
                            : _buildSearchResultList();
                      } else if (_screenController.isSearching.value &&
                          _screenController.forwardSelectionEnabled.value &&
                          !_screenController.isSearchTextEmpty.value) {
                        return _chatController
                                .searchMatchedConversations.isEmpty
                            ? _buildNoMatchSearchText(
                                AppLocalization.noConversationsMatchedSearch,
                              )
                            : _builConversationsListView(
                                _chatController.searchMatchedConversations,
                              );
                      }
                      return _builConversationsListView(
                        _chatController.filteredConversations,
                      );
                    },
                  ),
                ),
                Obx(
                  () => _screenController.forwardSelectionEnabled.value &&
                          _screenController.selectedConversationsIds.isNotEmpty
                      ? ChatScreenForwardModeFooter()
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView _builConversationsListView(
      List<ConversationWithCountAndLastMessage> conversations) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: conversations.length,
      itemBuilder: (BuildContext context, int index) {
        return Obx(
          () => Container(
            color: _screenController.selectedConversationsIds
                    .contains(conversations[index].conversation.localId)
                ? Colors.green.withOpacity(0.2)
                : null,
            child: InkWell(
              onLongPress: () {
                if (!_screenController.isSearching.value) {
                  if (!_screenController.selectionEnabled.value) {
                    _screenController.toggleSelectionMode();
                  }
                  _screenController.selectConversation(
                      conversations[index].conversation.localId);
                }
              },
              onTap: () {
                if (_screenController.selectionEnabled.value ||
                    _screenController.forwardSelectionEnabled.value) {
                  _screenController.selectConversation(
                      conversations[index].conversation.localId);
                } else {
                  _screenController.goToConversationScreen(
                      conversations[index].conversation);
                }
              },
              child: Row(
                children: [
                  if (_screenController.selectionEnabled.value ||
                      _screenController.forwardSelectionEnabled.value)
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      padding: const EdgeInsets.all(2),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Get.isPlatformDarkMode
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),
                      child: _screenController.selectedConversationsIds
                              .contains(
                                  conversations[index].conversation.localId)
                          ? Icon(
                              Icons.check,
                              color: Get.isPlatformDarkMode
                                  ? Colors.white70
                                  : Colors.black87,
                              size: 14,
                            )
                          : null,
                    ),
                  Expanded(
                    child: ConversationWidget(
                      conversation: conversations[index],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
                  _buildFilterButton(ChatFilters.archived),
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
      return Center(
        child: Text(
          appliedFilter == ChatFilters.recentMessages
              ? AppLocalization.noRecentsMessages
              : appliedFilter == ChatFilters.active
                  ? AppLocalization.noActiveUsers
                  : appliedFilter == ChatFilters.favorite
                      ? AppLocalization.noFavoriteChats
                      : appliedFilter == ChatFilters.archived
                          ? AppLocalization.noArchivedChats
                          : AppLocalization.noConversationsYet,
        ),
      );
    });
  }

  /// A listview to show search results
  SingleChildScrollView _buildSearchResultList() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSearchResultResourceText(AppLocalization.conversations),
          GetX<ChatController>(
            builder: (controller) {
              if (_chatController.searchMatchedConversations.isEmpty) {
                return _buildNoMatchSearchText(
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
          _buildSearchResultResourceText(AppLocalization.messages),
          GetX<ChatController>(
            builder: (controller) {
              if (_chatController.searchMatchedConversationMessages.isEmpty) {
                return _buildNoMatchSearchText(
                  AppLocalization.noMessagesMatchedSearch,
                );
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

  Text _buildNoMatchSearchText(String text) {
    return Text(
      text,
    );
  }

  /// A text showed above search result to indicate if the
  /// search result from a conversations or from messages
  Padding _buildSearchResultResourceText(String text) {
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
