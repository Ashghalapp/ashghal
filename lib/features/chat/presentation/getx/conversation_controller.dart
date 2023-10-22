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
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/conversation_messages_read.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/delete_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/dispatch_typing_event.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/download_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/get_conversation_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/send_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/upload_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversation_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversation_messages_multimedia.dart';
import 'package:ashghal_app_frontend/core/services/dependency_injection.dart'
    as di;
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:get/get.dart';

class ConversationController extends GetxController {
  RxList<MessageAndMultimediaModel> messages =
      <MessageAndMultimediaModel>[].obs;

  late final int conversationId;
  ConversationController({required this.conversationId});

  RxBool isloading = false.obs;
  // final RemoteMessageService messageService = RemoteMessageService.create();
  // final RemoteMessageConfirmationService confirmationService =
  //     RemoteMessageConfirmationService.create();

  @override
  void onInit() {
    super.onInit();
    // di.setupChatDependencies();

    markConversationMessagesAsRead();
    _getAllMessages().then((value) {
      _listenToMultimedia();
      _listenToAllMessages();
    });
    // _listenToAllMessages();
    // _listenToMultimedia();
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

  Future<void> _getAllMessages() async {
    // print("Conversation ID" + conversationId.toString());
    GetConversationMessagesUsecase usecase = di.getIt();
    (await usecase(conversationId)).fold((l) {}, (localMessages) {
      for (var localMessage in localMessages) {
        _insertOrReplaceMessage(localMessage);
      }
    });
  }

  void _listenToAllMessages() {
    WatchConversationMessages watchConversationMessages = di.getIt();
    watchConversationMessages(conversationId).listen((localMessages) {
      print(
          "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to messages got updates :${localMessages.length}");
      for (var localMessage in localMessages) {
        _insertOrReplaceMessage(localMessage);
      }
    });
  }

  void _listenToMultimedia() {
    WatchConversationMessagesMultimediaUseCase useCase = di.getIt();
    useCase(conversationId).listen((localMultimedia) {
      print(
          "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to Multimedia got updates :${localMultimedia.length}");
      for (var multimedia in localMultimedia) {
        _insertOrReplaceMultimedia(multimedia);
      }
    });
  }

  void _insertOrReplaceMessage(LocalMessage message) {
    int index = messages
        .indexWhere((element) => element.message.localId == message.localId);
    if (index == -1) {
      messages.insert(
          0, MessageAndMultimediaModel(message: message, multimedia: null));
    } else {
      messages[index] = messages[index].copyWith(message: message);
    }
  }

  void _insertOrReplaceMultimedia(LocalMultimedia multimedia) {
    int index = messages.indexWhere(
        (element) => element.message.localId == multimedia.messageId);
    if (index == -1) {
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
      messages[index] = messages[index].copyWith(multimedia: multimedia);
    }
    messages.refresh();
  }

  Future<void> dispatchTypingEvent(
      TypingEventType eventType, int conversationRemoteId) async {
    DispatchTypingEventUseCase useCase = di.getIt();
    await useCase.call(
      DispatchTypingEventRequest(
        conversationId: conversationRemoteId,
        eventType: eventType,
      ),
    );
  }

  Future<void> sendTextMessage(String body, [int? otherConversationId]) async {
    SendMessageRequest request = SendMessageRequest.withBody(
      conversationId: otherConversationId ?? conversationId,
      body: body,
    );
    _sendMessage(request);
  }

  Future<void> sendMultimediaMessage(String path,
      [int? otherConversationId]) async {
    SendMessageRequest request = SendMessageRequest.withMultimedia(
      conversationId: otherConversationId ?? conversationId,
      filePath: path,
      onSendProgress: (count, total) {},
      cancelToken: null,
    );
    _sendMessage(request);
  }

  Future<void> sendTextAndMultimediaMessage(String body, String path,
      [int? otherConversationId]) async {
    SendMessageRequest request = SendMessageRequest.withBodyAndMultimedia(
      conversationId: otherConversationId ?? conversationId,
      filePath: path,
      body: body,
      onSendProgress: (count, total) {},
      cancelToken: null,
    );
    _sendMessage(request);
  }

  Future<void> _sendMessage(SendMessageRequest request) async {
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
    _blockUnblockConversation(
      BlockUnblockConversationRequest(
        conversationId: conversationId,
        block: true,
      ),
    );
  }

  Future<void> unblockConversation() async {
    _blockUnblockConversation(
      BlockUnblockConversationRequest(
        conversationId: conversationId,
        block: false,
      ),
    );
  }

  Future<void> _blockUnblockConversation(
      BlockUnblockConversationRequest request) async {
    BlockUnblockConversationUseCase useCase = di.getIt();
    (await useCase(request)).fold(
      (failure) => {
        //
      },
      (success) {
        if (success) {
          //
        }
      },
    );
  }

  @override
  void onClose() {
    // textEditingController.dispose();
    super.onClose();
  }
}
