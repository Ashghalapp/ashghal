import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/util/date_time_formatter.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/appbars/conversation_screen_appbar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation%20footer/conversations_screen_footer.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/reply_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// ignore: must_be_immutable
class ConversationScreen extends StatelessWidget {
  final LocalConversation conversation;
  // final LocalMessage? matchedMessage;
  ConversationScreen({
    super.key,
    required this.conversation,
  });

  final ConversationScreenController screenController = Get.find();
  final ConversationController _conversationController = Get.find();

  final InsertingMessageController insertingMessageController = Get.put(
    InsertingMessageController(),
  );

  final MultimediaController multimediaController = Get.put(
    MultimediaController(),
  );

  final AudioController audioController = Get.put(AudioController());

  final int currentUserId = SharedPref.currentUserId!;

  DateTime getDateMDY(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Get.isPlatformDarkMode ? ChatTheme.dark : ChatTheme.light,
      child: Scaffold(
        appBar: ConversationScreenAppBar(conversation: conversation),
        body: WillPopScope(
          onWillPop: screenController.backButtonPressed,
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () {
                    if (screenController.isLoading.value ||
                        _conversationController.isLoading.value) {
                      return AppUtil.addProgressIndicator(50);
                    }
                    return _conversationController.messages.isEmpty
                        ? Center(child: Text(AppLocalization.noMessagesYet.tr))
                        : Stack(
                            children: [
                              buildMessagesList(),
                              Obx(
                                () => screenController.showScrollDownIcon.value
                                    ? Positioned(
                                        bottom: 30,
                                        right: 8,
                                        child: InkWell(
                                          onTap: () => screenController
                                              .scrollToFirstOrBottom(true),
                                          child: Icon(
                                            Icons
                                                .keyboard_double_arrow_down_outlined,
                                            color: Get.isPlatformDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            size: 33,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          );
                  },
                ),
              ),
              Card(
                color: Get.isPlatformDarkMode
                    ? ChatColors.appBarDark
                    : ChatColors.appBarLight,
                margin: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Obx(
                      () {
                        if (screenController.replyMessage.value != null) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ReplyMessageWidget(
                              message: screenController.replyMessage.value!,
                              onCancelReply:
                                  screenController.cancelReplyMessage,
                              userName:
                                  screenController.currentConversation.userName,
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    ConversationScreenFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ScrollablePositionedList buildMessagesList() {
    return ScrollablePositionedList.builder(
      reverse: true,
      shrinkWrap: true,
      itemCount: _conversationController.messages.length,
      itemScrollController: screenController.messagesScrollController,
      itemPositionsListener: screenController.scrollListener,
      itemBuilder: (_, index) {
        final currentMessage =
            screenController.conversationController.messages[index];
        String? dateString = getGroupDateOnNewGroup(
          index,
          currentMessage.message,
        );
        return Column(
          children: [
            if (dateString != null) _builGroupTextDate(dateString),
            InkWell(
              onTap: () {
                screenController.selectMessage(currentMessage.message.localId);
              },
              onLongPress: () {
                screenController.selectionEnabled.value = true;
                screenController.selectMessage(currentMessage.message.localId);
              },
              child: Obx(
                () => Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  color: screenController.selectedMessagesIds
                              .contains(currentMessage.message.localId) ||
                          index == screenController.searchSelectedMessage.value
                      ? Colors.green.withOpacity(0.4)
                      : null,
                  child: MessageRowWidget(
                    message:
                        screenController.conversationController.messages[index],
                    onSwipe: () {
                      screenController.setReplyMessage(screenController
                          .conversationController
                          .messages[index]
                          .message
                          .remoteId!);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Container _builGroupTextDate(String dateString) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(dateString),
    );
  }

  String? getGroupDateOnNewGroup(int index, LocalMessage currentMessage) {
    bool isSameDate = false;
    String? dateString;

    // take care the messages list is reversed by the Listview
    // if the index 0 and the number of all messages are one
    // print("index $index");
    if (index == 0 && _conversationController.messages.length == 1) {
      dateString = groupMessageDateAndTime(currentMessage.createdAt);
    } else if (index == _conversationController.messages.length - 1) {
      dateString = groupMessageDateAndTime(currentMessage.createdAt);
    } else {
      final DateTime date = getDateMDY(currentMessage.createdAt);
      final DateTime prevDate = getDateMDY(
          _conversationController.messages[index + 1].message.createdAt);
      isSameDate = date.isAtSameMomentAs(prevDate);
      dateString = isSameDate
          ? null
          : groupMessageDateAndTime(
              _conversationController.messages[index].message.createdAt,
            );
    }
    return dateString;
  }

  static String groupMessageDateAndTime(DateTime dateTime) {
    final todayDate = DateTime.now();

    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final yesterday =
        DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    String difference = '';
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      difference = AppLocalization.today.tr;
    } else if (messageDate == yesterday) {
      difference = AppLocalization.chatYesterday.tr;
    } else {
      difference = DateTimeFormatter.formatDateTimeyMMMd(dateTime);
    }

    return difference;
  }
}
