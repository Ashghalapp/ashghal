import 'dart:async';

import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TypingEventType {
  start,
  stop,
}

class InsertingMessageController extends GetxController {
  // final int conversationId;
  // InsertingMessageController({required this.conversationId});

  //A flag to track toggling between send and regiter button
  RxBool sendButtonEnabled = false.obs;
  //A flag to indicate if the emoji picker is showed or not
  RxBool emojiPickerShowing = false.obs;

  final TextEditingController messageTextEdittingController =
      TextEditingController();
  final FocusNode messageFieldFocusNode = FocusNode();
  final ConversationScreenController _screenController = Get.find();
  final ChatController _chatController = Get.find();
  final Duration typingEventDuration = const Duration(seconds: 5);
  Timer? _startTypingTimer;
  Timer? _stopTypingTimer;

  @override
  void onInit() {
    super.onInit();

    messageFieldFocusNode.addListener(() async {
      if (messageFieldFocusNode.hasFocus) {
        emojiPickerShowing.value = false;
        // _conversationScreenController.scrollToFirstOrBottom(0);
      }
      //is used to dispatch stop typing event based on some conditions
      await focuschange();
    });

    messageTextEdittingController.addListener(() {
      if (messageTextEdittingController.text != "") {
        sendButtonEnabled.value = true;
      } else {
        sendButtonEnabled.value = false;
      }
    });
    focuschange();
  }

  //onChange
  Future<void> sendTypingNotification(String value) async {
    if (value != "" &&
        _chatController.isSubscribed &&
        await AppServices.networkInfo.isConnected) {
      print("sendTypingNotification");
      //if the start timer is active we return, becuase no need to send a notification becuase its already sent
      if (_startTypingTimer?.isActive ?? false) return;

      //if the stop timer is active, we cancel it becuase we will start it again
      //for the next sent typing notification
      if (_stopTypingTimer?.isActive ?? false) _stopTypingTimer?.cancel();
      print("Typing start event dispatched");
      //we send the typing notification
      await _dispatchTypingEvent(TypingEventType.start);

      //set the start typing timer to 5 seconds, so we send event every 5 seconds
      _startTypingTimer = Timer(typingEventDuration, () {});
      //we set a timer to sent a stop typing, after the start typing timer in a second,
      //so if the user starts typing and the stops typing for a while(6 seconds) we send a stop typing event
      _stopTypingTimer = Timer(
        Duration(seconds: typingEventDuration.inSeconds),
        () async {
          print("_stopTypingTimer finshed and a typing stop event sent");
          await _dispatchTypingEvent(TypingEventType.stop);
        },
      );
    }
  }

  //onFocusChanged
  Future<void> focuschange() async {
    // messageFieldFocusNode.addListener(
    //   () {
    //if no typing notification sent, or if a typing notification already sent and
    //we receive focus on the text field we do nothing
    //other than that we stop the typing timer and send a stop typing notification
    print("focuschange");
    if (_startTypingTimer == null ||
        (_startTypingTimer != null && messageFieldFocusNode.hasFocus)) {
      return;
    }
    // if(_stopTypingTimer.isActive)
    print("Typing stop event dispatched");
    _stopTypingTimer?.cancel();
    await _dispatchTypingEvent(TypingEventType.stop);
    //   },
    // );
  }

  Future<void> _dispatchTypingEvent(TypingEventType eventType) async {
    await _screenController.conversationController
        .dispatchTypingEvent(eventType);
  }

  void imojiButtonPressed() {
    if (!emojiPickerShowing.value) {
      //unfocus message field so that the keyboard disappeared
      messageFieldFocusNode.unfocus();
      // messageFieldFocusNode.canRequestFocus = false;
    } else {
      messageFieldFocusNode.requestFocus();
    }
    emojiPickerShowing.value = !emojiPickerShowing.value;
  }

  Future<bool> backButtonPressed() {
    if (emojiPickerShowing.value) {
      emojiPickerShowing.value = false;
    } else if (messageFieldFocusNode.hasFocus) {
      messageFieldFocusNode.unfocus();
    } else if (_screenController.selectionEnabled.value) {
      _screenController.resetToNormalMode();
    } else if (_screenController.isSearching.value) {
      _screenController.resetToNormalMode();
    } else {
      _screenController.conversationController.markConversationMessagesAsRead();
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<void> sendMessage() async {
    if (sendButtonEnabled.value) {
      // SendMessageRequest request = SendMessageRequest.withBody(
      //   conversationId: _conversationScreenController.conversationId,
      //   body: messageTextEdittingController.text,
      // );
      _screenController.conversationController
          .sendTextMessage(messageTextEdittingController.text);
      // await _conversationController.sendMessage(request);
      messageTextEdittingController.clear();
      // _startTypingTimer?.cancel();
      // _stopTypingTimer?.cancel();
      _screenController.scrollToFirstOrBottom(true);
    }
  }

  @override
  void onClose() {
    // _videoPlayerController.dispose();
    messageTextEdittingController.dispose();
    if (_stopTypingTimer != null && _stopTypingTimer!.isActive) {
      _dispatchTypingEvent(TypingEventType.stop);
    }
    super.onClose();
  }
}
