import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/avatar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/appbar/conversation_main_appbar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/image_message_widget.dart';

import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/chat_text_form_field_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/emoji_picker_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/send_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ConversationScreen extends StatelessWidget {
  final LocalConversation conversation;

  ConversationScreen({
    super.key,
    required this.conversation,
  });

  final ConversationScreenController _screenController = Get.find();

  final InsertingMessageController insertingMessageController = Get.put(
    InsertingMessageController(),
  );

  final MultimediaController multimediaController = Get.put(
    MultimediaController(),
  );

  final int currentUserId = SharedPref.currentUserId!;

  // final isSearching = false.obs;

  @override
  Widget build(BuildContext context) {
    // _screenController.conversationId = 5
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Obx(
          () => toggleAppBar(),
        ),
      ),
      body: WillPopScope(
        onWillPop: insertingMessageController.backButtonPressed,
        child: Column(
          children: [
            Expanded(
              child: GetX<ConversationController>(
                builder: (controller) {
                  return controller.messages.isEmpty
                      ? const Text("No Messages Yet")
                      : buildMessagesList(controller);
                },
              ),
            ),
            _buildFooter(context)
          ],
        ),
      ),
    );
  }

  ScrollablePositionedList buildMessagesList(
      ConversationController controller) {
    return ScrollablePositionedList.builder(
      shrinkWrap: true,
      itemCount: controller.messages.length,
      itemScrollController: _screenController.messagesScrollController,
      itemBuilder: (_, index) {
        final currentMessage = controller.messages[index];

        return Obx(
          () {
            return InkWell(
              onTap: () {
                _screenController.selectMessage(currentMessage.message.localId);
              },
              onLongPress: () {
                _screenController.selectionEnabled.value = true;
                _screenController.selectMessage(currentMessage.message.localId);
              },
              child: buildMessageWidget(currentMessage, index),
            );
          },
        );
      },
    );
  }

  Container buildMessageWidget(
      MessageAndMultimediaModel currentMessage, int index) {
    return Container(
      color: _screenController.selectedMessagesIds
                  .contains(currentMessage.message.localId) ||
              index == _screenController.searchSelectedMessage.value
          ? Colors.green.withOpacity(0.4)
          : null,
      child: MessageWidget(message: currentMessage),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 9),
      // color: Colors.grey,
      // alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: ChatTextFormFieldWidget(),
              ),
              Expanded(
                child: SendButtonWidget(
                  insertingMessageController: insertingMessageController,
                ),
              )
            ],
          ),
          //this widget shows or unshows its child based on the offstage value
          GetX<InsertingMessageController>(
            builder: (controller) => Offstage(
              offstage: !controller.emojiPickerShowing.value,
              child: SizedBox(
                height: 250,
                child: EmojiPickerWidget(
                  textEditingController:
                      insertingMessageController.messageTextEdittingController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar toggleAppBar() {
    if (_screenController.selectionEnabled.value) {
      return selectionAppBar();
    } else if (_screenController.isSearching.value) {
      // return SearchBar()
      return searchAppbar(_screenController);
    } else {
      return normalAppBar(_screenController, conversation);
    }
  }
}
