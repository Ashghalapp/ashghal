import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/appbar/conversation_screen_appbar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/conversations_screen_footer.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/reply_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ConversationScreen extends StatelessWidget {
  final LocalConversation conversation;
  // final LocalMessage? matchedMessage;
  ConversationScreen({
    super.key,
    required this.conversation,
    // required this.screenController,
    // this.matchedMessage,
  });
  // : _screenController =
  //           Get.put(ConversationScreenController(conversation: conversation));

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
  MessageAndMultimediaModel replyMessage = MessageAndMultimediaModel(
    message: LocalMessage(
      localId: 1,
      senderId: 1,
      conversationId: 1,
      receivedLocally: false,
      readLocally: false,
      isStarred: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      body: "Reply Message",
    ),
    multimedia: LocalMultimedia(
      localId: 1,
      type: "image",
      size: 15,
      fileName: "image",
      messageId: 1,
      isCanceled: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

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
                        ? const Center(child: Text("No Messages Yet"))
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
                                            // size: 20,
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
                        // final replyMessage = screenController.replyMessage;
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

                    // Obx(
                    //   () =>
                    //       //  screenController.isReplyMessagePresent.value &&
                    //       screenController.replyMessage != null
                    //           ? Padding(
                    //               padding: const EdgeInsets.all(5.0),
                    //               child: ReplyMessageWidget(
                    //                 message:
                    //                     screenController.replyMessage!.value,
                    //                 onCancelReply:
                    //                     screenController.cancelReplyMessage,
                    //                 userName: screenController
                    //                     .currentConversation.userName,
                    //               ),
                    //             )
                    //           : const SizedBox.shrink(),
                    // ),
                    ConversationScreenFooter(),
                  ],
                ),
              ),

              // _buildFooter(context)
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

        // bool isSameDate = false;
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
                      // AppPrint.printInfo(screenController.conversationController
                      //     .messages[index].message.remoteId!
                      //     .toString());
                      // AppPrint.printInfo(index.toString());
                      // AppPrint.printInfo(messageRemoteId.toString());
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
        // return buildMessageWidget(
        //     _conversationController.messages[index], index, dateString ?? "");
      },
    );
  }

  // Widget buildMessageWidget(
  //   MessageAndMultimediaModel currentMessage,
  //   int index,
  //   String dateString,
  // ) {
  //   return Column(
  //     children: [
  //       if (dateString.isNotEmpty) _builGroupTextDate(dateString),
  //       InkWell(
  //         onTap: () {
  //           screenController.selectMessage(currentMessage.message.localId);
  //         },
  //         onLongPress: () {
  //           screenController.selectionEnabled.value = true;
  //           screenController.selectMessage(currentMessage.message.localId);
  //         },
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
  //           color: screenController.selectedMessagesIds
  //                       .contains(currentMessage.message.localId) ||
  //                   index == screenController.searchSelectedMessage.value
  //               ? Colors.green.withOpacity(0.4)
  //               : null,
  //           child: MessageRowWidget(message: currentMessage),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
      difference = "Today";
    } else if (messageDate == yesterday) {
      difference = "Yesterday";
    } else {
      difference = AppUtil.formatDateTimeyMMMd(dateTime);
    }

    return difference;
  }

  // Widget _buildFooter(BuildContext context) {
  //   return Card(
  //     color: Get.isPlatformDarkMode
  //         ? ChatColors.appBarDark
  //         : ChatColors.appBarLight,
  //     margin: const EdgeInsets.only(top: 0),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(15),
  //         topRight: Radius.circular(15),
  //       ),
  //     ),
  //     // color: Colors.grey,
  //     // alignment: Alignment.bottomCenter,

  //     // decoration: BoxDecoration(
  //     //   // color: Color.fromRGBO(25, 39, 52, 1),

  //     //   borderRadius: const BorderRadius.only(
  //     //     topLeft: Radius.circular(15),
  //     //     topRight: Radius.circular(15),
  //     //   ),
  //     // ),
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 8.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           Row(
  //             children: [
  //               // Expanded(
  //               //   flex: 5,
  //               //   child: ChatTextFormFieldWidget(),
  //               // ),
  //               Expanded(
  //                 child: SendButtonWidget(
  //                   insertingMessageController: insertingMessageController,
  //                 ),
  //               )
  //             ],
  //           ),
  //           //this widget shows or unshows its child based on the offstage value
  //           GetX<InsertingMessageController>(
  //             builder: (controller) => Offstage(
  //               offstage: !controller.emojiPickerShowing.value,
  //               child: SizedBox(
  //                 height: 250,
  //                 child: EmojiPickerWidget(
  //                   textEditingController: insertingMessageController
  //                       .messageTextEdittingController,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
