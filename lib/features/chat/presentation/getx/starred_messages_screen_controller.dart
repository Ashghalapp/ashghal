import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/conversation_and_message.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum StarredMessagesFilters {
  all,
  mine,
  others,
}

extension StarredMessagesFiltersExtension on StarredMessagesFilters {
  String get value {
    switch (this) {
      case StarredMessagesFilters.all:
        return AppLocalization.all;
      case StarredMessagesFilters.mine:
        return AppLocalization.mine;
      case StarredMessagesFilters.others:
        return AppLocalization.others;
    }
  }
}

class StarredMessagesScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;
  RxBool isSearchTextEmpty = true.obs;
  RxList<ConversationAndMessageModel> _starredMessages =
      <ConversationAndMessageModel>[].obs;

  Rx<StarredMessagesFilters> appliedFilter = StarredMessagesFilters.all.obs;
  final TextEditingController searchTextEdittingController =
      TextEditingController();

  final ChatController chatController = Get.find();
  final ChatScreenController screenController = Get.find();

  final FocusNode searchFeildFocusNode = FocusNode();

  @override
  void onInit() {
    _fetchAllStarredMessages();
    super.onInit();
  }

  List<ConversationAndMessageModel> get filteredMessages {
    if (isSearching.value && searchTextEdittingController.text.trim() != "") {
      AppPrint.printInfo("filteredMessages refersh with search mode");
      return _starredMessages
          .where((c) =>
              c.message.message.body != null &&
              c.message.message.body!.toLowerCase().contains(
                  searchTextEdittingController.text.trim().toLowerCase()))
          .toList();
    }
    switch (appliedFilter.value) {
      case StarredMessagesFilters.mine:
        return _starredMessages
            .where(
                (c) => c.message.message.senderId == SharedPref.currentUserId)
            .toList();
      case StarredMessagesFilters.others:
        return _starredMessages
            .where(
                (c) => c.message.message.senderId != SharedPref.currentUserId)
            .toList();
      default:
        return _starredMessages.value;
    }
  }

  void applyFilter(StarredMessagesFilters filter) {
    if (filter != appliedFilter.value) {
      appliedFilter.value = filter;
    }
  }

  void refreshStarredMessages() async {
    _starredMessages.clear();
    await _fetchAllStarredMessages();
    _starredMessages.refresh();
  }

  Future<void> _fetchAllStarredMessages() async {
    isLoading.value = true;
    _starredMessages.addAll(await chatController.fetchAllStarredMessages());

    isLoading.value = false;
  }

  goToConversationScreenWithStarredMessageIndex(int index) {
    screenController.goToConversationScreen(
      _starredMessages[index].conversation,
      _starredMessages[index].message.message,
    );
    // Get.delete<();
  }

  void toggleSearchMode() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      isSearchTextEmpty.value = true;
      searchTextEdittingController.text = "";
    } else {
      searchFeildFocusNode.requestFocus();
    }
  }

  onSearchTextFieldChanges(String value) {
    if (value.trim() == "") {
      isSearchTextEmpty.value = true;
    } else {
      isSearchTextEmpty.value = false;
    }
    // filteredMessages.refresh();
    _starredMessages.refresh();
  }

  void clearSearchField() {
    isSearchTextEmpty.value = true;
    searchTextEdittingController.text = "";
    _starredMessages.refresh();
  }

  Future<bool> onBackButtonPressed() {
    if (isSearching.value) {
      toggleSearchMode();
      return Future.value(false);
    }
    return Future.value(true);
  }
}
