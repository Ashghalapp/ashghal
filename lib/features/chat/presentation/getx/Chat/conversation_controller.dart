import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/block_unblock_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/clear_chat_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_messages_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/block_unblock_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/clear_chat.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/conversation_messages_read.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/delete_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/send_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversation_messages.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/dependency_injection.dart'
    as di;
import 'package:get/get.dart';

class ConversationController extends GetxController {
  RxList<LocalMessage> messages = <LocalMessage>[].obs;

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
    _listenToAllMessages();
    _markConversationMessagesAsRead();
  }

  void _listenToAllMessages() {
    print("Conversation ID" + conversationId.toString());
    WatchConversationMessages watchConversationMessages = di.getIt();
    watchConversationMessages(conversationId).listen((localMessages) {
      for (var localMessage in localMessages) {
        _insertOrReplaceMessage(localMessage);
      }
    });
  }

  void _insertOrReplaceMessage(LocalMessage message) {
    int index =
        messages.indexWhere((element) => element.localId == message.localId);
    if (index == -1) {
      messages.add(message);
    } else {
      messages[index] = message;
    }
  }

  void _markConversationMessagesAsRead() {
    print("Conversation ID" + conversationId.toString());
    ConversationMessagesReadUseCase conversationMessagesRead = di.getIt();
    conversationMessagesRead(conversationId);
  }

  Future<void> sendTextMessage(String body) async {
    SendMessageRequest request = SendMessageRequest.withBody(
      conversationId: conversationId,
      body: body,
    );
    _sendMessage(request);
  }

  Future<void> sendMultimediaMessage(String path) async {
    SendMessageRequest request = SendMessageRequest.withMultimedia(
      conversationId: conversationId,
      filePath: path,
      onSendProgress: (count, total) {},
    );
    _sendMessage(request);
  }

  Future<void> sendTextAndMultimediaMessage(String body, String path) async {
    SendMessageRequest request = SendMessageRequest.withBodyAndMultimedia(
      conversationId: conversationId,
      filePath: path,
      body: body,
      onSendProgress: (count, total) {},
    );
    _sendMessage(request);
  }

  Future<void> _sendMessage(SendMessageRequest request) async {
    SendMessageUseCase sendMessageUseCase = di.getIt();
    (await sendMessageUseCase.call(request)).fold(
      (failure) {
        //
      },
      (localMessage) {
        //
      },
    );
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
        messages
            .removeWhere((element) => messagesIds.contains(element.localId));
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
