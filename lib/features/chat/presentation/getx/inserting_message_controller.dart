import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void onInit() {
    super.onInit();

    messageFieldFocusNode.addListener(() {
      if (messageFieldFocusNode.hasFocus) {
        emojiPickerShowing.value = false;
        // _conversationScreenController.scrollToFirstOrBottom(0);
      }
    });
    messageTextEdittingController.addListener(() {
      if (messageTextEdittingController.text != "") {
        sendButtonEnabled.value = true;
      } else {
        sendButtonEnabled.value = false;
      }
    });
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
      Get.back();
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
      _screenController.scrollToFirstOrBottom(true);
    }
  }

  @override
  void onClose() {
    // _videoPlayerController.dispose();
    messageTextEdittingController.dispose();
    super.onClose();
  }
}
