import 'dart:async';

import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/block_unblock_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/clear_chat_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_messages_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/dispatch_typing_event_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/download_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/upload_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/block_unblock_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/clear_chat.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/confirm_message_read.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/conversation_messages_read.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/delete_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/dispatch_typing_event.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/download_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/get_conversation_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/get_conversation_messages_with_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/send_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/toggle_star_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/upload_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversation_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversation_messages_multimedia.dart';
import 'package:ashghal_app_frontend/core/services/dependency_injection.dart'
    as di;
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/streames_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationController extends GetxController {
  RxList<MessageAndMultimediaModel> messages =
      <MessageAndMultimediaModel>[].obs;

  int get conversationId => currentConversation.localId;
  final LocalConversation currentConversation;
  ConversationController({required this.currentConversation});
  final StreamsManager streamsManager = StreamsManager();
  RxBool isLoading = false.obs;
  // final RemoteMessageService messageService = RemoteMessageService.create();
  // final RemoteMessageConfirmationService confirmationService =
  //     RemoteMessageConfirmationService.create();

  @override
  void onInit() {
    super.onInit();
    // di.setupChatDependencies();
// WatchConversationMessagesMultimediaUseCase usecase =di.getIt();
// messages.bindStream(usecase.call(conversationId))
    markConversationMessagesAsRead();
    _getAllMessagesWithMultimedia().then((value) {});
    _listenToAllMessages();
    _listenToMultimedia();
  }

  Future<void> markConversationMessagesAsRead() async {
    // print("Conversation ID" + conversationId.toString());
    ConversationMessagesReadUseCase conversationMessagesRead = di.getIt();
    conversationMessagesRead.call(conversationId);
    // .then((value) {
    //   _getAllMessages().then((value) {
    //     _listenToMultimedia();
    //     _listenToAllMessages();
    //   });
    // });
  }

    Future<void> markMessageAsRead(LocalMessage message) async {
    // print("Conversation ID" + conversationId.toString());
    ConfirmMessageReadUseCase conversationMessagesRead = di.getIt();
   await conversationMessagesRead.call(message);
    // .then((value) {
    //   _getAllMessages().then((value) {
    //     _listenToMultimedia();
    //     _listenToAllMessages();
    //   });
    // });
  }

  Future<void> _getAllMessages() async {
    isLoading.value = true;
    // print("Conversation ID" + conversationId.toString());
    GetConversationMessagesUsecase usecase = di.getIt();
    (await usecase(conversationId)).fold((l) {}, (localMessages) {
      for (var localMessage in localMessages) {
        _insertOrReplaceMessage(localMessage);
      }
      isLoading.value = false;
    });
  }

  Future<void> _getAllMessagesWithMultimedia() async {
    isLoading.value = true;
    // print("Conversation ID" + conversationId.toString());
    GetConversationMessagesWithMultimediaUsecase usecase = di.getIt();
    (await usecase(conversationId)).fold((failure) {
      AppUtil.buildErrorDialog(failure.message);
    }, (messagesWithMultimedia) {
      // AppPrint.printInfo("got messages :${messagesWithMultimedia.length}");
      messages.insertAll(0, messagesWithMultimedia);
      // for (var localMessage in localMessages) {
      //   _insertOrReplaceMessage(localMessage);
      // }
      isLoading.value = false;
    });
  }

  void _listenToAllMessages() {
    WatchConversationMessages watchConversationMessages = di.getIt();
    streamsManager.listenAllMessagesStream(
        watchConversationMessages.call(conversationId), (localMessages) {
      AppPrint.printInfo(
          "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to messages got updates :${localMessages.length}");
      // print(
      // "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to messages got updates :${localMessages.length}");
      for (var localMessage in localMessages) {
        // AppPrint.printData(localMessage.toString());
        _insertOrReplaceMessage(localMessage);
      }
    });

    // watchConversationMessages.call(conversationId).listen((localMessages) {
    //   AppPrint.printInfo(
    //       "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to messages got updates :${localMessages.length}");
    //   // print(
    //   // "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to messages got updates :${localMessages.length}");
    //   for (var localMessage in localMessages) {
    //     _insertOrReplaceMessage(localMessage);
    //   }
    // });
  }

  void _listenToMultimedia() {
    WatchConversationMessagesMultimediaUseCase useCase = di.getIt();
    streamsManager.listenMessagesAndMultimediaStream(
        useCase.call(conversationId), (messagesAndMultimedia) {
      AppPrint.printInfo(
          "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to Multimedia got updates :${messagesAndMultimedia.length}");

      for (var msgAndMul in messagesAndMultimedia) {
        // AppPrint.printData(msgAndMul.toString());
        _insertOrReplaceMultimediaAndMessage(msgAndMul);
      }
    });
    // useCase.call(conversationId).listen((messagesAndMultimedia) {
    //   AppPrint.printInfo(
    //       "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to Multimedia got updates :${messagesAndMultimedia.length}");

    //   for (var msgAndMul in messagesAndMultimedia) {
    //     // AppPrint.printData(msgAndMul.toString());
    //     _insertOrReplaceMultimediaAndMessage(msgAndMul);
    //   }
    // });
  }

  void _insertOrReplaceMessage(LocalMessage message) {
    int index = messages
        .indexWhere((element) => element.message.localId == message.localId);
    if (index == -1) {
      if(message.readAt==null){
        markMessageAsRead(message);
      }else{
      messages.insert(
          0, MessageAndMultimediaModel(message: message, multimedia: null));
      }


    } else {
      messages[index] = messages[index].copyWith(message: message);
    }
  }

  void _insertOrReplaceMultimediaAndMessage(
      MessageAndMultimediaModel msgAndMul) {
    int index = messages.indexWhere(
        (element) => element.message.localId == msgAndMul.message.localId);
    if (index == -1) {
      // AppPrint.printInfo("Inserted");
      if(msgAndMul.message.readAt==null){
        markMessageAsRead(msgAndMul.message);
      }else{
messages.insert(0, msgAndMul);
      }
      
      // messages.add(
      //   MessageAndMultimediaModel(
      //     //we added a random message object with the real localId, and it will be replaced with the real message object when it comes in the messages listner
      //     message: LocalMessage(
      //       localId: multimedia.messageId,
      //       senderId: -1,
      //       conversationId: conversationId,
      //       receivedLocally: false,
      //       readLocally: false,
      //       createdAt: DateTime.now(),
      //       updatedAt: DateTime.now(),
      //     ),
      //     multimedia: multimedia,
      //   ),
      // );
    } else {
      // print("multimedia ${multimedia.toString()}");
      // messages.replaceRange(index, index + 1, [msgAndMul]);
      messages[index] = msgAndMul;
    }
    // messages.refresh();
  }

  Future<void> dispatchTypingEvent(TypingEventType eventType) async {
    if (currentConversation.remoteId != null) {
      DispatchTypingEventUseCase useCase = di.getIt();
      await useCase.call(
        DispatchTypingEventRequest(
          conversationId: currentConversation.remoteId!,
          eventType: eventType,
        ),
      );
    }
  }

  Future<void> sendMessage(SendMessageRequest request) async {
    // print("Request Sent");
    SendMessageUseCase sendMessageUseCase = di.getIt();
    (await sendMessageUseCase.call(request)).fold(
      (failure) {
        // print("Request Fail${failure.message}");
      },
      (localMessage) {
        // print("request success$localMessage");
      },
    );
    // print("Request Finished");
  }

  Future<bool> download(DownloadRequest request) async {
    print("download Request Sent");
    DownloadMultimediaUseCase useCase = di.getIt();
    return (await useCase.call(request)).fold<bool>(
      (failure) {
        print("download Request Fail ${failure.message}");
        //     AppUtil.hanldeAndShowFailure(
        // const NotSpecificFailure(message: "Downloading fails"));
        if (request.cancelToken != null && !request.cancelToken!.isCancelled) {
          AppUtil.hanldeAndShowFailure(failure);
        }
        return false;
      },
      (state) {
        print("download request success");
        return state;
      },
    );
    // // print("Request Finished");
  }

  Future<bool> upload(UploadRequest request) async {
    print("upload Request Sent");
    UploadMultimediaUseCase useCase = di.getIt();
    return (await useCase.call(request)).fold<bool>(
      (failure) {
        print("upload Request Fail ${failure.message}");
        if (request.cancelToken != null && !request.cancelToken!.isCancelled) {
          AppUtil.hanldeAndShowFailure(failure);
        }

        return false;
      },
      (state) {
        print("upload request success");
        return state;
      },
    );
    // print("upload Request Finished");
    // return false;
  }

  // Future<void> sendMessage(SendMessageRequest request) async {
  //   // isloading.value = true;
  //   try {
  //     SendMessageUseCase sendMessage = di.getIt();
  //     (await sendMessage(request)).fold(
  //       (r) => null,
  //       (l) {},
  //     );
  //   } catch (e) {
  //     // showErrorDialog(e.toString());
  //   }
  //   // isloading.value = false;
  // }

  Future<void> clearChat() async {
    ClearChatUseCase useCase = di.getIt();
    (await useCase.call(ClearChatRequest(conversationLocalId: conversationId)))
        .fold(
      (failure) {
        //
      },
      (success) {
        messages.clear();
      },
    );
  }

  Future<void> deleteMessages(List<int> messagesIds) async {
    DeleteMessagesUseCase useCase = di.getIt();
    (await useCase.call(DeleteMessagesRequest(messagesIds: messagesIds))).fold(
      (failure) {
        //
      },
      (success) {
        messages.removeWhere(
            (element) => messagesIds.contains(element.message.localId));
      },
    );
  }

  Future<void> blockConversation() async {
    ChatController chatController = Get.find();
    await chatController.blockConversation(conversationId);
    // _toggleBlockConversation(
    //   BlockUnblockConversationRequest(
    //     conversationRemoteId: conversationId,
    //     block: true,
    //   ),
    // );
  }

  Future<void> unblockConversation() async {
    if (currentConversation.remoteId != null) {
      ChatController chatController = Get.find();
      await chatController.unblockConversation(currentConversation.remoteId!);
    } else {
      AppUtil.buildErrorDialog(AppLocalization.failToUnblockConversation.tr);
    }

    // _toggleBlockConversation(
    //   BlockUnblockConversationRequest(
    //     conversationRemoteId: conversationId,
    //     block: true,
    //   ),
    // );
  }

  // Future<void> unblockConversation() async {
  //   _toggleBlockConversation(
  //     BlockUnblockConversationRequest(
  //       conversationId: conversationId,
  //       block: false,
  //     ),
  //   );
  // }

  // Future<void> _toggleBlockConversation(
  //     BlockUnblockConversationRequest request) async {
  //   BlockUnblockConversationUseCase useCase = di.getIt();
  //   (await useCase(request)).fold(
  //     (failure) => {
  //       //
  //     },
  //     (success) {
  //       if (success) {
  //         //
  //       }
  //     },
  //   );
  // }

  @override
  void onClose() {
    // textEditingController.dispose();
    streamsManager.cancelAllMessagesListener();
    streamsManager.cancelMessagesAndMultimediaListener();
    super.onClose();
  }

  // toggleStarMessage(int selectedMessagesId) {}

  Future<void> toggleStarMessage(int messageLocalId) async {
    LocalMessage? message = messages
        .firstWhereOrNull(
            (element) => element.message.localId == messageLocalId)
        ?.message;

    if (message == null) {
      // isStarred = message?.isStarred;
      return;
    }
    bool isStarred = message.isStarred;
    ToggleStarMessageUseCase useCase = di.getIt();
    (await useCase.call(messageLocalId, !isStarred, message.conversationId))
        .fold(
      (failure) {
        if (isStarred) {
          AppUtil.showMessage(
              AppLocalization.failToUnstarMessage.tr, Colors.red);
        } else {
          AppUtil.showMessage(AppLocalization.failToStarMessage.tr, Colors.red);
        }
      },
      (success) {
        if (success) {
          if (isStarred) {
            AppUtil.showMessage(
                AppLocalization.successToUnstarMessage.tr, Colors.blue);
          } else {
            AppUtil.showMessage(
                AppLocalization.successToStarMessage.tr, Colors.blue);
          }
        } else {
          if (isStarred) {
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
}
