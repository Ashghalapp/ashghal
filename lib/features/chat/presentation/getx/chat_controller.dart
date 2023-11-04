import 'dart:async';

import 'package:ashghal_app_frontend/app_live_cycle_controller.dart';
import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/core/services/dependency_injection.dart'
    as di;
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/users_state_controller.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_last_message_and_count_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_with_count_and_last_message.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/participant_model.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/conversation_and_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/matched_conversation_and_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/block_unblock_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/start_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/block_unblock_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/conversation_messages_read.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/delete_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/get_all_blocked_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/get_all_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/get_all_conversations_with_last_message_and_count.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/get_starred_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/search_in_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/start_conversation_with.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/subscribe_to_chat_channels.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/synchronize_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/toggle_archive_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/toggle_favorite_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/unsubscribe_from_chat_channels.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_all_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversations_last_message_and_count.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/streames_manager.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

enum ChatFilters { all, recentMessages, active, favorite, archived }

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
      case ChatFilters.archived:
        return AppLocalization.archived;
    }
  }
}

class ChatController extends GetxController {
  RxList<ConversationWithCountAndLastMessage> conversations =
      <ConversationWithCountAndLastMessage>[].obs;

  UsersStateController stateController = Get.find();
  AppLifeCycleController lifeCycleController = Get.find();
  StreamSubscription<List<LocalConversation>>? subscription;
  RxList<int> typingUsers = <int>[].obs;
  final StreamsManager streamsManager = StreamsManager();

  int get getNewMessagesCount {
    return conversations.fold<int>(
      0,
      (sum, conversation) {
        if (conversation.conversation.isArchived ||
            conversation.conversation.isBlocked ||
            conversation.conversation.isDeletedLocally) {
          return sum;
        }
        return sum + conversation.newMessagesCount;
      },
    );
  }

  int get getConversationsWithNewMessagesCount {
    return conversations.fold<int>(
      0,
      (sum, conversation) {
        if (conversation.conversation.isArchived ||
            conversation.conversation.isBlocked ||
            conversation.conversation.isDeletedLocally) {
          AppPrint.printWarning(
              "Conversation ${conversation.conversation.remoteId} doesn't satisfied condition");
          return sum;
        }
        return sum + (conversation.newMessagesCount > 0 ? 1 : 0);
      },
    );
  }

  RxBool isLoaing = false.obs;

  bool isSubscribed = false;

  @override
  void onInit() {
    super.onInit();

    // WatchAllConversations watchAllConversations = di.getIt();
    // conversations.bindStream(watchAllConversations.call());
    getAllConversationsWithLastMessageAndCount().then(
      (_) {
        _syncronizeConversations();
        lifeCycleController.isAppResumed.listen((value) async {
          if (!isSubscribed && value) {
            await _syncronizeConversations();
            // await subscribeToOnlineUsersChannel();
          } else if (isSubscribed && !value) {
            await unsubscribeFromChatChannels();
          }
          AppPrint.printInfo(
              "Listener on ChatController got isAppResumed:$value");
        });
        AppServices.networkInfo.onStatusChanged.listen(
          (isConected) async {
            if (isConected) {
              AppPrint.printInfo(
                  "/////////////////////////_syncronizeConversations Network Connects//////////////////");
              // if (!isSubscribed) {
              await _syncronizeConversations();
              // }
            } else {
              await unsubscribeFromChatChannels();
              // isSubscribed = false;
              AppPrint.printInfo(
                  "/////////////////////////_syncronizeConversations Network Disconnects//////////////////");
            }
          },
        );
      },
    );
    AppPrint.printInfo("On init started");
    _listenToConversations();
    _listenToConversationsLastMessageAndCount();
  }

  Future<void> getAllConversations() async {
    GetAllConversationsUseCase useCase = di.getIt();
    (await useCase.call()).fold(
      (failure) => {},
      (localConversations) {
        for (var localConversation in localConversations) {
          _insertOrReplaceLocalConversation(localConversation);
        }
      },
    );
    isLoaing.value = false;
  }

  Future<void> getAllConversationsWithLastMessageAndCount() async {
    isLoaing.value = true;
    GetAllConversationsWithLastMessageAndCountUseCase useCase = di.getIt();
    (await useCase.call()).fold(
      (failure) {
        AppUtil.buildErrorDialog(failure.message);
      },
      (localConversations) {
        sortMessage(localConversations);
        conversations.addAll(localConversations);
        // getConversationsWithNewMessagesCount
        // for (var c in localConversations) {
        //   newMessagesCount.value += c.newMessagesCount;
        //   conversationsWithNewMessages.value += c.newMessagesCount > 0 ? 1 : 0;
        // }
        // for (var localConversation in localConversations) {
        // _insertOrReplaceLocalConversation(localConversation);
        // }
      },
    );
    isLoaing.value = false;
  }

  sortMessage(List<ConversationWithCountAndLastMessage> unsortedConversations) {
    unsortedConversations.sort((a, b) {
      final lastMessageA = a.lastMessage;
      final lastMessageB = b.lastMessage;

      if (lastMessageA != null && lastMessageB != null) {
        // Both conversations have last messages, so compare them by createdAt.
        return lastMessageB.createdAt.compareTo(lastMessageA.createdAt);
      } else if (lastMessageA != null && lastMessageB == null) {
        // Conversation A has a last message, but B doesn't.
        return -1; // Place A before B.
      } else if (lastMessageB != null && lastMessageA == null) {
        // Conversation B has a last message, but A doesn't.
        return 1; // Place B before A.
      } else {
        // Both conversations don't have last messages, so compare them by updatedAt.
        return b.conversation.updatedAt.compareTo(a.conversation.updatedAt);
      }
    });
  }

  Future<void> _syncronizeConversations() async {
    // isSubscribed = true;
    if (await AppServices.networkInfo.isConnected) {
      SynchronizeConversations synchronizeConversations = di.getIt();
      synchronizeConversations.call().then(
        (value) async {
          AppPrint.printInfo("Subscribtion state $isSubscribed");
          // if (!isSubscribed) {
          _subscribeToChatEventsChannels().then((value) => isSubscribed = true);

          // }
        },
      );
    }
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

  void _listenToConversations() async {
    WatchAllConversations watchAllConversations = di.getIt();
    // var oldSubscription = subscription;
    // if (oldSubscription != null) {
    //   await oldSubscription.cancel();
    //   AppPrint.printInfo("Old subscribtion canceled");
    // }
    streamsManager.listenToConversationsStream(watchAllConversations.call(),
        (localConversations) {
      AppPrint.printInfo(
          "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to conversations got updates :${localConversations.length}");
      for (var localConversation in localConversations) {
        // AppPrint.printData(localConversation.toString());
        _insertOrReplaceLocalConversation(localConversation);
      }
    });

    // subscription = watchAllConversations.call().listen((localConversations) {
    //   AppPrint.printInfo(
    //       "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to conversations got updates :${localConversations.length}");
    //   for (var localConversation in localConversations) {
    //     AppPrint.printData(localConversation.toString());
    //     _insertOrReplaceLocalConversation(localConversation);
    //   }
    //   isLoaing.value = false;
    // });
  }

  void _insertOrReplaceLocalConversation(LocalConversation conversation) {
    int index = conversations.indexWhere(
        (element) => element.conversation.localId == conversation.localId);
    if (index == -1) {
      conversations.insert(
        0,
        ConversationWithCountAndLastMessage(
          conversation: conversation,
        ),
      );
    } else {
      ConversationWithCountAndLastMessage updatedConversation =
          conversations[index].copyWith(
        conversation: conversation,
      );
      conversations.removeAt(index);
      conversations.insert(0, updatedConversation);
    }
    filteredConversations.refresh();
  }

  void _listenToConversationsLastMessageAndCount() {
    // AppPrint.printInfo(
    //     "_listenToConversationsLastMessageAndCount on chat controller started");
    WatchConversationsLastMessageAndCountUseCase useCase = di.getIt();
    streamsManager.listenToConversationsLastMessageAndCountStream(
        useCase.call(), (lastMessagesAndCounts) {
      AppPrint.printInfo(
          "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to conversations last message and count got updates :${lastMessagesAndCounts.length}");
      for (var lastMessageAndCount in lastMessagesAndCounts) {
        _insertOrReplaceConversationLastMessageAndCount(
          lastMessageAndCount as ConversationLastMessageAndCountModel,
        );
      }
    });
    // useCase.call().listen(
    //   (lastMessagesAndCounts) {
    //     AppPrint.printInfo(
    //         "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to conversations last message and count got updates :${lastMessagesAndCounts.length}");
    //     for (var lastMessageAndCount in lastMessagesAndCounts) {
    //       _insertOrReplaceConversationLastMessageAndCount(
    //         lastMessageAndCount as ConversationLastMessageAndCountModel,
    //       );
    //     }
    //   },
    // );
  }

  void deleteConversationsLastMessageAndCount(int conversationLocalId) {
    int index = conversations.indexWhere(
      (element) => element.conversation.localId == conversationLocalId,
    );

    AppPrint.printInfo("Clear chat coversation idex ${index}");
    if (index != -1) {
      conversations[index] = ConversationWithCountAndLastMessage(
        conversation: conversations[index].conversation,
      );
    }
  }

  void _insertOrReplaceConversationLastMessageAndCount(
      ConversationLastMessageAndCountModel lMsgCnt) {
    int index = conversations.indexWhere((element) =>
        element.conversation.localId == lMsgCnt.lastMessage.conversationId);
    if (index != -1) {
      conversations[index] = conversations[index].copyWith(
        lastMessage: lMsgCnt.lastMessage,
        newMessagesCount: lMsgCnt.newMessagesCount,
      );
      filteredConversations.refresh();
    } else {}
  }

  Future<LocalConversation?> startConversationWith(
      ParticipantModel user) async {
    StartConversationRequest request = StartConversationRequest(
      userId: user.id,
      userName: user.name,
      userEmail: user.email,
      userImageUrl: user.imageUrl,
      userPhone: user.phone,
    );
    StartConversationWithUseCase useCase = di.getIt();
    return (await useCase.call(request)).fold(
      (failure) {
        AppUtil.buildErrorDialog(failure.message);
        return null;
      },
      (success) {
        return success;
      },
    );
  }

  Future<void> deleteConversations(List<int> conversationsLocalIds) async {
    DeleteConversationUseCase deleteConversationUseCase = di.getIt();
    (await deleteConversationUseCase(conversationsLocalIds)).fold(
      (failure) {
        AppUtil.showMessage(
            AppLocalization.conversationDeletedFail.tr, Colors.red);
      },
      (success) {
        if (success) {
          conversations.removeWhere((element) =>
              conversationsLocalIds.contains(element.conversation.localId));

          filteredConversations.refresh();
          AppUtil.showMessage(
              AppLocalization.conversationDeletedSuccess.tr, Colors.green);
        } else {
          AppUtil.showMessage(
              AppLocalization.conversationDeletedFail.tr, Colors.red);
        }
      },
    );
  }

  Future<void> toggleFavoriteConversation(int conversationLocalId) async {
    bool? favorite = conversations
        .firstWhereOrNull(
            (element) => element.conversation.localId == conversationLocalId)
        ?.conversation
        .isFavorite;
    if (favorite == null) {
      return;
    }
    ToggleFavoriteConversationUseCase useCase = di.getIt();
    (await useCase.call(conversationLocalId, !favorite)).fold(
      (failure) {
        if (favorite) {
          AppUtil.showMessage(
              AppLocalization.failToUnfavoriteConversation.tr, Colors.red);
        } else {
          AppUtil.showMessage(
              AppLocalization.failToFavoriteConversation.tr, Colors.red);
        }
      },
      (success) {
        if (success) {
          if (favorite) {
            AppUtil.showMessage(
                AppLocalization.successToUnfavoriteConversation.tr,
                Colors.blue);
          } else {
            AppUtil.showMessage(
                AppLocalization.successToFavoriteConversation.tr, Colors.blue);
          }
        } else {
          if (favorite) {
            AppUtil.showMessage(
                AppLocalization.failToUnfavoriteConversation.tr, Colors.red);
          } else {
            AppUtil.showMessage(
                AppLocalization.failToFavoriteConversation.tr, Colors.red);
          }
        }
      },
    );
  }

  Future<void> toggleArchiveConversation(int conversationLocalId) async {
    bool? archived = conversations
        .firstWhereOrNull(
            (element) => element.conversation.localId == conversationLocalId)
        ?.conversation
        .isArchived;
    if (archived == null) {
      return;
    }
    ToggleArchiveConversationUseCase useCase = di.getIt();
    (await useCase.call(conversationLocalId, !archived)).fold(
      (failure) {
        if (archived) {
          AppUtil.showMessage(
              AppLocalization.failToUnarchiveConversation.tr, Colors.red);
        } else {
          AppUtil.showMessage(
              AppLocalization.failToArchiveConversation.tr, Colors.red);
        }
      },
      (success) {
        if (success) {
          filteredConversations.refresh();
          if (archived) {
            AppUtil.showMessage(
                AppLocalization.successToUnarchiveConversation.tr, Colors.blue);
          } else {
            AppUtil.showMessage(
                AppLocalization.successToArchiveConversation.tr, Colors.blue);
          }
        } else {
          if (archived) {
            AppUtil.showMessage(
                AppLocalization.failToUnarchiveConversation.tr, Colors.red);
          } else {
            AppUtil.showMessage(
                AppLocalization.failToArchiveConversation.tr, Colors.red);
          }
        }
      },
    );
  }

  Future<void> blockConversation(int conversationLocalId) async {
    int index = conversations.indexWhere(
      (element) => element.conversation.localId == conversationLocalId,
    );
    if (conversations[index].conversation.remoteId != null) {
      await toggleBlockConversation(
        conversations[index].conversation.remoteId!,
        true,
      );
    } else {
      AppUtil.showMessage(
          AppLocalization.failToBlockConversation.tr, Colors.red);
    }
  }

  Future<bool> unblockConversation(int conversationRemoteId) async {
    // int index = conversations.indexWhere(
    //   (element) => element.conversation.localId == conversationLocalId,
    // );
    // if (conversations[index].conversation.remoteId != null) {
    return await toggleBlockConversation(
      conversationRemoteId,
      false,
    );
    // } else {
    //   AppUtil.showMessage(
    //       AppLocalization.failToBlockConversation.tr, Colors.red);
    // }
  }

  Future<bool> toggleBlockConversation(
      int conversationRemoteId, bool blockConversation) async {
    if (await AppServices.networkInfo.isConnected) {
      BlockUnblockConversationRequest request = BlockUnblockConversationRequest(
        conversationRemoteId: conversationRemoteId,
        block: blockConversation,
      );
      BlockUnblockConversationUseCase useCase = di.getIt();
      return (await useCase(request)).fold<bool>(
        (failure) {
          if (blockConversation) {
            AppUtil.showMessage(
              AppLocalization.failToBlockConversation.tr,
              Colors.red,
            );
          } else {
            AppUtil.showMessage(
              AppLocalization.failToUnblockConversation.tr,
              Colors.red,
            );
          }
          return false;
        },
        (success) {
          if (success) {
            if (blockConversation) {
              conversations.removeWhere((element) =>
                  element.conversation.remoteId == conversationRemoteId);
              AppUtil.showMessage(
                  AppLocalization.conversationBlockedsuccess.tr, Colors.red);
            } else {
              AppUtil.showMessage(
                  AppLocalization.conversationUnblockedsuccess.tr, Colors.red);
            }
          }
          return true;
        },
      );
    } else {
      AppUtil.showMessage(ErrorString.OFFLINE_ERROR.tr, Colors.red);
      return false;
    }
  }

  Future<void> markConversationMessagesAsRead(int conversationId) async {
    ConversationMessagesReadUseCase conversationMessagesRead = di.getIt();
    conversationMessagesRead.call(conversationId);
  }

  Future<void> unsubscribeFromChatChannels() async {
    isSubscribed = false;
    UnsubscribeFromRemoteChannelsUseCase useCase = di.getIt();
    await useCase.call();
    print("Unsubscribed from chat channels");
  }

  @override
  void onClose() {
    unsubscribeFromChatChannels();
    streamsManager.cancelConversationsListener();
    streamsManager.cancelToConversationsLastMessageAndCountListener();
    super.onClose();
  }

  //============================ Start filters section ============================//

  Rx<ChatFilters> appliedFilter = ChatFilters.all.obs;

  RxList<ConversationWithCountAndLastMessage> get filteredConversations {
    switch (appliedFilter.value) {
      case ChatFilters.all:
        return conversations
            .where((c) => !c.conversation.isArchived)
            .toList()
            .obs;
      case ChatFilters.recentMessages:
        return conversations
            .where((c) =>
                c.lastMessage != null &&
                c.newMessagesCount > 0 &&
                !c.conversation.isArchived)
            .toList()
            .obs;
      case ChatFilters.active:
        _startOnlineUsersStreamListenerToRefershfilteredData();
        return conversations
            .where(
              (c) =>
                  Get.find<UsersStateController>()
                      .onlineUsersIds
                      .contains(c.conversation.userId) &&
                  !c.conversation.isArchived,
            )
            .toList()
            .obs;
      case ChatFilters.favorite:
        return conversations
            .where(
              (c) => c.conversation.isFavorite && !c.conversation.isArchived,
            )
            .toList()
            .obs;
      case ChatFilters.archived:
        return conversations
            .where(
              (c) => c.conversation.isArchived,
            )
            .toList()
            .obs;
      default:
        return conversations;
    }
  }

  void _startOnlineUsersStreamListenerToRefershfilteredData() {
    Get.find<UsersStateController>().onlineUsersStream.listen(
      (event) {
        if (appliedFilter.value == ChatFilters.active) {
          filteredConversations.refresh();
        }
      },
    );
  }

  void applyFilter(ChatFilters filter) {
    if (filter != appliedFilter.value) {
      appliedFilter.value = filter;
      filteredConversations.refresh();
    }
  }
  //============================ End filters section =============================//
  //==============================================================================//
  //============================ Start search section ============================//

  RxList<LocalMessage> searchMatchedMessages = <LocalMessage>[].obs;

  RxString searchText = "".obs;

  RxList<MatchedConversationsAndMessage> get searchMatchedConversationMessages {
    RxList<MatchedConversationsAndMessage> matched =
        <MatchedConversationsAndMessage>[].obs;
    for (var message in searchMatchedMessages) {
      int index = conversations
          .indexWhere((c) => c.conversation.localId == message.conversationId);
      if (index != -1) {
        matched.add(MatchedConversationsAndMessage(
          conversation: conversations[index].conversation,
          message: message,
        ));
      }
    }
    return matched;
  }

  RxList<ConversationWithCountAndLastMessage> get searchMatchedConversations {
    if (searchText.value.trim() == "") {
      return <ConversationWithCountAndLastMessage>[].obs;
    } else {
      return conversations
          .where((c) => c.conversation.userName
              .toLowerCase()
              .contains(searchText.value.toLowerCase()))
          .toList()
          .obs;
    }
  }

  Future<void> searchInConversations(String searchText) async {
    print("Search starrted");
    print(searchText);
    this.searchText.value = searchText;
    searchMatchedConversations.refresh();
  }

  Future<void> searchInMessages(String searchText) async {
    if (searchText.trim() == "") {
      searchMatchedMessages.clear();
      searchMatchedConversationMessages.refresh();
    } else {
      SearchInMessagesUseCase useCase = di.getIt();
      (await useCase(searchText)).fold(
        (failure) {
          searchMatchedMessages.clear();

          AppUtil.showMessage(
            AppLocalization.conversationDeletedFail.tr,
            Colors.red,
          );
        },
        (matchedData) {
          AppPrint.printInfo(
              "Search Finished with Success ${matchedData.length}");

          searchMatchedMessages.clear();

          searchMatchedMessages.addAll(matchedData);
          searchMatchedConversationMessages.refresh();
        },
      );
    }
  }

  //============================ End search section ============================//

  Future<List<ConversationAndMessageModel>> fetchAllStarredMessages() async {
    GetStarredMessagesUseCase useCase = di.getIt();
    return (await useCase()).fold<List<ConversationAndMessageModel>>(
      (failure) {
        AppUtil.showMessage(
            AppLocalization.failureShwoingStarredMessages.tr, Colors.red);
        return [];
      },
      (starredMessages) {
        AppPrint.printInfo("Got ${starredMessages.length} starred messages");
        List<ConversationAndMessageModel> messages = [];
        for (var starredMessage in starredMessages) {
          LocalConversation? conversation = conversations
              .firstWhereOrNull(
                (element) =>
                    element.conversation.localId ==
                    starredMessage.message.conversationId,
              )
              ?.conversation;
          if (conversation == null) {
            continue;
          }
          messages.add(
            ConversationAndMessageModel(
              message: starredMessage,
              conversation: conversation,
            ),
          );
        }
        return messages;
      },
    );
  }

  Future<List<LocalConversation>> fetchAllBlockedConversations() async {
    GetAllBlockedConversationsCountUseCase useCase = di.getIt();
    return (await useCase.call()).fold<List<LocalConversation>>(
      (failure) {
        AppUtil.showMessage(
            AppLocalization.failureShwoingStarredMessages.tr, Colors.red);
        return [];
      },
      (blockedConversations) {
        return blockedConversations;
      },
    );
  }
}
