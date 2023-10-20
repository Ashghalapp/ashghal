import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/core/services/dependency_injection.dart'
    as di;
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/core_api/users_state_controller.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_last_message_and_count_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_with_count_and_last_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/matched_conversation_and_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/start_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/delete_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/get_all_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/search_in_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/start_conversation_with.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/subscribe_to_chat_channels.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/synchronize_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/unsubscribe_from_chat_channels.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_all_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversations_last_message_and_count.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

enum ChatFilters {
  all,
  recentMessages,
  active,
  favorite,
}

extension ChatFiltersExtension on ChatFilters {
  String get value {
    switch (this) {
      case ChatFilters.all:
        return AppLocalization.all;
      case ChatFilters.recentMessages:
        return AppLocalization.recentMessages;
      case ChatFilters.active:
        return AppLocalization.active;
      case ChatFilters.favorite:
        return AppLocalization.favorite;
    }
  }
}

class ChatController extends GetxController {
  RxList<ConversationWithCountAndLastMessage> conversations =
      <ConversationWithCountAndLastMessage>[].obs;

  List<LocalMessage> searchMatchedMessages = <LocalMessage>[];

  RxList<ConversationWithCountAndLastMessage> searchMatchedConversations =
      <ConversationWithCountAndLastMessage>[].obs;
  RxList<MatchedConversationsAndMessage> searchMatchedConversationMessages =
      <MatchedConversationsAndMessage>[].obs;
  // String searchText = "";

  // RxList<MatchedConversationsAndMessage> get searchMatchedConversationMessages {
  //   RxList<MatchedConversationsAndMessage> matched =
  //       <MatchedConversationsAndMessage>[].obs;
  //   for (var message in searchMatchedMessages) {
  //     int index = conversations
  //         .indexWhere((c) => c.conversation.localId == message.conversationId);
  //     if (index != -1) {
  //       matched.add(MatchedConversationsAndMessage(
  //         conversation: conversations[index].conversation,
  //         message: message,
  //       ));
  //     }
  //   }
  //   return matched;
  // }

  // RxList<ConversationWithCountAndLastMessage> get searchMatchedConversations {
  //   if (searchText.trim() == "") {
  //     return <ConversationWithCountAndLastMessage>[].obs;
  //   } else {
  //     return conversations
  //         .where((c) => c.conversation.userName.contains(searchText))
  //         .toList()
  //         .obs;
  //   }
  // }

  UsersStateController stateController = Get.find();

  RxList<int> typingUsers = <int>[].obs;

  RxBool isLoaing = false.obs;

  bool isSubscribed = false;

  Rx<ChatFilters> appliedFilter = ChatFilters.all.obs;

  @override
  void onInit() {
    super.onInit();
    isLoaing.value = true;

    AppServices.networkInfo.onStatusChanged.listen((isConected) async {
      if (isConected) {
        print(
            "/////////////////////////_syncronizeConversations Network Connects//////////////////");
        await _syncronizeConversations();
      } else {
        await unsubscribeFromChatChannels();
        isSubscribed = false;
        print(
            "/////////////////////////_syncronizeConversations Network Disconnects//////////////////");
      }
    });

    _listenToConversations();
    _listenToConversationsLastMessageAndCount();
    _syncronizeConversations();
  }

  void _startOnlineUsersListener() {
    stateController.onlineUsersStream.listen(
      (event) {
        if (appliedFilter.value == ChatFilters.active) {
          filteredConversations.refresh();
        }
      },
    );
  }

  RxList<ConversationWithCountAndLastMessage> get filteredConversations {
    switch (appliedFilter.value) {
      case ChatFilters.all:
        return conversations;
      case ChatFilters.recentMessages:
        return conversations
            .where((c) => c.lastMessage != null && c.newMessagesCount > 0)
            .toList()
            .obs;
      case ChatFilters.active:
        _startOnlineUsersListener();
        return conversations
            .where((c) =>
                stateController.onlineUsersIds.contains(c.conversation.userId))
            .toList()
            .obs;
      case ChatFilters.favorite:
        return conversations;
      default:
        return conversations;
    }
  }

  void applyFilter(ChatFilters filter) {
    if (filter != appliedFilter.value) {
      appliedFilter.value = filter;
      filteredConversations.refresh();
    }
  }

  // void _filterData() {

  // }

  Future<void> getAllConversations() async {
    GetAllConversationsUseCase useCase = di.getIt();
    (await useCase.call()).fold(
      (failure) => {},
      (localConversations) {
        for (var localConversation in localConversations) {
          // print(localConversation.toString());
          // print("Listner Data :$localConversation");
          _insertOrReplaceLocalConversation(localConversation);
        }
      },
    );
  }

  Future<void> _syncronizeConversations() async {
    //  _listenToConversations();
    //   _listenToConversationsLastMessageAndCount();
    // GetAllConversationsUseCase getAllConversations = di.getIt();
    // var result = await getAllConversations.call();
    // result.fold((l) => null, (conversations) {
    //   for (var conversation in conversations) {
    //     _insertOrReplaceLocalConversation(conversation);
    //   }
    // });
    // if(await AppServices.networkInfo.isConnected){
    SynchronizeConversations synchronizeConversations = di.getIt();
    await synchronizeConversations.call().then(
      (value) async {
        await _subscribeToChatEventsChannels();
        isSubscribed = true;
      },
    );
    ;
    // }

    // .then((value) async {
    //   _listenToConversations();
    //   _listenToConversationsLastMessageAndCount();
    //   // isLoaing.value = false;

    //   // await getAllConversations();
    // });
    // SynchronizeConversations synchronizeConversations = di.getIt();
    // synchronizeConversations.call().then((value) {
    //   //after syncronizing start listeners
    //   _listenToConversations();
    //   _listenToConversationsLastMessageAndCount();
    // });
  }

  Future<void> _subscribeToChatEventsChannels() async {
    SubscribeToChatChannelsUseCase useCase = di.getIt();
    await useCase.call(
      (TypingEventType eventType, int userId) {
        if (eventType == TypingEventType.start) {
          if (!typingUsers.contains(userId)) {
            typingUsers.add(userId);
          }
        } else {
          typingUsers.remove(userId);
        }
      },
    );
  }

  void _listenToConversations() {
    WatchAllConversations watchAllConversations = di.getIt();
    watchAllConversations.call().listen((localConversations) {
      print(
          "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to conversations got updates :${localConversations.length}");
      for (var localConversation in localConversations) {
        // print(localConversation.toString());
        // print("Listner Data :$localConversation");
        _insertOrReplaceLocalConversation(localConversation);
      }
      isLoaing.value = false;
    });
  }

  void _insertOrReplaceLocalConversation(LocalConversation conversation) {
    int index = conversations.indexWhere(
        (element) => element.conversation.localId == conversation.localId);
    if (index == -1) {
      conversations.add(ConversationWithCountAndLastMessage(
        conversation: conversation,
      ));
    } else {
      conversations[index] = conversations[index].copyWith(
        conversation: conversation,
      );
    }
    filteredConversations.refresh();
  }

  void _listenToConversationsLastMessageAndCount() {
    WatchConversationsLastMessageAndCount watchConversationLastMessageAndCount =
        di.getIt();
    watchConversationLastMessageAndCount().listen((lastMessagesAndCounts) {
      print(
          "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to conversations last message and count got updates :${lastMessagesAndCounts.length}");
      for (var lastMessageAndCount in lastMessagesAndCounts) {
        _insertOrReplaceConversationLastMessageAndCount(
          lastMessageAndCount as ConversationLastMessageAndCountModel,
        );
      }
    });
  }

  void _insertOrReplaceConversationLastMessageAndCount(
      ConversationLastMessageAndCountModel message) {
    int index = conversations.indexWhere((element) =>
        element.conversation.localId == message.lastMessage.conversationId);
    if (index != -1) {
      conversations[index] = conversations[index].copyWith(
        lastMessage: message.lastMessage,
        newMessagesCount: message.newMessagesCount,
      );
      filteredConversations.refresh();
    } else {}
  }

  Future<void> startConversationWith(int userId) async {
    StartConversationRequest request = StartConversationRequest(userId: userId);
    StartConversationWithUseCase startConversationWith = di.getIt();
    (await startConversationWith(request)).fold(
      (failure) {},
      (r) => null,
    );
  }

  Future<void> deleteConversation(int conversationId) async {
    // DeleteConversationRequest request = DeleteConversationRequest(
    //   conversationLocalId: conversationId,
    // );
    DeleteConversationUseCase deleteConversationUseCase = di.getIt();
    (await deleteConversationUseCase(conversationId)).fold(
      (failure) {
        AppUtil.showMessage(
            AppLocalization.conversationDeletedFail.tr, Colors.red);
      },
      (success) {
        if (success) {
          conversations.removeWhere(
            (element) => element.conversation.localId == conversationId,
          );
          filteredConversations.refresh();
          AppUtil.showMessage(
              AppLocalization.conversationDeletedSuccess.tr, Colors.green);

          // int index = conversations.indexWhere(
          //   (element) => element.conversation.localId == conversationId,
          // );
          // if (index != -1) {

          // }
        } else {
          AppUtil.showMessage(
              AppLocalization.conversationDeletedFail.tr, Colors.red);
        }
      },
    );
  }

  Future<void> search(String searchText) async {
    print("Search starrted");
    print(searchText);
    refreshSearchMatchedConversations(searchText);
    SearchInConversationsUseCase useCase = di.getIt();
    (await useCase(searchText)).fold(
      (failure) {
        // print("Search Finished with failure");
        // searchMatchedMessages.clear();
        searchMatchedConversationMessages.clear();

        AppUtil.showMessage(
          AppLocalization.conversationDeletedFail.tr,
          Colors.red,
        );
      },
      (matchedData) {
        print("Search Finished with Success ${matchedData.length}");
        refreshSearchMatchedConversationMessages(matchedData);
        // searchMatchedMessages.clear();

        // searchMatchedMessages.addAll(matchedData);
        // searchMatchedConversationMessages.refresh();
        // List<int> ids = matchedData.map((e) => e.conversation.localId).toList();

        // List<ConversationWithCountAndLastMessage> matchedConversation =
        //     conversations
        //         .where((c) => !ids.contains(c.conversation.localId))
        //         .toList();
        // // .map((e) => e.conversation)
        // // .toList();
        // searchMatchesMessages.insertAll(
        //   0,
        //   matchedConversation.map(
        //     (e) => MatchedConversationsAndMessage(conversation: e.conversation),
        //   ),
        // );
      },
    );
  }

  void refreshSearchMatchedConversations(searchText) {
    if (searchText.trim() == "") {
      searchMatchedConversations.clear();
    } else {
      searchMatchedConversations.clear();
      searchMatchedConversations.addAll(conversations
          .where((c) => c.conversation.userName.contains(searchText))
          .toList());
    }
  }

  void refreshSearchMatchedConversationMessages(List<LocalMessage> messages) {
    searchMatchedConversationMessages.clear();
    for (var message in messages) {
      int index = conversations
          .indexWhere((c) => c.conversation.localId == message.conversationId);
      if (index != -1) {
        searchMatchedConversationMessages.add(
          MatchedConversationsAndMessage(
            conversation: conversations[index].conversation,
            message: message,
          ),
        );
      }
    }
  }

  void stopSearchMode() {
    searchMatchedConversationMessages.clear();
    searchMatchedConversations.clear();
  }

  Future<void> unsubscribeFromChatChannels() async {
    UnsubscribeFromRemoteChannelsUseCase useCase = di.getIt();
    await useCase.call();
  }

  @override
  void onClose() {
    unsubscribeFromChatChannels();
    // AppServices.pusher.unsubscribeFromChannel("presence-chat");
    AppServices.pusher.disconnect();
    super.onClose();
  }
}
