import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/conversation_and_message.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/starred_messages_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/avatar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/filled_outline_button.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/search_textformfield.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StarredMessagesScreen extends StatelessWidget {
  StarredMessagesScreen({super.key});
  final StarredMessagesScreenController controller =
      Get.put(StarredMessagesScreenController());
  final AudioController audioController = Get.put(AudioController());
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Get.isPlatformDarkMode ? ChatTheme.dark : ChatTheme.light,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: WillPopScope(
          onWillPop: controller.onBackButtonPressed,
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return Center(
                  child: AppUtil.addProgressIndicator(50),
                );
              }
              return Column(
                children: [
                  Obx(
                    () => controller.isSearching.value
                        ? const SizedBox.shrink()
                        : _buildFilterButtons(),
                  ),
                  Expanded(
                    child: _buildStarredMessagesListView(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Center _buildNoMessagesText() {
    return Center(
      child: Obx(
        () {
          if (controller.isSearching.value &&
              !controller.isSearchTextEmpty.value) {
            return Text(AppLocalization.noStarredMessagesMatchedSearch.tr);
          } else if (controller.isSearching.value) {
            return Text(AppLocalization.noStarredMessages.tr);
          } else if (controller.appliedFilter.value ==
              StarredMessagesFilters.mine) {
            return Text(AppLocalization.noStarredMessagesBelongsToYou.tr);
          } else if (controller.appliedFilter.value ==
              StarredMessagesFilters.others) {
            return Text(AppLocalization.noStarredMessagesBelongsToOthers.tr);
          }
          return Text(AppLocalization.noStarredMessages.tr);
        },
      ),
    );
  }

  SizedBox _buildFilterButtons() {
    return SizedBox(
      height: 60,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        margin: const EdgeInsets.all(0),
        elevation: 1,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 12),
            scrollDirection: Axis.horizontal,
            children: [
              Obx(
                () => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFilterButton(StarredMessagesFilters.all),
                    _buildFilterButton(StarredMessagesFilters.mine),
                    _buildFilterButton(StarredMessagesFilters.others),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Filter outlined button
  Padding _buildFilterButton(StarredMessagesFilters filter) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: CustomOutlineButton(
        isFilled: controller.appliedFilter.value == filter,
        text: filter.value,
        onPress: () => controller.applyFilter(filter),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 1,
      title: Obx(
        () => controller.isSearching.value
            ? Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: SearchTextField(
                  focusNode: controller.searchFeildFocusNode,
                  controller: controller.searchTextEdittingController,
                  onTextChanged: (value) async =>
                      await controller.onSearchTextFieldChanges(value),
                ),
              )
            : Text(AppLocalization.starredMessages.tr),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Obx(
            () {
              if (controller.isSearching.value) {
                if (controller.isSearchTextEmpty.value) {
                  return const SizedBox.shrink();
                }
                return InkWell(
                  onTap: controller.clearSearchField,
                  child: const Icon(Icons.cancel_outlined),
                );
              }
              return InkWell(
                onTap: controller.toggleSearchMode,
                child: const Icon(Icons.search),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStarredMessagesListView() {
    return Obx(
      () {
        if (controller.filteredMessages.isEmpty) {
          return _buildNoMessagesText();
        }
        return ListView.builder(
          itemCount: controller.filteredMessages.length,
          itemBuilder: (_, index) {
            ConversationAndMessageModel currentStarred =
                controller.filteredMessages[index];
            bool isMine = currentStarred.message.message.senderId ==
                SharedPref.currentUserId;
            return GestureDetector(
              onTap: () =>
                  controller.goToConversationScreenWithStarredMessageIndex(
                index,
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Get.isPlatformDarkMode
                            ? Colors.white60
                            : Colors.black38),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildAvatar(isMine, currentStarred),
                            const SizedBox(width: 8),
                            Text(
                              isMine
                                  ? AppLocalization.you.tr
                                  : currentStarred.conversation.userName,
                              style: TextStyle(
                                fontSize: 17,
                                color: Get.isPlatformDarkMode
                                    ? null
                                    : Colors.black,
                              ),
                            ),
                            const Icon(Icons.arrow_right),
                            Text(
                              isMine
                                  ? currentStarred.conversation.userName
                                  : AppLocalization.you.tr,
                              style: TextStyle(
                                fontSize: 17,
                                color: Get.isPlatformDarkMode
                                    ? null
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppUtil.formatDateTime(
                                  currentStarred.message.message.createdAt),
                            ),
                            _buildForwardIcon(index),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(top: 5, bottom: 5, left: 25),
                      child: MessageCardWidget(
                        message: controller.filteredMessages[index].message,
                        isReady: true,
                        replyMessageUserName: controller
                            .filteredMessages[index].conversation.userName,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  AvatarWithImageOrLetter _buildAvatar(
      bool isMine, ConversationAndMessageModel currentStarred) {
    return AvatarWithImageOrLetter(
      raduis: 16,
      boderThickness: 1,
      borderColor: ChatStyle.ownMessageColor,
      userName: isMine
          ? SharedPref.currentUserName ?? AppLocalization.you.tr
          : currentStarred.conversation.userName,
      imageUrl: isMine
          ? SharedPref.currentUserImageUrl
          : currentStarred.conversation.userImageUrl,
      userId: isMine
          ? SharedPref.currentUserId ?? -1
          : currentStarred.conversation.userId,
      showImageOnPress: false,
    );
  }

  InkWell _buildForwardIcon(int index) {
    return InkWell(
      onTap: () => controller.goToConversationScreenWithStarredMessageIndex(
        index,
      ),
      child: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
      ),
    );
  }
}
